// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: rx/DisposeCondition.kt
// Package: com.lightningkite.butterfly.rx
import RxSwift
import Foundation

public class DisposeCondition {
    public var call:  (Disposable) -> Void
    public init(call: @escaping  (Disposable) -> Void) {
        self.call = call
        //Necessary properties should be initialized now
    }
}

public extension DisposeCondition {
    func and(other: DisposeCondition) -> DisposeCondition { return andAllDisposeConditions(list: [self, other]) }
}

public func andAllDisposeConditions(list: Array<DisposeCondition>) -> DisposeCondition { return DisposeCondition(call: { (it) -> Void in 
            var disposalsLeft = list.count
            for item in (list){
                item.call(DisposableLambda(lambda: { () -> Void in 
                            disposalsLeft = disposalsLeft - 1
                            if disposalsLeft == 0 { it.dispose() }
                }))
            }
}) }

public extension DisposeCondition {
    func or(other: DisposeCondition) -> DisposeCondition { return DisposeCondition(call: { (it) -> Void in 
                self.call(it); other.call(it)
    }) }
}


