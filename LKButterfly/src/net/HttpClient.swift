//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import AlamofireImage
import Alamofire
import RxSwift
import Starscream


public enum HttpClient {
    
    static public let INSTANCE = Self.self
    public static var ioScheduler: Scheduler? = Schedulers.io()
    public static var responseScheduler: Scheduler? = MainScheduler.instance
    public static var immediateMode: Bool = false
    public static let GET: String = "GET"
    public static let POST: String = "POST"
    public static let PUT: String = "PUT"
    public static let PATCH: String = "PATCH"
    public static let DELETE: String = "DELETE"

    public static func cleanURL(_ url:String)->String{
        if url.contains("?"){
            let front = url.substringBefore(delimiter: "?")
            let back = url.substringAfter(delimiter: "?")
            let backParts = back.split(separator: "&")
            let fixedBack = backParts.joinToString("&") {
                $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed.union( CharacterSet(charactersIn: "%"))) ?? String($0)
            }
            return "\(front)?\(fixedBack)"
        }else{
            return url
        }
    }

    public static var defaultOptions = HttpOptions()
    public static var concurrentRequests = 0
    public static func call(url: String, method: String = "GET", headers: Dictionary<String, String> = [:], body: HttpBody? = nil, options: HttpOptions = HttpClient.defaultOptions) -> Single<HttpResponse> {
        print("HttpClient: Sending \(method) request to \(url) with headers \(headers)")
        print(cleanURL(url))
        let urlObj = URL(string: cleanURL(url))!
        var single = Single.create { (emitter: SingleEmitter<HttpResponse>) in
            
            var cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            switch(options.cacheMode){
            case .Default:
                cachePolicy = .reloadRevalidatingCacheData
            case .NoStore:
                cachePolicy = .reloadRevalidatingCacheData
            case .Reload:
                cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            case .NoCache:
                cachePolicy = .reloadRevalidatingCacheData
            case .ForceCache:
                cachePolicy = .returnCacheDataElseLoad
            case .OnlyIfCached:
                cachePolicy = .returnCacheDataDontLoad
            }
            
            var totalTimeout = options.callTimeout ?? 0
            if let c = options.connectTimeout, let w = options.writeTimeout, let r = options.readTimeout {
                if c == 0 || w == 0 || r == 0 {
                    totalTimeout = 0
                } else {
                    totalTimeout = c + w + r
                }
            }
            let totalTimeoutInterval = totalTimeout == 0 ? 60.0 * 15.0 : TimeInterval(totalTimeout / 1000)
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.requestCachePolicy = cachePolicy
            sessionConfig.timeoutIntervalForResource = totalTimeoutInterval
            sessionConfig.timeoutIntervalForRequest = totalTimeoutInterval
            sessionConfig.httpShouldSetCookies = false
            let session = URLSession(configuration: sessionConfig)
            var request = URLRequest(url: urlObj, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: totalTimeoutInterval)
            
            if headers["Accept"] == nil {
                request.setValue("application/json", forHTTPHeaderField: "Accept")
            }
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            request.httpMethod = method

            concurrentRequests += 1
            print("HttpClient: concurrentRequests = \(concurrentRequests)")
            let completionHandler = { [session] (data:Data?, response:URLResponse?, error:Error?) in
                let _ = session //We hold on this to ensure it doesn't get deinited
                concurrentRequests -= 1
                print("HttpClient: concurrentRequests = \(concurrentRequests)")
                if let casted = response as? HTTPURLResponse, let data = data {
                    print("HttpClient: Response from \(method) request to \(urlObj) with headers \(headers): \(casted.statusCode)")
                    emitter.onSuccess(HttpResponse(response: casted, data: data))
                } else if let error = error {
                    emitter.onError(error)
                } else {
                    print("HttpClient: ERROR!  Response is not URLResponse")
                    emitter.onError(IllegalStateException("Response is not URLResponse"))
                }
            }
            if let body = body {
                request.setValue(body.mediaType, forHTTPHeaderField: "Content-Type")
                session.uploadTask(with: request, from: body.data, completionHandler: completionHandler).resume()
            } else {
                session.dataTask(with: request, completionHandler: completionHandler).resume()
            }
        }
        if let io = ioScheduler {
            single = single.subscribeOn(io)
        }
        if let resp = responseScheduler {
            single = single.observeOn(resp)
        }
        return single.cache()
    }

    public static func callWithProgress<T>(url: String, method: String = "GET", headers: Dictionary<String, String> = [:], body: HttpBody? = nil, options: HttpOptions = HttpClient.defaultOptions, parse: @escaping (HttpResponse) -> Single<T>) -> Observable<HttpProgress<T>> {
        print("HttpClient: Sending \(method) request to \(url) with headers \(headers)")
        let toHold: Box<Array<Any>> = Box([])
        let urlObj = URL(string: cleanURL(url))!
        var obs = Observable.create { (emitter: ObservableEmitter<HttpProgress<T>>) in
            let completionHandler = { [toHold] (data:Data?, response:URLResponse?, error:Error?) in
                let _ = toHold //Holding to ensure it doesn't get cleaned up
                if let casted = response as? HTTPURLResponse, let data = data {
                    print("HttpClient: Response from \(method) request to \(url) with headers \(headers): \(casted.statusCode)")
                    emitter.onNext(HttpProgress(phase: .Read, ratio: 1))
                    parse(HttpResponse(response: casted, data: data)).subscribeBy { (error) in
                        emitter.onError(error)
                    } onSuccess: { (result: T) in
                        emitter.onNext(HttpProgress(phase: .Done, ratio: 1, response: result))
                    }.forever()
                } else if let error = error {
                    emitter.onError(error)
                } else {
                    print("HttpClient: ERROR!  Response is not URLResponse")
                    emitter.onError(IllegalStateException("Response is not URLResponse"))
                }
            }
            
            var cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            switch(options.cacheMode){
            case .Default:
                cachePolicy = .reloadRevalidatingCacheData
            case .NoStore:
                cachePolicy = .reloadRevalidatingCacheData
            case .Reload:
                cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            case .NoCache:
                cachePolicy = .reloadRevalidatingCacheData
            case .ForceCache:
                cachePolicy = .returnCacheDataElseLoad
            case .OnlyIfCached:
                cachePolicy = .returnCacheDataDontLoad
            }
            
            var totalTimeout = options.callTimeout ?? 0
            if let c = options.connectTimeout, let w = options.writeTimeout, let r = options.readTimeout {
                if c == 0 || w == 0 || r == 0 {
                    totalTimeout = 0
                } else {
                    totalTimeout = c + w + r
                }
            }
            let totalTimeoutInterval = totalTimeout == 0 ? 60.0 * 15.0 : TimeInterval(totalTimeout / 1000)
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.requestCachePolicy = cachePolicy
            sessionConfig.timeoutIntervalForResource = totalTimeoutInterval
            sessionConfig.timeoutIntervalForRequest = totalTimeoutInterval
            sessionConfig.httpShouldSetCookies = false
            let session = URLSession(configuration: sessionConfig)
            var request = URLRequest(url: urlObj, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: totalTimeoutInterval)
            if headers["Accept"] == nil {
                request.setValue("application/json", forHTTPHeaderField: "Accept")
            }
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            request.httpMethod = method

            if let body = body {
                request.setValue(body.mediaType, forHTTPHeaderField: "Content-Type")
                let task = session.uploadTask(with: request, from: body.data, completionHandler: completionHandler)
                if #available(iOS 11.0, *) {
                    let obs = task.progress.observe(\.fractionCompleted) { (progress, _) in
                        emitter.onNext(HttpProgress(phase: .Read, ratio: Float(progress.fractionCompleted)))
                    }
                    toHold.value.append(obs)
                }
                task.resume()
            } else {
                let task = session.dataTask(with: request, completionHandler: completionHandler)
                if #available(iOS 11.0, *) {
                    let obs = task.progress.observe(\.fractionCompleted) { (progress, _) in
                        emitter.onNext(HttpProgress(phase: .Read, ratio: Float(progress.fractionCompleted)))
                    }
                    toHold.value.append(obs)
                }
                task.resume()
            }
        }
        if let io = ioScheduler {
            obs = obs.subscribeOn(io)
        }
        if let resp = responseScheduler {
            obs = obs.observeOn(resp)
        }
        return obs.share(replay: 1)
    }

    public static func call(url: String, method: String = "GET", headers: Dictionary<String, String> = [:], body: HttpBody? = nil, callTimeout:Int64? = nil, writeTimeout:Int64? = nil, readTimeout:Int64?=nil,connectTimeout:Int64?=nil) -> Single<HttpResponse> {
        return call(url: url, method: method, headers: headers, body: body, options: HttpOptions(
            callTimeout: callTimeout,
            writeTimeout: writeTimeout,
            readTimeout: readTimeout,
            connectTimeout: connectTimeout
        ))
    }

    static public func webSocket(url: String) -> Observable<ConnectedWebSocket> {
        return Observable.using({ () -> ConnectedWebSocket in
            let out = ConnectedWebSocket(url: url)
            let request = URLRequest(url: URL(string: cleanURL(url))!)
            let socket = WebSocket(request: request)
            socket.delegate = out
            out.underlyingSocket = socket
            socket.connect()
            return out
        }, observableFactory: { $0.ownConnection })
    }

}
