import RxSwift
import UIKit

public extension UIView {
    private static var disposablesAssociationKey: UInt8 = 0
    private static var disposablesExtension: ExtensionProperty<UIView, Array<Disposable>> = ExtensionProperty()
    private static var beenActiveExtension: ExtensionProperty<UIView, Bool> = ExtensionProperty()
    private var disposables: Array<Disposable> {
        get {
            return UIView.disposablesExtension.getOrPut(self) { [] }
        }
        set(value) {
            UIView.disposablesExtension.set(self, value)
        }
    }

    func refreshLifecycle(){
        if let prop = UIView.lifecycleExtension.get(self) {
            if prop.value != (window != nil) {
                prop.value = window != nil
            }
        }

        let previouslyActive = UIView.beenActiveExtension.get(self) == true
        if !previouslyActive && window != nil {
            UIView.beenActiveExtension.set(self, true)
        }
        if previouslyActive && window == nil {
            disposables.forEach { $0.dispose() }
            disposables = []
        }

        for view in self.subviews {
            view.refreshLifecycle()
        }
    }

    private func connected() -> Bool {
        return self.window != nil || self.superview?.connected() ?? false
    }
    var removed: DisposeCondition {
        return DisposeCondition { it in
            self.disposables.append(it)
        }
    }
}
