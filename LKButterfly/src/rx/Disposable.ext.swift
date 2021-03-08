
import RxSwift

//--- Self.forever()
extension Disposable {
    @discardableResult
    public func forever() -> Self {
        return self
    }
}

//--- Self.until(DisposeCondition)
extension Disposable {
    @discardableResult
    public func until(condition: DisposeCondition) -> Self {
        condition.call(self)
        return self
    }
    @discardableResult
    public func until(_ condition: DisposeCondition) -> Self {
        return until(condition: condition)
    }
}

