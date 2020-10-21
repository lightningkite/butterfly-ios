//
//  Layouting.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/12/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import UIKit

open class LinearLayout: UIView {
    private var readyToConstrain = false
    
    @IBInspectable
    public var automaticConstraintPriority: Int = 900
    
    public var orientation: Dimension = .x {
        didSet {
            calculateOrthogonalConstraints()
            recalculateConstraints()
            updateContentConstraints()
        }
    }
    public var padding: UIEdgeInsets {
        get { return layoutMargins }
        set(value){
            layoutMargins = value
        }
    }
    public var gravity: AlignPair = .topLeft {
        didSet {
            updateContentConstraints()
        }
    }
    
    public struct LayoutParams {
        public var minimumSize: CGSize
        public var size: CGSize
        public var margin: UIEdgeInsets
        public var padding: UIEdgeInsets
        public var gravity: AlignPair
        public var weight: CGFloat
        
        public init(
            minimumSize: CGSize = .zero,
            size: CGSize = .zero,
            margin: UIEdgeInsets = .zero,
            padding: UIEdgeInsets = .zero,
            gravity: AlignPair = .center,
            weight: CGFloat = 0
        ) {
            self.minimumSize = minimumSize
            self.size = size
            self.margin = margin
            self.padding = padding
            self.gravity = gravity
            self.weight = weight
        }
        
        public var combined: UIEdgeInsets {
            return UIEdgeInsets(
                top: margin.top + padding.top,
                left: margin.left + padding.left,
                bottom: margin.bottom + padding.bottom,
                right: margin.right + padding.right
            )
        }
    }
    public func params(
        sizeX: Int32 = 0,
        sizeY: Int32 = 0,
        marginStart: Int32 = 0,
        marginEnd: Int32 = 0,
        marginTop: Int32 = 0,
        marginBottom: Int32 = 0,
        gravity: AlignPair = .center,
        weight: Float = 0
    ) -> LinearLayout.LayoutParams {
        return LinearLayout.LayoutParams(
            minimumSize: .zero,
            size: CGSize(width: Int(sizeX), height: Int(sizeY)),
            margin: UIEdgeInsets(
                top: CGFloat(marginTop),
                left: CGFloat(marginStart),
                bottom: CGFloat(marginBottom),
                right: CGFloat(marginEnd)
            ),
            gravity: gravity,
            weight: CGFloat(weight)
        )
    }
    
    internal var subviewsWithParams: Array<(UIView, LayoutParams)> = Array()
    
    public func getParams(for view: UIView) -> LayoutParams? {
        return subviewsWithParams.find { entry in entry.0 === view }?.1
    }
    public func setParams(for view: UIView, setTo: LayoutParams) {
        if let index = (subviewsWithParams.firstIndex { entry in entry.0 === view }) {
            let pair = (view, setTo)
            subviewsWithParams[index] = pair
            recalculateConstraints()
            calculateOrthogonalConstraints()
        }
    }
    
    public func addView(_ view: UIView, _ params: LayoutParams) {
        subviewsWithParams.append((view, params))
        addSubview(view)
    }
    
    public func removeView(_ view: UIView) {
        view.removeFromSuperview()
    }
    
    public func removeAllViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    public func addSubview(_ view: UIView, _ params: LayoutParams) {
        subviewsWithParams.append((view, params))
        addSubview(view)
    }
    public func addSubview(
        _ view: UIView,
        minimumSize: CGSize = .zero,
        size: CGSize = .zero,
        margin: UIEdgeInsets = .zero,
        padding: UIEdgeInsets = .zero,
        gravity: AlignPair = .center,
        weight: CGFloat = 0
    ) {
        let params = LayoutParams(minimumSize: minimumSize, size: size, margin: margin, padding:padding, gravity: gravity, weight: weight)
        subviewsWithParams.append((view, params))
        addSubview(view)
    }
    
    public override func willRemoveSubview(_ subview: UIView) {
        subviewsWithParams.removeAll { it in it.0 == subview }
        post {
            subview.refreshLifecycle()
        }
    }
    
