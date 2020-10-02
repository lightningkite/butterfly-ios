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
            updateContentConstraints()
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
    public var alignmentString: String {
        get { return alignment.rawValue }
        set(value) { if let it = Align.init(rawValue: value) { alignment = it } }
    }
    public var alignment: Align = .start {
        didSet {
            updateContentConstraints()
        }
    }
    
    @IBInspectable
    public var defaultMargin: CGFloat = 8 {
        didSet {
            recalculateConstraints()
        }
    }
    
    public class LayoutParams {
        var start: CGFloat? = nil
        var end: CGFloat? = nil
    }
    
    private var operations: AnchorOperationsProtocol {
        if vertical {
            if reverse {
                return AnchorOperations(
                    startView: { $0.bottomAnchor },
                    endView: { $0.topAnchor },
                    startGuide: { $0.bottomAnchor },
                    endGuide: { $0.topAnchor },
                    startOView: { $0.leadingAnchor },
                    endOView: { $0.trailingAnchor },
                    startOGuide: { $0.leadingAnchor },
                    endOGuide: { $0.trailingAnchor }
                )
            } else {
                return AnchorOperations(
                    startView: { $0.topAnchor },
                    endView: { $0.bottomAnchor },
                    startGuide: { $0.topAnchor },
                    endGuide: { $0.bottomAnchor },
                    startOView: { $0.leadingAnchor },
                    endOView: { $0.trailingAnchor },
                    startOGuide: { $0.leadingAnchor },
                    endOGuide: { $0.trailingAnchor }
                )
            }
        } else {
            if reverse {
                return AnchorOperations(
                    startView: { $0.trailingAnchor },
                    endView: { $0.leadingAnchor },
                    startGuide: { $0.trailingAnchor },
                    endGuide: { $0.leadingAnchor },
                    startOView: { $0.topAnchor },
                    endOView: { $0.bottomAnchor },
                    startOGuide: { $0.topAnchor },
                    endOGuide: { $0.bottomAnchor }
                )
            } else {
                return AnchorOperations(
                    startView: { $0.leadingAnchor },
                    endView: { $0.trailingAnchor },
                    startGuide: { $0.leadingAnchor },
                    endGuide: { $0.trailingAnchor },
                    startOView: { $0.topAnchor },
                    endOView: { $0.bottomAnchor },
                    startOGuide: { $0.topAnchor },
                    endOGuide: { $0.bottomAnchor }
                )
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
    
    private var readyToConstrain = false
    private var internalGuide: UILayoutGuide = UILayoutGuide()
    func commonInit(){
        addLayoutGuide(internalGuide)
        let lowConst = [
            internalGuide.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            internalGuide.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            internalGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            internalGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ]
        for c in lowConst {
            c.priority = .init(rawValue: 250)
            c.isActive = true
        }
        let atLeastSizes = [
            layoutMarginsGuide.widthAnchor.constraint(greaterThanOrEqualTo: internalGuide.widthAnchor),
            layoutMarginsGuide.heightAnchor.constraint(greaterThanOrEqualTo: internalGuide.heightAnchor)
        ]
        for c in atLeastSizes  {
            c.priority = .init(rawValue: 750)
            c.isActive = true
        }
        updateContentConstraints()
        readyToConstrain = true
        updateConstraints()
    }
    private var contentConstraints: Array<NSLayoutConstraint> = []
    func updateContentConstraints(){
        for c in contentConstraints {
            c.isActive = false
        }
        if vertical {
            switch(alignment){
            case .start:
                contentConstraints = [
                    internalGuide.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
                ]
            case .center:
                contentConstraints = [
                    internalGuide.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
                ]
            case .end:
                contentConstraints = [
                    internalGuide.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
                ]
            case .fill:
                contentConstraints = [
                    internalGuide.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                    internalGuide.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
                ]
            }
            contentConstraints.append(
                internalGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
            )
            contentConstraints.append(
                internalGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
            )
        } else {
            switch(alignment){
            case .start:
                contentConstraints = [
                    internalGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
                ]
            case .center:
                contentConstraints = [
                    internalGuide.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
                ]
            case .end:
                contentConstraints = [
                    internalGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
                ]
            case .fill:
                contentConstraints = [
                    internalGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                    internalGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
                ]
            }
            contentConstraints.append(
                internalGuide.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
            )
            contentConstraints.append(
                internalGuide.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            )
        }
        for c in contentConstraints {
            c.isActive = true
        }
    }

    private var lastView: UIView?
    private var lastConstraint: NSLayoutConstraint?
    private var myConstraints: Array<NSLayoutConstraint> = []
    
    private func reverseMargin(_ thing: CGFloat) -> CGFloat {
        if reverse {
            return -thing
        } else {
            return thing
        }
    }

    private func addConstraintForSubview(_ view: UIView) {
        guard view.includeInLayout else { return }
        if let lastView = lastView {
            let margin = (lastView.simpleStackViewParamsOrNil?.end ?? defaultMargin) + (view.simpleStackViewParamsOrNil?.start ?? defaultMargin)
            let cons = operations.next(prev: lastView, next: view)
            cons.constant = reverseMargin(margin)
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            myConstraints.append(cons)
        } else {
            let margin = view.simpleStackViewParamsOrNil?.start ?? defaultMargin
            let cons = operations.startMatch(guide: internalGuide, view: view)
            cons.constant = reverseMargin(margin)
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            myConstraints.append(cons)
        }
        let orthogonals = operations.containOrthogonal(guide: internalGuide, view: view)
        for o in orthogonals {
            o.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(750))
            o.isActive = true
            myConstraints.append(o)
        }
        self.lastView = view
    }

    private func handleFillConstraint(){
        lastConstraint?.isActive = false
        if let view = subviews.last {
            let margin = view.simpleStackViewParamsOrNil?.end ?? defaultMargin
            let cons = operations.endMatch(guide: internalGuide, view: view)
            cons.constant = reverseMargin(margin)
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            lastConstraint = cons
        } else {
            var cons: NSLayoutConstraint
            if vertical {
                cons = internalGuide.heightAnchor.constraint(equalToConstant: 0)
            } else {
                cons = internalGuide.widthAnchor.constraint(equalToConstant: 0)
            }
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            lastConstraint = cons
        }
    }

    public override func didAddSubview(_ subview: UIView) {
        guard readyToConstrain else { return }
        if subview === subviews.last {
            addConstraintForSubview(subview)
            handleFillConstraint()
        } else {
            recalculateConstraints()
        }
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


private protocol AnchorOperationsProtocol {
    func startMatch(guide: UILayoutGuide, view: UIView) -> NSLayoutConstraint
    func endMatch(guide: UILayoutGuide, view: UIView) -> NSLayoutConstraint
    func next(prev: UIView, next: UIView) -> NSLayoutConstraint
    func containOrthogonal(guide: UILayoutGuide, view: UIView) -> Array<NSLayoutConstraint>
}
private struct AnchorOperations<T: AnyObject, O: AnyObject>: AnchorOperationsProtocol {
    var startView: (UIView)->NSLayoutAnchor<T>
    var endView: (UIView)->NSLayoutAnchor<T>
    var startGuide: (UILayoutGuide)->NSLayoutAnchor<T>
    var endGuide: (UILayoutGuide)->NSLayoutAnchor<T>
    var startOView: (UIView)->NSLayoutAnchor<O>
    var endOView: (UIView)->NSLayoutAnchor<O>
    var startOGuide: (UILayoutGuide)->NSLayoutAnchor<O>
    var endOGuide: (UILayoutGuide)->NSLayoutAnchor<O>
    
    func startMatch(guide: UILayoutGuide, view: UIView) -> NSLayoutConstraint {
        return startView(view).constraint(equalTo: startGuide(guide))
    }
    func endMatch(guide: UILayoutGuide, view: UIView) -> NSLayoutConstraint {
        return endGuide(guide).constraint(equalTo: endView(view))
    }
    func next(prev: UIView, next: UIView) -> NSLayoutConstraint {
        return startView(next).constraint(equalTo: endView(prev))
    }
    func containOrthogonal(guide: UILayoutGuide, view: UIView) -> Array<NSLayoutConstraint> {
        return [
            startOView(view).constraint(greaterThanOrEqualTo: startOGuide(guide)),
            endOGuide(guide).constraint(greaterThanOrEqualTo: endOView(view))
        ]
    }
}
