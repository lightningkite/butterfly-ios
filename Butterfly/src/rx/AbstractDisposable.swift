import RxSwift

open class AbstractDisposable: Disposable {
    public var disposed: Bool = false
    public func dispose() -> Void {
        if !disposed {
            disposed = true
        }
    }
    open func onDispose() {
        
    }
    public init(){}
}
