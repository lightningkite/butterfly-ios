//
//  LabeledSwitch.swift
//  Lifting Generations
//
//  Created by Joseph Ivie on 3/28/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import UIKit


@IBDesignable
public class LabeledSwitch : LabeledToggle, CompoundButton {
    public let switchView: UISwitch = UISwitch(frame: .zero)
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
    
    public override var toggleDisplayView: UIView { return switchView }
    public override var checkSize: CGSize { return switchView.intrinsicContentSize }

    public var control: UIControl {
        return switchView
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
        
        titleLabel!.numberOfLines = 0
        
        addSubview(switchView)
        
        self.onClick(disabledMilliseconds: 10, action: { [weak self] in
            if let self = self {
                self.switchView.setOn(!self.switchView.isOn, animated: true)
            }
        })
        
    }
    
}

