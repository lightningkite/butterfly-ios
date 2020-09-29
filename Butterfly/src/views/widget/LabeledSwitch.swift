//
//  LabeledSwitch.swift
//  Lifting Generations
//
//  Created by Joseph Ivie on 3/28/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import UIKit


@IBDesignable
public class LabeledSwitch : UIView, CompoundButton, HasLabelView {
    public func setOnCheckedChangeListener(_ item: @escaping (CompoundButton, Bool) -> Void) {
        switchView.setOnCheckedChangeListener(item)
    }
    public func addOnCheckedChangeListener(_ item: @escaping (CompoundButton, Bool) -> Void) {
        switchView.addOnCheckedChangeListener(item)
    }
    public var isChecked: Bool {
        get { return switchView.isOn }
        set(value) {
            switchView.isOn = value
        }
    }
    
    public var control: UIControl {
        return switchView
    }
    public let switchView: UISwitch = UISwitch(frame: CGRect.zero)
    public let labelView: UILabel = UILabel(frame: CGRect.zero)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        labelView.numberOfLines = 0
        self.addSubview(labelView)
        self.addSubview(switchView)
        
        switchView.translatesAutoresizingMaskIntoConstraints = false
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(
            item: self,
            attribute: .leftMargin,
            relatedBy: .equal,
            toItem: labelView,
            attribute: .left,
            multiplier: 1,
            constant: 0
        ).isActive = true
        NSLayoutConstraint(
            item: labelView,
            attribute: .right,
            relatedBy: .equal,
            toItem: switchView,
            attribute: .left,
            multiplier: 1,
            constant: -8
        ).isActive = true
        NSLayoutConstraint(
            item: switchView,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .rightMargin,
            multiplier: 1,
            constant: 0
        ).isActive = true
        labelView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint(
            item: self,
            attribute: .topMargin,
            relatedBy: .equal,
            toItem: labelView,
            attribute: .top,
            multiplier: 1,
            constant: 0
        ).isActive = true
        NSLayoutConstraint(
            item: self,
            attribute: .bottomMargin,
            relatedBy: .equal,
            toItem: labelView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        ).isActive = true
        NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .greaterThanOrEqual,
            toItem: labelView,
            attribute: .height,
            multiplier: 1,
            constant: 0
        ).isActive = true
        NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .greaterThanOrEqual,
            toItem: switchView,
            attribute: .height,
            multiplier: 1,
            constant: 0
        ).isActive = true
        verticalAlign = .center
    }
    
    private var verticalAlignConstraints: Array<NSLayoutConstraint> = []
    public var verticalAlign: Align = .center {
        didSet {
            for old in verticalAlignConstraints {
                old.isActive = false
            }
            switch verticalAlign {
            case .start:
                verticalAlignConstraints = [
                    NSLayoutConstraint(
                        item: self,
                        attribute: .topMargin,
                        relatedBy: .equal,
                        toItem: switchView,
                        attribute: .top,
                        multiplier: 1,
                        constant: 0
                    )
                ]
            case .fill, .center:
                verticalAlignConstraints = [
                    NSLayoutConstraint(
                        item: self,
                        attribute: .centerY,
                        relatedBy: .equal,
                        toItem: switchView,
                        attribute: .centerY,
                        multiplier: 1,
                        constant: 0
                    )
                ]
            case .end:
                verticalAlignConstraints = [
                    NSLayoutConstraint(
                        item: self,
                        attribute: .bottomMargin,
                        relatedBy: .equal,
                        toItem: switchView,
                        attribute: .bottom,
                        multiplier: 1,
                        constant: 0
                    )
                ]
                verticalAlignConstraints = [
                    NSLayoutConstraint(
                        item: self,
                        attribute: .topMargin,
                        relatedBy: .equal,
                        toItem: switchView,
                        attribute: .top,
                        multiplier: 1,
                        constant: 0
                    ),
                    NSLayoutConstraint(
                        item: self,
                        attribute: .bottomMargin,
                        relatedBy: .equal,
                        toItem: switchView,
                        attribute: .bottom,
                        multiplier: 1,
                        constant: 0
                    )
                ]
            }
            for old in verticalAlignConstraints {
                old.isActive = true
            }
        }
    }
    
    @IBInspectable
    var label: String? {
        get {
            return labelView.text
        }
        set(value) {
            labelView.text = value
        }
    }
    
    @IBInspectable
    var textSize: CGFloat {
        get {
            return labelView.font.pointSize
        }
        set(value) {
            labelView.font = UIFont.get(size: value, style: [])
        }
    }
    
    @IBInspectable
    var textColor: UIColor {
        get {
            return labelView.textColor
        }
        set(value) {
            labelView.textColor = value
        }
    }
    
    @IBInspectable
    var textAlignment: Int {
        get {
            return labelView.textAlignment.rawValue
        }
        set(value) {
            labelView.textAlignment = NSTextAlignment(rawValue: value) ?? .natural
        }
    }
}
