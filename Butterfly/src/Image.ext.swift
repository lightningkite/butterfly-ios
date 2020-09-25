//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit


public typealias Bitmap = UIImage

public func loadImage(image: Image, onResult: @escaping (Bitmap?) -> Void) -> Void {
    switch(image){
    case let image as ImageReference:
        loadImage(uri: image.uri, onResult: onResult)
    case let image as ImageBitmap:
        onResult(image.bitmap)
    case let image as ImageRaw:
        onResult(UIImage(data: image.raw))
    case let image as ImageRemoteUrl:
        loadImage(image.url, onResult)
    default:
        onResult(nil)
    }
}
public func loadImage(uri: URL, maxDimension: Int32 = 2048, onResult: @escaping (Bitmap?) -> Void) -> Void {
    URLSession.shared.dataTask(with: uri, completionHandler: { data, response, error in
        DispatchQueue.main.async {
            if let data = data {
                onResult(UIImage(data: data))
            } else {
                onResult(nil)
            }
        }
    }).resume()
}

public func loadImage(url: String, onResult: @escaping (Bitmap?) -> Void) -> Void {
    URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
        DispatchQueue.main.async {
            if let data = data {
                onResult(UIImage(data: data))
            } else {
                onResult(nil)
            }
        }
    }).resume()
}

public extension Image {
    func load(_ onResult: @escaping (Bitmap?) -> Void) -> Void {
        return loadImage(self, onResult)
    }
    func load() -> Single<Bitmap> {
        switch self {
        case let self as ImageRaw:
            if let image = UIImage(data: self.raw) {
                return Single.just(image)
            } else {
                return Single.error(IllegalArgumentException("Could not parse image"))
            }
        case let self as ImageReference:
            return loadUrl(url: self.uri).map { UIImage(data: $0.second)! }
        case let self as ImageBitmap:
            return Single.just(self.bitmap)
        case let self as ImageRemoteUrl:
            if let url = URL(string: self.url) {
                return loadUrl(url: url).map { UIImage(data: $0.second)! }
            } else {
                return Single.error(IllegalArgumentException("Invalid URL \(self.url)"))
            }
        default:
            return Single.error(IllegalArgumentException("Unknown image type \(self)"))
        }
    }
}

private func loadUrl(url: URL) -> Single<Pair<String, Data>> {
    return Single.create { (em) in
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode / 100 == 2, let data = data {
                        let mediaType = response.mimeType ?? "application/octet-stream"
                        em.onSuccess(Pair(first: mediaType, second: data))
                    } else if let error = error {
                        em.onError(error)
                    } else {
                        em.onError(HttpResponseException(response: HttpResponse(response: response, data: data ?? Data())))
                    }
                } else if let response = response {
                    if let data = data {
                        let mediaType = response.mimeType ?? "application/octet-stream"
                        em.onSuccess(Pair(first: mediaType, second: data))
                    } else if let error = error {
                        em.onError(error)
                    } else {
                        em.onError(IllegalStateException("Conversion to HttpBody failed for an unknown reason"))
                    }
                } else {
                    em.onError(IllegalStateException("Conversion to HttpBody failed for an unknown reason"))
                }
            }
        }).resume()
    }
}

public extension ImageReference {
    func load(maxDimension: Int32) -> Single<Bitmap> {
        return HttpClient.call(url: self.uri.absoluteString).unsuccessfulAsError().map { UIImage(data: $0.data)! }
    }
}

