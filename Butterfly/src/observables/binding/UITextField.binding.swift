//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit


//--- EditText.bindString(MutableObservableProperty<String>)
public extension UITextField {
    func bindString(_ observable: MutableObservableProperty<String>) -> Void {
        delegate = DoneDelegate.shared
        observable.subscribeBy { ( value) in
            if self.textString != value {
                self.textString = value
            }
            self.notifyParentSizeChanged()
        }.until(self.removed)
        addAction(for: UITextField.Event.editingChanged) { [weak self] in
            if observable.value != self?.textString {
                observable.value = self?.textString ?? ""
            }
        }
    }
    func bindString(observable: MutableObservableProperty<String>) -> Void {
        return bindString(observable)
    }
}
public extension UITextView {
    class LambdaDelegate: NSObject, UITextViewDelegate {
        let action: (String) -> Void

        init(action: @escaping (String) -> Void) {
            self.action = action
            super.init()
        }

        public func textViewDidChange(_ textView: UITextView) {
            action(textView.textString)
        }
    }
    func bindString(_ observable: MutableObservableProperty<String>) -> Void {
        observable.subscribeBy { ( value) in
            if self.textString != value {
                self.textString = value
            }
            self.notifyParentSizeChanged()
        }.until(self.removed)
        let delegate = LambdaDelegate { text in
            if observable.value != text {
                observable.value = text
            }
        }
        retain(as: "butterfly_dg", item: delegate, until: removed)
        self.delegate = delegate
    }
    func bindString(observable: MutableObservableProperty<String>) -> Void {
        return bindString(observable)
    }
}

//--- EditText.bindInteger(MutableObservableProperty<Int>)
public extension UITextField {
    func bindInteger(_ observable: MutableObservableProperty<Int>) -> Void {
        delegate = DoneDelegate.shared
        observable.subscribeBy { ( value) in
            let currentValue = Int(self.textString) ?? 0
            if currentValue != Int(value) {
                self.textString = String(value)
                self.notifyParentSizeChanged()
            }
        }.until(self.removed)
        addAction(for: UITextField.Event.editingChanged) { [weak self] in
            if let self = self {
                let currentValue = Int(self.textString) ?? 0
                if observable.value != currentValue {
                    observable.value = Int(currentValue)
                }
            }
        }
    }
    func bindInteger(observable: MutableObservableProperty<Int>) -> Void {
        return bindInteger(observable)
    }
}

//--- EditText.bindDouble(MutableObservableProperty<Double>)
public extension UITextField {
    func bindDouble(_ observable: MutableObservableProperty<Double>) -> Void {
        delegate = DoneDelegate.shared
        observable.subscribeBy { ( value) in
            let currentValue = Double(self.textString) ?? 0
            if currentValue != Double(value) {
                self.textString = String(value)
                self.notifyParentSizeChanged()
            }
        }.until(self.removed)
        addAction(for: UITextField.Event.editingChanged) { [weak self] in
            if let self = self {
                let currentValue = Double(self.textString) ?? 0
                if observable.value != currentValue {
                    observable.value = Double(currentValue)
                }
            }
        }
    }
    func bindDouble(observable: MutableObservableProperty<Double>) -> Void {
        return bindDouble(observable)
    }
}

//--- EditText.bindIntegerNullable(MutableObservableProperty<Int?>)
public extension UITextField {
    func bindIntegerNullable(_ observable: MutableObservableProperty<Int?>) -> Void {
        delegate = DoneDelegate.shared
        observable.subscribeBy { ( value) in
            let currentValue = Int(self.textString)
            if currentValue != value {
                if let value = value {
                    self.textString = String(value)
                } else {
                    self.textString = ""
                }
                self.notifyParentSizeChanged()
            }
        }.until(self.removed)
        addAction(for: UITextField.Event.editingChanged) { [weak self] in
            if let self = self {
                let currentValue = Int(self.textString)
                if observable.value != currentValue {
                    observable.value = currentValue
                }
            }
        }
    }
    func bindIntegerNullable(observable: MutableObservableProperty<Int?>) -> Void {
        return bindInteger(observable)
    }
}

//--- EditText.bindDoubleNullable(MutableObservableProperty<Double?>)
public extension UITextField {
    func bindDoubleNullable(_ observable: MutableObservableProperty<Double?>) -> Void {
        delegate = DoneDelegate.shared
        observable.subscribeBy { ( value) in
            let currentValue = Double(self.textString)
            if currentValue != value {
                if let value = value {
                    self.textString = String(value)
                } else {
                    self.textString = ""
                }
                self.notifyParentSizeChanged()
            }
        }.until(self.removed)
        addAction(for: UITextField.Event.editingChanged) { [weak self] in
            if let self = self {
                let currentValue = Double(self.textString)
                if observable.value != currentValue {
                    observable.value = currentValue
                }
            }
        }
    }
    func bindDoubleNullable(observable: MutableObservableProperty<Double?>) -> Void {
        return bindDouble(observable)
    }
}

public extension UITextField {
    func bindString(_ observable: ObservableProperty<String>) {
        return bindString(observable: observable)
    }
    func bindString(observable: ObservableProperty<String>) {
        observable.subscribeBy { ( value) in
            if self.textString != value {
                self.textString = value
            }
            self.notifyParentSizeChanged()
        }.until(self.removed)
    }
}
public extension UIButton {
    func bindString(_ observable: ObservableProperty<String>) {
        return bindString(observable: observable)
    }
    func bindString(observable: ObservableProperty<String>) {
        observable.subscribeBy { ( value) in
            if self.title(for: .normal) != value {
                self.textString = value
            }
            self.notifyParentSizeChanged()
        }.until(self.removed)
    }
}

public extension UITextView {
    func bindStringRes(_ observableReference: ObservableProperty<StringResource?>) {
        return bindStringRes(observableReference: observableReference)
    }
    func bindStringRes(observableReference: ObservableProperty<StringResource?>) {
        observableReference.subscribeBy { ( value) in
            if let value = value {
                let localValue = NSLocalizedString(value, comment: "")
                if self.textString != localValue {
                    self.textString = localValue
                }
            } else {
                self.text = nil
            }
            self.notifyParentSizeChanged()
        }.until(self.removed)
    }
}
public extension UITextField {
    func bindStringRes(_ observableReference: ObservableProperty<StringResource?>) {
        return bindStringRes(observableReference: observableReference)
    }
    func bindStringRes(observableReference: ObservableProperty<StringResource?>) {
        observableReference.subscribeBy { ( value) in
            if let value = value {
                let localValue = NSLocalizedString(value, comment: "")
                if self.textString != localValue {
                    self.textString = localValue
                }
            } else {
                self.text = nil
            }
            self.notifyParentSizeChanged()
        }.until(self.removed)
    }
}
public extension UITextView {
    func bindString(_ observable: ObservableProperty<String>) {
        return bindString(observable: observable)
    }
    func bindString(observable: ObservableProperty<String>) {
        observable.subscribeBy { ( value) in
            if self.textString != value {
                self.textString = value
            }
            self.notifyParentSizeChanged()
        }.until(self.removed)
    }
}