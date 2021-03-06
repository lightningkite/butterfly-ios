
// Generated by Khrysalis Swift converter
// File: rx/RxAddAndRunWeak.shared.kt
// Package: com.lightningkite.khrysalis.rx
import RxSwift
import Foundation

public extension Disposable {
    func solvePrivateDisposal(items: Array<Any>) -> Void {
        for item in (items){
            if let item = item as? UIView {
                self.until(condition: item.removed)
            }
        }
    }
}

public extension Observable where Element: Any {
    func add(listener: @escaping  (Element) -> Bool) -> Disposable {
        var disposable: Disposable? = nil
        let disp = self.subscribeBy(onNext: { (item: Element) -> Void in if listener(item) {
                    disposable?.dispose()
        } })
        disposable = disp
        return disp
    }
}

public extension Observable where Element: Any {
    @discardableResult func addWeak<A : AnyObject>(_ referenceA: A, listener: @escaping  (A, Element) -> Void) -> Disposable {
        return addWeak(referenceA: referenceA, listener: listener)
    }
    @discardableResult func addWeak<A : AnyObject>(referenceA: A, listener: @escaping  (A, Element) -> Void) -> Disposable {
        var disposable: Disposable? = nil
        weak var weakA: A? = referenceA
        let disp = self.subscribeBy(onNext: { (item: Element) -> Void in
                let a = weakA
                if let a = a {
                    listener(a, item)
                } else {
                    disposable?.dispose()
                }
        })
        disposable = disp
        disp.solvePrivateDisposal(items: [referenceA])
        return disp
    }
}

public extension Observable where Element: Any {
    @discardableResult func addWeak<A : AnyObject, B : AnyObject>(_ referenceA: A, _ referenceB: B, listener: @escaping  (A, B, Element) -> Void) -> Disposable {
        return addWeak(referenceA: referenceA, referenceB: referenceB, listener: listener)
    }
    @discardableResult func addWeak<A : AnyObject, B : AnyObject>(referenceA: A, referenceB: B, listener: @escaping  (A, B, Element) -> Void) -> Disposable {
        var disposable: Disposable? = nil
        weak var weakA: A? = referenceA
        weak var weakB: B? = referenceB
        let disp = self.subscribeBy(onNext: { (item: Element) -> Void in
                let a = weakA
                let b = weakB
                if let a = a, let b = b {
                    listener(a, b, item)
                } else {
                    disposable?.dispose()
                }
        })
        disposable = disp
        disp.solvePrivateDisposal(items: [referenceA, referenceB])
        return disp
    }
}


public extension Observable where Element: Any {
    @discardableResult func addWeak<A : AnyObject, B : AnyObject, C : AnyObject>(_ referenceA: A, _ referenceB: B, _ referenceC: C, listener: @escaping  (A, B, C, Element) -> Void) -> Disposable {
        return addWeak(referenceA: referenceA, referenceB: referenceB, referenceC: referenceC, listener: listener)
    }
    @discardableResult func addWeak<A : AnyObject, B : AnyObject, C : AnyObject>(referenceA: A, referenceB: B, referenceC: C, listener: @escaping  (A, B, C, Element) -> Void) -> Disposable {
        var disposable: Disposable? = nil
        weak var weakA: A? = referenceA
        weak var weakB: B? = referenceB
        weak var weakC: C? = referenceC
        let disp = self.subscribeBy(onNext: { (item: Element) -> Void in
                let a = weakA
                let b = weakB
                let c = weakC
                if let a = a, let b = b, let c = c {
                    listener(a, b, c, item)
                } else {
                    disposable?.dispose()
                }
        })
        disp.solvePrivateDisposal(items: [referenceA, referenceB, referenceC])
        disposable = disp
        return disp
    }
}
