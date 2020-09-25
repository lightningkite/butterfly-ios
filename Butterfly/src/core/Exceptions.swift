import Foundation

open class Exception: Error {
    public let message: String
    public let cause: Exception?
    public init(_ message: String = "?", _ cause: Exception? = nil) {
        self.message = message
        self.cause = cause
    }
}

public class IllegalStateException: Exception {}
public class IllegalArgumentException: Exception {}
public class NoSuchElementException: Exception {}

public extension Error {
    func printStackTrace(){
        print(self.localizedDescription)
    }
}