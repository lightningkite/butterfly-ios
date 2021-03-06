// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: observables/TransformedMutableObservableProperty2.kt
// Package: com.lightningkite.butterfly.observables
import RxSwift
import Foundation

public class TransformedMutableObservableProperty2<A, B> : MutableObservableProperty<B> {
    public var basedOn: MutableObservableProperty<A>
    public var read:  (A) -> B
    public var write:  (A, B) -> A
    public init(basedOn: MutableObservableProperty<A>, read: @escaping  (A) -> B, write: @escaping  (A, B) -> A) {
        self.basedOn = basedOn
        self.read = read
        self.write = write
        super.init()
        //Necessary properties should be initialized now
    }
    
    override public func update() -> Void {
        self.basedOn.update()
    }
    
    override public var value: B {
        get {
            return self.read(self.basedOn.value)
        }
        set(value) {
            self.basedOn.value = self.write(self.basedOn.value, value)
        }
    }
    override public var onChange: Observable<B> {
        get {
            let readCopy = self.read
            return self.basedOn.onChange.map({ (it) -> B in readCopy(it) })
        }
    }
}

public extension MutableObservableProperty {
    func mapWithExisting<B>(read: @escaping  (T) -> B, write: @escaping  (T, B) -> T) -> MutableObservableProperty<B> {
        return (TransformedMutableObservableProperty2(basedOn: self as MutableObservableProperty<T>, read: read as (T) -> B, write: write as (T, B) -> T) as TransformedMutableObservableProperty2<T, B>)
    }
}