    public override func didAddSubview(_ subview: UIView) {
        subview.refreshLifecycle()
        if let pair = subviewsWithParams.find({ (pair) -> Bool in pair.0 === subview }) {
            pair.0.translatesAutoresizingMaskIntoConstraints = false
            
            if readyToConstrain {
                addOrthogonalConstraintForSubview(pair)
                if subview === subviews.last {
                    addConstraintForSubview(pair)
                    handleFillConstraint()
                } else {
                    recalculateConstraints()
                }
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        padding = .zero
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        padding = .zero
        commonInit()
    }
    
    private var huggingXConstraints: Array<NSLayoutConstraint> = []
    private var compressionXConstraints: Array<NSLayoutConstraint> = []
    private var huggingYConstraints: Array<NSLayoutConstraint> = []
    private var compressionYConstraints: Array<NSLayoutConstraint> = []
    open override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentCompressionResistancePriority(priority, for: axis)
        for c in (axis == .horizontal ? compressionXConstraints : compressionYConstraints) {
            c.priority = priority
        }
        if axis == orientation.other.axis {
            calculateOrthogonalConstraints()
        }
    }
    open override func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentHuggingPriority(priority, for: axis)
        for c in (axis == .horizontal ? huggingXConstraints : huggingYConstraints) {
            c.priority = priority
        }
        if axis == orientation.other.axis {
            calculateOrthogonalConstraints()
        }
    }
    
