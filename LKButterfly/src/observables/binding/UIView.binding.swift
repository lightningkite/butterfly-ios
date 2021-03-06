//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit


//--- UIView.bindVisible(ObservableProperty<Boolean>)
public extension UIView {
    func bindVisible(_ observable: ObservableProperty<Bool>) -> Void {
        observable.subscribeBy(onNext:  { ( value) in
            self.isHidden = !value
        }).until(self.removed)
    }
    func bindVisible(observable: ObservableProperty<Bool>) -> Void {
        return bindVisible(observable)
    }
}

//--- UIView.bindExists(ObservableProperty<Boolean>)
public extension UIView {
    func bindExists(_ observable: ObservableProperty<Bool>) -> Void {
        observable.subscribeBy(onNext:  { ( value) in
            self.includeInLayout = value
            self.isHidden = !value
        }).until(self.removed)
    }
    func bindExists(observable: ObservableProperty<Bool>) -> Void {
        return bindExists(observable)
    }
}
