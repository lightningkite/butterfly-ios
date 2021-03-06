//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit


//--- TextView.bindString(ObservableProperty<String>)
public extension UILabel {
    func bindString(_ observable: ObservableProperty<String>) -> Void {
        observable.subscribeBy(onNext:  { ( value) in
            if self.textString != value {
                self.textString = value
            }
            self.notifyParentSizeChanged()
        }).until(self.removed)
    }
    func bindString(observable: ObservableProperty<String>) -> Void {
        return bindString(observable)
    }
}

//--- TextView.bindStringRes(ObservableProperty<StringResource?>)
public extension UILabel {
    func bindStringRes(_ observable: ObservableProperty<StringResource?>) -> Void {
        observable.subscribeBy(onNext:  { ( value) in
            if let value = value {
                let localValue = NSLocalizedString(value, comment: "")
                if self.textString != localValue {
                    self.textString = localValue
                }
            } else {
                self.text = nil
            }
            self.notifyParentSizeChanged()
        }).until(self.removed)
    }
    func bindStringRes(observable: ObservableProperty<StringResource?>) -> Void {
        return bindStringRes(observable)
    }
}
public extension UIButton {
    func bindStringRes(_ observableReference: ObservableProperty<StringResource?>) {
        return bindStringRes(observable: observableReference)
    }
    func bindStringRes(observable observableReference: ObservableProperty<StringResource?>) {
        observableReference.subscribeBy(onNext:  { ( value) in
            if let value = value {
                if self.title(for: .normal) != value {
                    self.textString = value
                }
            } else {
                self.textString = ""
            }
            self.notifyParentSizeChanged()
        }).until(self.removed)
    }
}

//--- TextView.bindText(ObservableProperty<T>, (T)->String)
public extension UILabel {
    func bindText<T>(_ observable: ObservableProperty<T>, _ transform: @escaping (T) -> String) -> Void {
        observable.subscribeBy(onNext:  { ( value) in
            let textValue = transform(value)
            if self.textString != textValue {
                self.textString = textValue
            }
            self.notifyParentSizeChanged()
        }).until(self.removed)
    }
    func bindText<T>(observable: ObservableProperty<T>, transform: @escaping (T) -> String) -> Void {
        return bindText(observable, transform)
    }
}
