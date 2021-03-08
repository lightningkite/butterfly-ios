//
//  LabeledSwitch.swift
//  Lifting Generations
//
//  Created by Joseph Ivie on 3/28/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import UIKit


@IBDesignable
public class LabeledCheckbox : LabeledToggle, CompoundButton {
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
    public let checkView: UILabel = UILabel(frame: .zero)
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
    
    public override var toggleDisplayView: UIView { return checkViewContainer }
    public override var checkSize: CGSize { return CGSize(width: 24, height: 24) }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        titleLabel!.numberOfLines = 0
        
        checkViewContainer.isUserInteractionEnabled = false
        checkView.isUserInteractionEnabled = false
        addSubview(checkViewContainer)
        checkViewContainer.addSubview(checkView)

        checkView.text = "✓"
        
        post {
            self.checkView.textColor = self.titleLabel!.textColor
            self.checkViewContainer.layer.borderColor = self.checkView.textColor.cgColor
        }
        checkView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        checkView.textAlignment = .center

        checkViewContainer.layer.borderWidth = 1
        checkViewContainer.layer.cornerRadius = 2

        self.onClick(disabledMilliseconds: 10, action: { [weak self] in
            if let self = self {
                self.isChecked = !self.isChecked
            }
        })
        
        if isChecked {
            checkView.transform = CGAffineTransform(scaleX: 1, y: 1)
        } else {
            checkView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        checkView.frame = CGRect(origin: .zero, size: checkSize)
    }
}
