
public protocol Closeable {
    func close()
}


public class Close: Closeable {
    let closer: ()->Void
    public init(_ closer: @escaping () -> Void) {
        self.closer = closer
    }
    public var disposed: Bool = false
    public func isDisposed() -> Bool {
        return disposed
    }
    public func close() -> Void {
        self.disposed = true
        closer()
    }
}