    private var internalGuide: UILayoutGuide = UILayoutGuide()
    func commonInit(){
        let justShort = UILayoutPriority(rawValue: 249)
        setContentHuggingPriority(justShort, for: .vertical)
        setContentHuggingPriority(justShort, for: .horizontal)
        addLayoutGuide(internalGuide)
        for c in [
            layoutMarginsGuide.widthAnchor.constraint(equalTo: internalGuide.widthAnchor)
        ] {
            c.priority = contentHuggingPriority(for: .horizontal)
            c.isActive = true
            huggingXConstraints.append(c)
        }
        for c in [
            layoutMarginsGuide.heightAnchor.constraint(equalTo: internalGuide.heightAnchor)
        ] {
            c.priority = contentHuggingPriority(for: .vertical)
            c.isActive = true
            huggingYConstraints.append(c)
        }
        for c in [
            layoutMarginsGuide.widthAnchor.constraint(greaterThanOrEqualTo: internalGuide.widthAnchor)
        ] {
            c.priority = contentCompressionResistancePriority(for: .horizontal)
            c.isActive = true
            compressionXConstraints.append(c)
        }
        for c in [
            layoutMarginsGuide.heightAnchor.constraint(greaterThanOrEqualTo: internalGuide.heightAnchor)
        ] {
            c.priority = contentCompressionResistancePriority(for: .vertical)
            c.isActive = true
            compressionYConstraints.append(c)
        }
        readyToConstrain = true
        recalculateConstraints()
        updateContentConstraints()
    }
    private var contentConstraints: Array<NSLayoutConstraint> = []
    func updateContentConstraints(){
        for c in contentConstraints {
            c.isActive = false
        }
        contentConstraints = []
        if orientation == .y {
            switch(gravity.vertical){
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
        } else {
            switch(gravity.horizontal){
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
        }
        for c in contentConstraints {
            c.isActive = true
        }
    }
    
    private var orthogonalConstraints: Array<NSLayoutConstraint> = []
    private func calculateOrthogonalConstraints(){
        for c in orthogonalConstraints {
            c.isActive = false
        }
        orthogonalConstraints = []
        lastView = nil
        for s in subviewsWithParams {
            addOrthogonalConstraintForSubview(s)
        }
    }
    private func addOrthogonalConstraintForSubview(_ pair: (UIView, LayoutParams)) {
        
        //orthogonal constraints
        var constraints: Array<NSLayoutConstraint> = []
        let startMargin = pair.1.margin.start(orientation.other) + pair.1.padding.start(orientation.other)
        let endMargin = pair.1.margin.end(orientation.other) + pair.1.padding.end(orientation.other)
        switch pair.1.gravity[orientation.other] {
        case .start:
            constraints.append(pair.0.startAnchor(orientation.other).constraintD(equalTo: layoutMarginsGuide.startAnchor(orientation.other), constant: startMargin))
        case .center:
            constraints.append(pair.0.centerAnchor(orientation.other).constraintD(equalTo: layoutMarginsGuide.centerAnchor(orientation.other), constant: 0))
        case .end:
            constraints.append(layoutMarginsGuide.endAnchor(orientation.other).constraintD(equalTo: pair.0.endAnchor(orientation.other), constant: endMargin))
        case .fill:
            constraints.append(pair.0.startAnchor(orientation.other).constraintD(equalTo: layoutMarginsGuide.startAnchor(orientation.other), constant: startMargin))
            constraints.append(layoutMarginsGuide.endAnchor(orientation.other).constraintD(equalTo: pair.0.endAnchor(orientation.other), constant: endMargin))
        }
        for cons in constraints {
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            orthogonalConstraints.append(cons)
        }
        ({() in
            let cons = layoutMarginsGuide.sizeAnchor(orientation.other).constraint(greaterThanOrEqualTo: pair.0.sizeAnchor(orientation.other), constant: startMargin + endMargin)
            cons.priority = contentCompressionResistancePriority(for: orientation.other.axis)
            cons.isActive = true
            orthogonalConstraints.append(cons)
        })()
        ({() in
            let cons = layoutMarginsGuide.sizeAnchor(orientation.other).constraint(lessThanOrEqualTo: pair.0.sizeAnchor(orientation.other), constant: startMargin + endMargin)
            cons.priority = contentHuggingPriority(for: orientation.other.axis)
            cons.isActive = true
            orthogonalConstraints.append(cons)
        })()
        
        if pair.1.size.width >= 0 && (orientation != .x || pair.1.weight == 0) {
            let cons = pair.0.widthAnchor.constraint(equalToConstant: pair.1.size.width)
            cons.isActive = true
            orthogonalConstraints.append(cons)
        }
        if pair.1.size.height >= 0 && (orientation != .y || pair.1.weight == 0) {
            let cons = pair.0.heightAnchor.constraint(equalToConstant: pair.1.size.height)
            cons.isActive = true
            orthogonalConstraints.append(cons)
        }
        if pair.1.minimumSize.width >= 0 {
            let cons = pair.0.widthAnchor.constraint(greaterThanOrEqualToConstant: pair.1.minimumSize.width)
            cons.priority = contentCompressionResistancePriority(for: .horizontal)
            cons.isActive = true
            orthogonalConstraints.append(cons)
        }
        if pair.1.minimumSize.height >= 0 {
            let cons = pair.0.heightAnchor.constraint(greaterThanOrEqualToConstant: pair.1.minimumSize.width)
            cons.priority = contentCompressionResistancePriority(for: .vertical)
            cons.isActive = true
            orthogonalConstraints.append(cons)
        }
    }

    private var lastView: (UIView, LayoutParams)?
    private var lastConstraint: NSLayoutConstraint?
    private var myConstraints: Array<NSLayoutConstraint> = []
    private var lastWeightedView: (UIView, LayoutParams)?

    private func addConstraintForSubview(_ viewWithParams: (UIView, LayoutParams)) {
        let view = viewWithParams.0
        let params = viewWithParams.1
        
        //weight
        if params.weight > 0 {
            let none = UILayoutPriority(rawValue: Float(10))
            if orientation == .y {
                view.setContentHuggingPriority(none, for: .vertical)
                view.setContentHuggingPriority(.defaultLow, for: .horizontal)
            } else {
                view.setContentHuggingPriority(none, for: .horizontal)
                view.setContentHuggingPriority(.defaultLow, for: .vertical)
            }
        } else {
            view.setContentHuggingPriority(.defaultLow, for: .horizontal)
            view.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
    
        guard view.includeInLayout else { return }
        if let lastView = lastView {
            let margin = params.margin.start(orientation) + params.padding.start(orientation) + lastView.1.margin.end(orientation) + lastView.1.padding.end(orientation)
            let cons = view.startAnchor(orientation).constraintD(equalTo: lastView.0.endAnchor(orientation), constant: margin)
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            myConstraints.append(cons)
        } else {
            let margin = params.margin.start(orientation) + params.padding.start(orientation)
            let cons = view.startAnchor(orientation).constraintD(equalTo: internalGuide.startAnchor(orientation), constant: margin)
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            myConstraints.append(cons)
        }
        if params.weight > 0 {
            if let lastWeightedView = lastWeightedView {
                let cons = view.sizeAnchor(orientation).constraint(equalTo: lastWeightedView.0.sizeAnchor(orientation), multiplier: params.weight / lastWeightedView.1.weight)
                cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
                cons.isActive = true
                myConstraints.append(cons)
            }
            self.lastWeightedView = viewWithParams
        }
        self.lastView = viewWithParams
    }

    private func handleFillConstraint(){
        lastConstraint?.isActive = false
        if let viewPair = subviewsWithParams.last(where: { $0.0.includeInLayout }) {
            let view = viewPair.0
            let params = viewPair.1
            let margin = params.margin.end(orientation)
//            let cons = operations.endMatch(guide: internalGuide, view: view)
            let cons = internalGuide.endAnchor(orientation).constraintD(equalTo: view.endAnchor(orientation), constant: margin)
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            lastConstraint = cons
        } else {
            var cons: NSLayoutConstraint
            if orientation == .y {
                cons = internalGuide.heightAnchor.constraint(equalToConstant: 0)
            } else {
                cons = internalGuide.widthAnchor.constraint(equalToConstant: 0)
            }
            cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
            cons.isActive = true
            lastConstraint = cons
        }
    }

    public func recalculateConstraints(){
        for c in myConstraints {
            c.isActive = false
        }
        myConstraints = []
        lastView = nil
        for s in subviewsWithParams {
            addConstraintForSubview(s)
        }
        handleFillConstraint()
    }
    
}
