import Foundation

public typealias HttpMediaType = String
public enum HttpMediaTypes {
    public static var JSON = "application/json"
    public static var TEXT = "text/plain"
    public static var JPEG = "image/jpeg"
}

public func mediaTypeOrNull(_ value: String) -> String? {
    return
}