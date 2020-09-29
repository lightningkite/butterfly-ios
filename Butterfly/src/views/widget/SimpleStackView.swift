//
//  CustomStackView.swift
//  layout-test
//
//  Created by Joseph Ivie on 9/26/20.
//

import UIKit

@IBDesignable
public class SimpleStackView: UIView {

    @IBInspectable
    public var automaticConstraintPriority: Int = 500

    @IBInspectable
    public var vertical: Bool = false {
        didSet {
            recalculateConstraints()
        }
    }

    @IBInspectable
    public var reverse: Bool = false {
        didSet {
            recalculateConstraints()
        }
    }
    
    @IBInspectable
    public var fills: Bool = false {
        didSet {
            recalculateConstraints()
        }
    }
    
    @IBInspectable
    public var defaultMargin: CGFloat = 8 {
        didSet {
            recalculateConstraints()
        }
    }
    
    public class LayoutParams {
        var show: Bool = true
        var start: CGFloat? = nil
        var end: CGFloat? = nil
    }

    private var endAttr: NSLayoutConstraint.Attribute {
        if vertical {
            if reverse {
                return .top
            } else {
                return .bottom
            }
        } else {
            if reverse {
                return .leading
            } else {
                return .trailing
            }
        }
    }

    private var startAttr: NSLayoutConstraint.Attribute {
        if vertical {
            if reverse {
                return .bottom
            } else {
                return .top
            }
        } else {
            if reverse {
                return .trailing
            } else {
                return .leading
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit(){
    }

    private var lastView: UIView?
    private var fillConstraint: NSLayoutConstraint?
    private var myConstraints: Array<NSLayoutConstraint> = []
    
    private func reverseMargin(_ thing: CGFloat) -> CGFloat {
        if reverse {
            return thing
        } else {
            return -thing
        }
    }

    private func addConstraintForSubview(_ view: UIView) {
        guard view.simpleStackViewParamsOrNil?.show != false else { return }
        if let lastView = lastView {
            let margin = (lastView.simpleStackViewParamsOrNil?.end ?? defaultMargin) + (view.simpleStackViewParamsOrNil?.start ?? defaultMargin)
            let cons = NSLayoutConstraint(item: lastView, attribute: endAttr, relatedBy: .equal, toItem: view, attribute: startAttr, multiplier: 1.0, constant: reverseMargin(margin))
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            myConstraints.append(cons)
        } else {
            let margin = view.simpleStackViewParamsOrNil?.start ?? defaultMargin
            let cons = NSLayoutConstraint(item: self, attribute: startAttr.toMargin, relatedBy: .equal, toItem: view, attribute: startAttr, multiplier: 1.0, constant: reverseMargin(margin))
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            myConstraints.append(cons)
        }
        self.lastView = view
    }

    private func handleFillConstraint(){
        fillConstraint?.isActive = false
        if fills, let view = subviews.last {
            let margin = view.simpleStackViewParamsOrNil?.end ?? defaultMargin
            let cons = NSLayoutConstraint(item: view, attribute: endAttr, relatedBy: .equal, toItem: self, attribute: endAttr.toMargin, multiplier: 1.0, constant: reverseMargin(margin))
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            fillConstraint = cons
        }
    }

    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        addConstraintForSubview(view)
        handleFillConstraint()
    }

    public func recalculateConstraints(){
        for c in myConstraints {
            c.isActive = false
        }
        lastView = nil
        for s in subviews {
            addConstraintForSubview(s)
        }
        handleFillConstraint()
    }
}

public extension UIView {
    private static let simpleStackViewParams = ExtensionProperty<UIView, SimpleStackView.LayoutParams>()
    var simpleStackViewParams: SimpleStackView.LayoutParams {
        return UIView.simpleStackViewParams.getOrPut(self) { SimpleStackView.LayoutParams() }
    }
    var simpleStackViewParamsOrNil: SimpleStackView.LayoutParams? {
        return UIView.simpleStackViewParams.get(self)
    }

    @objc
    var ssv_show: Bool {
        get { return simpleStackViewParams.show }
        set(value) {
            simpleStackViewParams.show = value
            if let superview = superview as? SimpleStackView {
                superview.recalculateConstraints()
            }
        }
    }
    @objc var ssv_start: CGFloat {
        get { return simpleStackViewParams.start ?? 0 }
        set(value) {
            simpleStackViewParams.start = value
            if let superview = superview as? SimpleStackView {
                superview.recalculateConstraints()
            }
        }
    }
    @objc var ssv_end: CGFloat {
        get { return simpleStackViewParams.end ?? 0 }
        set(value) {
            simpleStackViewParams.end = value
            if let superview = superview as? SimpleStackView {
                superview.recalculateConstraints()
            }
        }
    }
}

private struct WeakBox<T: AnyObject> {
    weak var item: T?
}

private extension NSLayoutConstraint.Attribute {
    var name: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            return "unknown"
        }
    }
    var toMargin: NSLayoutConstraint.Attribute {
        switch self {
        case .left:
            return .leftMargin
        case .right:
            return .rightMargin
        case .top:
            return .topMargin
        case .bottom:
            return .bottomMargin
        case .leading:
            return .leadingMargin
        case .trailing:
            return .trailingMargin
        case .centerX:
            return .centerXWithinMargins
        case .centerY:
            return .centerYWithinMargins
        default:
            return self
        }
    }
}
