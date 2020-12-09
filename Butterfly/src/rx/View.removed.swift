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

    func refreshLifecycle() {

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
    
    func removedDeinitHandler() {
        if let toRemove = UIView.disposablesExtension.remove(ObjectIdentifier(self)) {
            toRemove.forEach { $0.dispose() }
        }
        for view in self.subviews {
            view.removedDeinitHandler()
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
