
import Foundation
import RxSwift

public struct HttpResponse {
    public let response: HTTPURLResponse
    public let data: Data
    public init(response: HTTPURLResponse, data: Data) {
        self.response = response
        self.data = data
    }

    public var code: Int {
        return Int(self.response.statusCode)
    }

    public var isSuccessful: Bool {
        let code = self.response.statusCode
        return code >= 200 && code < 300
    }


    public var headers: Dictionary<String, String> {
        return Dictionary(self.response.allHeaderFields
        .filter { it in it.0 is String && it.1 is String }
        .map { it in (it.key as! String, it.value as! String) }, uniquingKeysWith: { _, a in a} )
    }


    public func discard() -> Single<Void> {
        //Do nothing - in iOS, the data is already read
        //This is primarly a stub for when this code is changed out to stream results.
        return Single.just(())
    }

    public func readText() -> Single<String> {
        return Single.just(String(data: data, encoding: .utf8)!)
    }


    public func readData() -> Single<Data> {
        return Single.just(data)
    }
    

    public func readJson<T: Codable>() -> Single<T> {
        do {
            return Single.just(try T.fromJsonData(data))
        } catch {
            return Single.error(error)
        }
    }

    public func readJsonDebug<T: Codable>() -> Single<T> {
        do {
            print("Got response \(String(data: data, encoding: .utf8)!)")
            return Single.just(try T.fromJsonData(data))
        } catch {
            return Single.error(error)
        }
    }
    

}
