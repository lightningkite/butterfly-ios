//
//  LabeledSwitch.swift
//  Lifting Generations
//
//  Created by Joseph Ivie on 3/28/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import UIKit


@IBDesignable
public class LabeledRadioButton : UIView, CompoundButton, HasLabelView {
    public var onCheckChanged: (CompoundButton, Bool) -> Void = { (_, _) in }
    public func setOnCheckedChangeListener(_ item: @escaping (CompoundButton, Bool) -> Void) {
        onCheckChanged = item
    }
    public var onCheckChangedOther: (CompoundButton, Bool) -> Void = { (_, _) in }
    public func addOnCheckedChangeListener(_ item: @escaping (CompoundButton, Bool) -> Void) {
        let prev = onCheckChangedOther
        onCheckChangedOther = { (self, it) in
            prev(self, it)
            item(self, it)
        }
    }

    public let checkViewContainer: UIView = UIView(frame: .zero)
    public let checkView: UIView = UIView(frame: .zero)
    public let labelView: UILabel = UILabel(frame: .zero)
    public var isChecked: Bool = false {
        didSet {
            if isChecked {
                UIView.animate(withDuration: 0.25, animations: { [checkView] in
                    checkView.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: { [checkView] in
                    checkView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                })
            }
            onCheckChanged(self, isChecked)
            onCheckChangedOther(self, isChecked)
        }
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
                        toItem: checkViewContainer,
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
                        toItem: checkViewContainer,
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
                        toItem: checkViewContainer,
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
                        toItem: checkViewContainer,
                        attribute: .top,
                        multiplier: 1,
                        constant: 0
                    ),
                    NSLayoutConstraint(
                        item: self,
                        attribute: .bottomMargin,
                        relatedBy: .equal,
                        toItem: checkViewContainer,
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
        
        addSubview(checkViewContainer)
        checkViewContainer.addSubview(checkView)
        addSubview(labelView)
        
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkViewContainer.translatesAutoresizingMaskIntoConstraints = false
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: checkView, attribute: .left, relatedBy: .equal, toItem: checkViewContainer, attribute: .leftMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: checkView, attribute: .right, relatedBy: .equal, toItem: checkViewContainer, attribute: .rightMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: checkView, attribute: .top, relatedBy: .equal, toItem: checkViewContainer, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: checkView, attribute: .bottom, relatedBy: .equal, toItem: checkViewContainer, attribute: .bottomMargin, multiplier: 1, constant: 0).isActive = true
        checkView.widthAnchor.constraint(equalTo: checkView.heightAnchor).isActive = true
        checkView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        checkView.layer.cornerRadius = 8
        checkViewContainer.layer.cornerRadius = 8 + checkViewContainer.layoutMargins.top
        
        NSLayoutConstraint(
            item: self,
            attribute: .leftMargin,
            relatedBy: .equal,
            toItem: checkViewContainer,
            attribute: .left,
            multiplier: 1,
            constant: 0
        ).isActive = true
        NSLayoutConstraint(
            item: checkViewContainer,
            attribute: .right,
            relatedBy: .equal,
            toItem: labelView,
            attribute: .left,
            multiplier: 1,
            constant: -8
        ).isActive = true
        NSLayoutConstraint(
            item: labelView,
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
            toItem: checkViewContainer,
            attribute: .height,
            multiplier: 1,
            constant: 0
        ).isActive = true
        verticalAlign = .center

        checkViewContainer.layer.borderWidth = 1

        let tapRecognizer = UITapGestureRecognizer().addAction(until: removed) { [weak self] in
            if let self = self {
                self.isChecked = !self.isChecked
            }
        }
        self.addGestureRecognizer(tapRecognizer)
        
        post {
            self.checkView.layer.backgroundColor = self.labelView.textColor.cgColor
            self.checkViewContainer.layer.borderColor = self.labelView.textColor.cgColor
        }
        
        if isChecked {
            checkView.transform = CGAffineTransform(scaleX: 1, y: 1)
        } else {
            checkView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
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
