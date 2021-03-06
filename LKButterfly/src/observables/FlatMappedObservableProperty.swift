// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: observables/FlatMappedObservableProperty.kt
// Package: com.lightningkite.butterfly.observables
import RxSwift
import Foundation

public class FlatMappedObservableProperty<A, B> : ObservableProperty<B> {
    public var basedOn: ObservableProperty<A>
    public var transformation:  (A) -> ObservableProperty<B>
    public init(basedOn: ObservableProperty<A>, transformation: @escaping  (A) -> ObservableProperty<B>) {
        self.basedOn = basedOn
        self.transformation = transformation
        super.init()
        //Necessary properties should be initialized now
    }
    
    override public var value: B {
        get { return self.transformation(self.basedOn.value).value }
    }
    override public var onChange: Observable<B> {
        get {
            let transformCopy = self.transformation
            return self.basedOn.observable.switchMap({ (it) -> Observable<B> in transformCopy(it).observable }).skip(1)
        }
    }
}

public extension ObservableProperty {
    func switchMap<B>(transformation: @escaping  (T) -> ObservableProperty<B>) -> FlatMappedObservableProperty<T, B> {
        return (FlatMappedObservableProperty(basedOn: self as ObservableProperty<T>, transformation: transformation as (T) -> ObservableProperty<B>) as FlatMappedObservableProperty<T, B>)
    }
}

public extension ObservableProperty {
    func flatMap<B>(transformation: @escaping  (T) -> ObservableProperty<B>) -> FlatMappedObservableProperty<T, B> {
        return (FlatMappedObservableProperty(basedOn: self as ObservableProperty<T>, transformation: transformation as (T) -> ObservableProperty<B>) as FlatMappedObservableProperty<T, B>)
    }
}

public func xObservablePropertySwitchMapNotNull<T : Any, B : Any>(_ this: ObservableProperty<T?>, transformation: @escaping  (T) -> ObservableProperty<B?>) -> FlatMappedObservableProperty<T?, B?> {
    return (FlatMappedObservableProperty(basedOn: this as ObservableProperty<T?>, transformation: { (item) -> ObservableProperty<B?> in if let item = item { return transformation(item) } else { return (ConstantObservableProperty(underlyingValue: nil as B?) as ConstantObservableProperty<B?>) } } as (T?) -> ObservableProperty<B?>) as FlatMappedObservableProperty<T?, B?>)
}

public func xObservablePropertyFlatMapNotNull<T : Any, B : Any>(_ this: ObservableProperty<T?>, transformation: @escaping  (T) -> ObservableProperty<B?>) -> FlatMappedObservableProperty<T?, B?> {
    return (FlatMappedObservableProperty(basedOn: this as ObservableProperty<T?>, transformation: { (item) -> ObservableProperty<B?> in if let item = item { return transformation(item) } else { return (ConstantObservableProperty(underlyingValue: nil as B?) as ConstantObservableProperty<B?>) } } as (T?) -> ObservableProperty<B?>) as FlatMappedObservableProperty<T?, B?>)
}

public class MutableFlatMappedObservableProperty<A, B> : MutableObservableProperty<B> {
    public var basedOn: ObservableProperty<A>
    public var transformation:  (A) -> MutableObservableProperty<B>
    public init(basedOn: ObservableProperty<A>, transformation: @escaping  (A) -> MutableObservableProperty<B>) {
        self.basedOn = basedOn
        self.transformation = transformation
        self.lastProperty = nil
        super.init()
        //Necessary properties should be initialized now
    }
    
    override public var value: B {
        get { return self.transformation(self.basedOn.value).value }
        set(value) {
            self.transformation(self.basedOn.value).value = value
        }
    }
    
    public var lastProperty: MutableObservableProperty<B>?
    
    override public var onChange: Observable<B> {
        get {
            let transformCopy = self.transformation
            return self.basedOn.observable.switchMap( { [weak self] (it: A) -> Observable<B> in 
                    let prop = transformCopy(it)
                    self?.lastProperty = prop
                    return prop.observable
            }).skip(1)
        }
    }
    
    override public func update() -> Void {
        self.lastProperty?.update()
    }
}

public extension ObservableProperty {
    func switchMapMutable<B>(transformation: @escaping  (T) -> MutableObservableProperty<B>) -> MutableFlatMappedObservableProperty<T, B> {
        return (MutableFlatMappedObservableProperty(basedOn: self as ObservableProperty<T>, transformation: transformation as (T) -> MutableObservableProperty<B>) as MutableFlatMappedObservableProperty<T, B>)
    }
}

public extension ObservableProperty {
    func flatMapMutable<B>(transformation: @escaping  (T) -> MutableObservableProperty<B>) -> MutableFlatMappedObservableProperty<T, B> {
        return (MutableFlatMappedObservableProperty(basedOn: self as ObservableProperty<T>, transformation: transformation as (T) -> MutableObservableProperty<B>) as MutableFlatMappedObservableProperty<T, B>)
    }
}


