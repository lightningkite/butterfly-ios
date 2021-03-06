// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: observables/SharingObservableProperty.kt
// Package: com.lightningkite.butterfly.observables
import RxSwift
import Foundation

public class SharingObservableProperty<T> : ObservableProperty<T> {
    public var basedOn: ObservableProperty<T>
    public var startAsListening: Bool
    public init(basedOn: ObservableProperty<T>, startAsListening: Bool = false) {
        self.basedOn = basedOn
        self.startAsListening = startAsListening
        self.cachedValue = basedOn.value
        self.isListening = startAsListening
        super.init()
        //Necessary properties should be initialized now
        self._onChange = self.basedOn.onChange
            .doOnNext( { [weak self] (it) -> Void in self?.cachedValue = it })
            .doOnSubscribe( { [weak self] (it) -> Void in self?.isListening = true })
            .doOnDispose( { [weak self] () -> Void in self?.isListening = false })
            .share()
    }
    
    public var cachedValue: T
    public var isListening: Bool
    override public var value: T {
        get { return self.isListening ? self.cachedValue : self.basedOn.value }
    }
    
    public var _onChange: (Observable<T>)!
    override public var onChange: Observable<T> {
        get { return _onChange }
    }
}

public extension ObservableProperty {
    func share(startAsListening: Bool = false) -> SharingObservableProperty<T> {
        return (SharingObservableProperty(basedOn: self as ObservableProperty<T>, startAsListening: startAsListening) as SharingObservableProperty<T>)
    }
}

