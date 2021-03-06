//
//  UIButtonWithLayer.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/16/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class UIButtonWithLayer: UIButton {
    
    public enum Position: Int { case left = 0, top, right, bottom, center }
    
    private var iconDefaultSize: CGSize = .zero
    public var iconLayer: CALayer? {
        didSet {
            if let iconLayer = iconLayer {
                iconDefaultSize = iconLayer.bounds.size
                iconLayerRatio = iconLayer.bounds.size.width / iconLayer.bounds.size.height
            }
            refreshManipLayer()
        }
    }
    private func refreshManipLayer(){
        if let iconLayer = iconLayer {
            if let iconTint = iconTint {
                let newLayer = CALayer()
                newLayer.mask = iconLayer
                newLayer.backgroundColor = iconTint.cgColor
                manipulatedLayer = newLayer
            } else {
                manipulatedLayer = iconLayer
            }
        } else {
            manipulatedLayer = nil
        }
    }
    private var manipulatedLayer: CALayer? {
        willSet {
            manipulatedLayer?.removeFromSuperlayer()
        }
        didSet {
            if let manipulatedLayer = manipulatedLayer {
                layer.addSublayer(manipulatedLayer)
            }
            setNeedsLayout()
        }
    }
    private var iconLayerRatio: CGFloat = 1
    
    public var iconPosition: Position = .center {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var iconPositionInt: Int {
        get {
            return iconPosition.rawValue
        }
        set(value) {
            if let x = Position(rawValue: value) {
                iconPosition = x
            }
        }
    }
    
    @IBInspectable
    public var iconPadding: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var iconTint: UIColor? = nil {
        didSet {
            refreshManipLayer()
        }
    }
    
    @IBInspectable
    public var iconImage: UIImage? {
        get {
            return (iconLayer as? CAImageLayer)?.image
        }
        set(value) {
            if let value = value {
                iconLayer = CAImageLayer(value)
            }
        }
    }
    
    public var textGravity: AlignPair = .center{
        didSet {
            setNeedsLayout()
        }
    }

    public var compoundDrawable: Drawable? {
        get {
            if let iconLayer = iconLayer {
                return Drawable { _ in iconLayer }
            } else {
                return nil
            }
        }
        set(value) {
            if let value = value {
                iconLayer = value.makeLayer(self)
            } else {
                iconLayer = nil
            }
        }
    }

    public func setImageResource(_ image: DrawableResource ) {
        self.compoundDrawable = image
        self.notifyParentSizeChanged()
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            var result = CGSize.zero
            let isHorizontal = iconPosition == .left || iconPosition == .right
            let isVertical = iconPosition == .top || iconPosition == .bottom
            let hasTitle = self.titleLabel?.text?.trimmingCharacters(in: .whitespaces).isEmpty == true
            if iconLayer != nil {
                if isHorizontal {
                    result.width += iconDefaultSize.width
                    if hasTitle {
                        result.width += iconPadding
                    }
                } else {
                    result.width = max(result.width, iconDefaultSize.width)
                }
                if isVertical {
                    result.height += iconDefaultSize.height
                    if hasTitle {
                        result.height += iconPadding
                    }
                } else {
                    result.height = max(result.height, iconDefaultSize.height)
                }
            }
            if let title = self.titleLabel?.text, !title.trimmingCharacters(in: .whitespaces).isEmpty, let labelSize = titleLabel?.sizeThatFits(CGSize(width: 1000, height: 1000)) {
                if isHorizontal {
                    result.width += labelSize.width
                } else {
                    result.width = max(result.width, labelSize.width)
                }
                if isVertical {
                    result.height += labelSize.height
                } else {
                    result.height = max(result.height, labelSize.height)
                }
            }
            result.width += contentEdgeInsets.left + contentEdgeInsets.right
            result.height += contentEdgeInsets.top + contentEdgeInsets.bottom
            return result
        }
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var result = CGSize.zero
        let isHorizontal = iconPosition == .left || iconPosition == .right
        let isVertical = iconPosition == .top || iconPosition == .bottom
        let hasTitle = self.titleLabel?.text?.trimmingCharacters(in: .whitespaces).isEmpty == true
        if iconLayer != nil {
            if isHorizontal {
                result.width += iconDefaultSize.width
                if hasTitle {
                    result.width += iconPadding
                }
            } else {
                result.width = max(result.width, iconDefaultSize.width)
            }
            if isVertical {
                result.height += iconDefaultSize.height
                if hasTitle {
                    result.height += iconPadding
                }
            } else {
                result.height = max(result.height, iconDefaultSize.height)
            }
        }
        if let title = self.titleLabel?.text, !title.trimmingCharacters(in: .whitespaces).isEmpty, let labelSize = titleLabel?.sizeThatFits(size) {
            if isHorizontal {
                result.width += labelSize.width
            } else {
                result.width = max(result.width, labelSize.width)
            }
            if isVertical {
                result.height += labelSize.height
            } else {
                result.height = max(result.height, labelSize.height)
            }
        }
        result.width += contentEdgeInsets.left + contentEdgeInsets.right
        result.height += contentEdgeInsets.top + contentEdgeInsets.bottom
        return result
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        var placeableRect = self.bounds.inset(by: self.contentEdgeInsets)
        if let title = self.titleLabel?.text, !title.trimmingCharacters(in: .whitespaces).isEmpty, let titleLabel = titleLabel {
            if let iconLayer = iconLayer, let manipulatedLayer = manipulatedLayer {
                switch iconPosition {
                case .center:
                    iconLayer.resize(CGRect(origin: .zero, size: placeableRect.size))
                    manipulatedLayer.resize(placeableRect)
                case .left:
                    let newBounds = CGRect(
                        x: placeableRect.origin.x,
                        y: placeableRect.origin.y + (placeableRect.size.height - iconLayer.bounds.size.height) / 2,
                        width: iconLayer.bounds.size.width,
                        height: iconLayer.bounds.size.height
                    )
                    iconLayer.resize(CGRect(origin: .zero, size: newBounds.size))
                    manipulatedLayer.resize(newBounds)
                    placeableRect.origin.x += iconLayer.bounds.size.width + iconPadding
                    placeableRect.size.width -= iconLayer.bounds.size.width + iconPadding
                case .right:
                    let newBounds = CGRect(
                        x: placeableRect.origin.x + (placeableRect.size.width - iconLayer.bounds.size.width),
                        y: placeableRect.origin.y + (placeableRect.size.height - iconLayer.bounds.size.height) / 2,
                        width: iconLayer.bounds.size.width,
                        height: iconLayer.bounds.size.height
                    )
                    iconLayer.resize(CGRect(origin: .zero, size: newBounds.size))
                    manipulatedLayer.resize(newBounds)
                    placeableRect.size.width -= iconLayer.bounds.size.width + iconPadding
                case .top:
                    let newBounds = CGRect(
                        x: placeableRect.origin.x + (placeableRect.size.width - iconLayer.bounds.size.width) / 2,
                        y: placeableRect.origin.y,
                        width: iconLayer.bounds.size.width,
                        height: iconLayer.bounds.size.height
                    )
                    iconLayer.resize(CGRect(origin: .zero, size: newBounds.size))
                    manipulatedLayer.resize(newBounds)
                    placeableRect.origin.y += iconLayer.bounds.size.height + iconPadding
                    placeableRect.size.height -= iconLayer.bounds.size.height + iconPadding
                case .bottom:
                    let newBounds = CGRect(
                        x: placeableRect.origin.x + (placeableRect.size.width - iconLayer.bounds.size.width) / 2,
                        y: placeableRect.origin.y + (placeableRect.size.height - iconLayer.bounds.size.height),
                        width: iconLayer.bounds.size.width,
                        height: iconLayer.bounds.size.height
                    )
                    iconLayer.resize(CGRect(origin: .zero, size: newBounds.size))
                    manipulatedLayer.resize(newBounds)
                    placeableRect.size.height -= iconLayer.bounds.size.height + iconPadding
                }
            }
            var destination = CGRect.zero
            destination.size = titleLabel.bounds.size
            switch textGravity.horizontal {
            case .start:
                destination.origin.x = placeableRect.origin.x
            case .center:
                destination.origin.x = placeableRect.origin.x + (placeableRect.size.width - destination.size.width) / 2
            case .end:
                destination.origin.x = placeableRect.origin.x + placeableRect.size.width - destination.size.width
            case .fill:
                destination.origin.x = placeableRect.origin.x + (placeableRect.size.width - destination.size.width) / 2
            }
            switch textGravity.vertical {
            case .start:
                destination.origin.y = placeableRect.origin.y
            case .center:
                destination.origin.y = placeableRect.origin.y + (placeableRect.size.height - destination.size.height) / 2
            case .end:
                destination.origin.y = placeableRect.origin.y + placeableRect.size.height - destination.size.height
            case .fill:
                destination.origin.y = placeableRect.origin.y + (placeableRect.size.height - destination.size.height) / 2
            }
            titleLabel.frame = destination
        } else if let iconLayer = iconLayer, let manipulatedLayer = manipulatedLayer {
            var ratioCorrectRect = placeableRect
            let iconRatio = iconDefaultSize.width / iconDefaultSize.height
            if placeableRect.size.width / placeableRect.size.height > iconRatio {
                //Wider
                let size = placeableRect.size.height * iconRatio
                ratioCorrectRect.size.width = size
                ratioCorrectRect.origin.x -= (size - placeableRect.size.width) / 2
            } else {
                //Taller
                let size = placeableRect.size.width / iconRatio
                ratioCorrectRect.size.height = size
                ratioCorrectRect.origin.y -= (size - placeableRect.size.height) / 2
            }
            iconLayer.resize(CGRect(origin: .zero, size: ratioCorrectRect.size))
            manipulatedLayer.resize(ratioCorrectRect)
        }
    }
}

