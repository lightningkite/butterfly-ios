import UIKit

public enum ViewVisibility {
    case VISIBLE, INVISIBLE, GONE
}

public extension UIView {
    static var appForegroundColor: UIColor? = nil
    static var appAccentColor: UIColor? = nil
    
    @objc var elevation: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowOffset = CGSize(width: 0, height: value)
            layer.shadowRadius = value
            layer.shadowOpacity = 0.5
            layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    static var projectDrawableMap: Dictionary<String, Drawable> = [:]
    @objc var backgroundDrawableResource: String? {
        set(key){
            if let key = key, let value = UIView.projectDrawableMap[key] {
                backgroundLayer = value.makeLayer(self)
            } else {
                backgroundLayer = nil
            }
        }
        get {
            return nil
        }
    }
    
    var backgroundDrawable: Drawable? {
        set(value){
            if let value = value {
                backgroundLayer = value.makeLayer(self)
            } else {
                backgroundLayer = nil
            }
        }
        get {
            if let backgroundLayer = backgroundLayer {
                return Drawable { _ in backgroundLayer }
            } else {
                return nil
            }
        }
    }
    
    @objc var rotation: CGFloat {
        set(value){
            self.transform = CGAffineTransform(rotationAngle: value * .pi / 180.0)
        }
        get{
            let rad = atan2(self.transform.b, self.transform.a)
            return rad * (180 / .pi)
        }
    }
    
    static let VISIBLE = ViewVisibility.VISIBLE
    static let INVISIBLE = ViewVisibility.INVISIBLE
    static let GONE = ViewVisibility.GONE
    
    var visibility: ViewVisibility {
        get {
            if !includeInLayout {
                return .GONE
            } else if isHidden {
                return .INVISIBLE
            } else {
                return .VISIBLE
            }
        }
        set(value){
            switch value {
            case .GONE:
                includeInLayout = false
                isHidden = true
            case .INVISIBLE:
                includeInLayout = true
                isHidden = true
            case .VISIBLE:
                includeInLayout = true
                isHidden = false
            }
            setNeedsLayout()
        }
    }

    private static func printLayerInfo(layer: CALayer, indent: String = "") {
        print(indent + layer.debugDescription)
        for sub in layer.sublayers ?? [] {
            printLayerInfo(layer: sub, indent: indent + " ")
        }
    }
    private static let extensionBackgroundLayer = ExtensionProperty<UIView, CALayer>()
    var backgroundLayer: CALayer? {
        set(value){
            let previous = UIView.extensionBackgroundLayer.get(self)
            previous?.removeFromSuperlayer()
            if let value = value {
                value.matchSize(self)
                self.layer.insertSublayer(value, at: 0)
//                self.layer.addSublayer(value)
            }
            UIView.extensionBackgroundLayer.set(self, value)
        }
        get {
            return UIView.extensionBackgroundLayer.get(self)
        }
    }
    var backgroundResource: Drawable? {
        set(value){
            backgroundDrawable = value
        }
        get {
            return backgroundDrawable
        }
    }
    func setBackgroundColorResource(_ color: ColorResource) {
        backgroundColor = color
    }
    func setBackgroundColorResource(color: ColorResource) {
        backgroundColor = color
    }
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    func setBackgroundColor(_ color: Int64) {
        backgroundColor = color.asColor()
    }


    func postInvalidate() {
        setNeedsDisplay()
    }
    func invalidate() {
        setNeedsDisplay()
    }


    @objc func performClick(){
        TODO()
    }

    @objc func setOnClickListener(_ action: @escaping (UIView)->Void) {
        self.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer().addAction(until: removed) { [weak self] in
            if let self = self { action(self) }
        }
        retain(as: "onClickRecognizer", item: recognizer, until: removed)
        self.addGestureRecognizer(recognizer)
    }
    @objc func setOnLongClickListener(_ action: @escaping (UIView)->Bool) {
        self.isUserInteractionEnabled = true
        let recognizer = UILongPressGestureRecognizer()
        recognizer.addAction(until: removed) { [unowned recognizer, weak self] in
            if recognizer.state == .ended, let self = self {
                let _ = action(self)
            }
        }
        retain(as: "onLongClickRecognizer", item: recognizer, until: removed)
        self.addGestureRecognizer(recognizer)
    }

    @objc func onClick(action: @escaping ()->Void) {
        onClick(disabledMilliseconds: 500, action: action)
    }
    @objc func onClick(disabledMilliseconds: Int64, action: @escaping ()->Void) {
        self.isUserInteractionEnabled = true
        var lastActivated = Date()
        let recognizer = UITapGestureRecognizer().addAction(until: removed) {
            if Date().timeIntervalSince(lastActivated) > Double(disabledMilliseconds)/1000.0 {
                action()
                lastActivated = Date()
            }
        }
        retain(as: "onClickRecognizer", item: recognizer, until: removed)
        self.addGestureRecognizer(recognizer)
    }
    @objc func onLongClick(action: @escaping ()->Void) {
        self.isUserInteractionEnabled = true
        let recognizer = UILongPressGestureRecognizer()
        recognizer.addAction(until: removed) { [unowned recognizer, weak self] in
            if recognizer.state == .ended {
                action()
            }
        }
        retain(as: "onLongClickRecognizer", item: recognizer, until: removed)
        self.addGestureRecognizer(recognizer)
    }
    @objc func onLongClickWithGR(action: @escaping (UILongPressGestureRecognizer)->Void) {
        self.isUserInteractionEnabled = true
        let recognizer = UILongPressGestureRecognizer()
        recognizer.addAction(until: removed) { [unowned recognizer, weak self] in
            action(recognizer)
        }
        retain(as: "onLongClickRecognizer", item: recognizer, until: removed)
        self.addGestureRecognizer(recognizer)
    }

    static private let isIncludedExt = ExtensionProperty<UIView, Bool>()

    @objc var includeInLayout: Bool {
        get {
            return UIView.isIncludedExt.get(self) ?? true
        }
        set(value) {
            UIView.isIncludedExt.set(self, value)
            self.notifyParentSizeChanged()
            if let p = superview as? LinearLayout {
                p.recalculateConstraints()
            }
        }
    }

    func notifyParentSizeChanged() {
        if let p = self.superview {
            p.setNeedsLayout()
//             var current = p
//             while
//                 !(current is LinearLayout) &&
//                     !(current is FrameLayout) &&
//                     !(current is UIScrollView)
//             {
//                 if let su = current.superview {
//                     current = su
//                     if let cell = current as? ObsUICollectionViewCell {
//                         cell.refreshSize()
//                         break
//                     }
//                 } else {
//                     break
//                 }
//             }
        }
    }

    func post(_ action: @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: action)
    }
}

extension UIButton {
    @objc override public func onClick(action: @escaping ()->Void) {
        onClick(disabledMilliseconds: 500, action: action)
    }
    @objc override public func onClick(disabledMilliseconds: Int64, action: @escaping ()->Void) {
        var lastActivated = Date()
        self.addAction {
            if Date().timeIntervalSince(lastActivated) > Double(disabledMilliseconds)/1000.0 {
                action()
                lastActivated = Date()
            }
        }
    }
}

public extension UIControl {
    @objc override func performClick(){
        self.sendActions(for: .primaryActionTriggered)
    }
}
