import RxSwift

//--- DisposableLambda.{
public class DisposableLambda: Disposable {
    
    public var lambda:  () -> Void
    
    //--- DisposableLambda.disposed
    //--- DisposableLambda.isDisposed()
    public var disposed: Bool
    
    //--- DisposableLambda.dispose()
    public func dispose() -> Void {
        if !disposed {
            disposed = true
            lambda()
        }
    }
    
    //--- DisposableLambda.Primary Constructor
    public init(lambda: @escaping () -> Void) {
        self.lambda = lambda
        let disposed: Bool = false
        self.disposed = disposed
    }
    convenience public init(_ lambda: @escaping () -> Void) {
        self.init(lambda: lambda)
    }
    //--- DisposableLambda.}
}
