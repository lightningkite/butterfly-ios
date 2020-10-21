//
//  FrameLayout.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/14/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import UIKit

open class FrameLayout: UIView {
    
    @IBInspectable
    public var automaticConstraintPriority: Int = 500
    
    public var padding: UIEdgeInsets {
        get { return layoutMargins }
        set(value){
            layoutMargins = value
        }
    }
    
    public struct LayoutParams {
        public var minimumSize: CGSize
        public var size: CGSize
        public var margin: UIEdgeInsets
        public var padding: UIEdgeInsets
        public var gravity: AlignPair
        
        public init(
            minimumSize: CGSize = .zero,
            size: CGSize = .zero,
            margin: UIEdgeInsets = .zero,
            padding: UIEdgeInsets = .zero,
            gravity: AlignPair = .center
        ) {
            self.minimumSize = minimumSize
            self.size = size
            self.margin = margin
            self.padding = padding
            self.gravity = gravity
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
    
    internal var subviewsWithParams: Dictionary<UIView, LayoutParams> = Dictionary()
    internal var measurements: Dictionary<UIView, CGSize> = Dictionary()
    internal var childBounds: Dictionary<UIView, CGRect> = Dictionary()
    
    public func getParams(for view: UIView) -> LayoutParams? {
        return subviewsWithParams[view]
    }
    public func setParams(for view: UIView, setTo: LayoutParams) {
        subviewsWithParams[view] = setTo
        myConstraints.removeAll { c in
            if c.firstItem === view || c.secondItem === view {
                c.isActive = false
                return true
            }
            return false
        }
    }
    
    public func addView(_ view: UIView, _ params: LayoutParams) {
        subviewsWithParams[view] = params
        addSubview(view)
    }
    
    public func removeAllViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    public func addSubview(_ view: UIView, _ params: LayoutParams) {
        subviewsWithParams[view] = params
        addSubview(view)
    }
    
    public func addSubview(
        _ view: UIView,
        minimumSize: CGSize = .zero,
        size: CGSize = .zero,
        margin: UIEdgeInsets = .zero,
        padding: UIEdgeInsets = .zero,
        gravity: AlignPair = .center
    ) {
        subviewsWithParams[view] = LayoutParams(minimumSize: minimumSize, size: size, margin: margin, padding: padding, gravity: gravity)
        addSubview(view)
    }
    
    public override func willRemoveSubview(_ subview: UIView) {
        subviewsWithParams.removeValue(forKey: subview)
        measurements.removeValue(forKey: subview)
        childBounds.removeValue(forKey: subview)
        post {
            subview.refreshLifecycle()
        }
    }
    
    public override func didAddSubview(_ subview: UIView) {
        subview.refreshLifecycle()
        if let pair = subviewsWithParams.find({ (pair) -> Bool in pair.0 === subview }) {
            pair.0.translatesAutoresizingMaskIntoConstraints = false
            addOrthogonalConstraintForSubview(pair)
        }
    }
    
    weak var lastHit: UIView?
    var lastPoint: CGPoint?
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        lastPoint = point
        for key in subviews.reversed() {
            guard !key.isHidden, key.alpha > 0.1, key.includeInLayout else { continue }
            guard let value = childBounds[key] else { continue }
            if value.contains(point) {
                lastHit = key
                setNeedsDisplay()
                if let sub = key.hitTest(key.convert(point, from: self), with: event) {
                    return sub
                } else {
                    return key
                }
            }
        }
        return nil
    }
    
    var myConstraints: Array<NSLayoutConstraint> = []
    private func addOrthogonalConstraintForSubview(_ pair: (UIView, LayoutParams)) {
        for orientation in [Dimension.x, Dimension.y] {
            
            //orthogonal constraints
            var constraints: Array<NSLayoutConstraint> = []
            let startMargin = pair.1.margin.start(orientation) + pair.1.padding.start(orientation)
            let endMargin = pair.1.margin.end(orientation) + pair.1.padding.end(orientation)
            switch pair.1.gravity[orientation] {
            case .start:
                constraints.append(pair.0.startAnchor(orientation).constraintD(equalTo: layoutMarginsGuide.startAnchor(orientation), constant: startMargin))
               constraints.append(layoutMarginsGuide.endAnchor(orientation).constraintD(greaterThanOrEqualTo: pair.0.endAnchor(orientation), constant: endMargin))
            case .center:
                constraints.append(pair.0.centerAnchor(orientation).constraintD(equalTo: layoutMarginsGuide.centerAnchor(orientation), constant: 0))
                constraints.append(pair.0.startAnchor(orientation).constraintD(greaterThanOrEqualTo: layoutMarginsGuide.startAnchor(orientation), constant: startMargin))
                constraints.append(layoutMarginsGuide.endAnchor(orientation).constraintD(greaterThanOrEqualTo: pair.0.endAnchor(orientation), constant: endMargin))
            case .end:
                constraints.append(pair.0.startAnchor(orientation).constraintD(greaterThanOrEqualTo: layoutMarginsGuide.startAnchor(orientation), constant: startMargin))
                constraints.append(layoutMarginsGuide.endAnchor(orientation).constraintD(equalTo: pair.0.endAnchor(orientation), constant: endMargin))
            case .fill:
                constraints.append(pair.0.startAnchor(orientation).constraintD(equalTo: layoutMarginsGuide.startAnchor(orientation), constant: startMargin))
                constraints.append(layoutMarginsGuide.endAnchor(orientation).constraintD(equalTo: pair.0.endAnchor(orientation), constant: endMargin))
            }
            for cons in constraints {
                cons.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(automaticConstraintPriority))
                cons.isActive = true
                myConstraints.append(cons)
            }
        }
    }
}
