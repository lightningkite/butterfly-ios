//
//  Dropdown.swift
//  Lifting Generations
//
//  Created by Joseph Ivie on 3/28/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import UIKit


@IBDesignable
public class Dropdown : UIButton {
    public let pickerView = UIPickerView(frame: CGRect.zero)
    public let toolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true

        toolBar.sizeToFit()

        return toolBar
    }()
    private weak var currentView: UIView?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    private func sharedInit() {

        self.isUserInteractionEnabled = true
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([ spaceButton, doneButton], animated: false)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchPicker))
        self.addGestureRecognizer(tapRecognizer)
    }

    override public var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override public var inputView: UIView {
        get {
            return pickerView
        }
    }
    override public var inputAccessoryView: UIView? {
        return toolbar
    }
    public var dataSource: UIPickerViewDataSource? {
        get {
            return pickerView.dataSource
        }
        set(value){
            pickerView.dataSource = value
        }
    }
    public var delegate: UIPickerViewDelegate? {
        get {
            return pickerView.delegate
        }
        set(value){
            pickerView.delegate = value
        }
    }

    public var selectedView: UIView? {
        get {
            return currentView
        }
        set(value) {
            currentView?.removeFromSuperview()
            currentView = nil
            if let newView = value {
                currentView = newView
                addSubview(newView)
            }
            setNeedsLayout()
        }
    }
    
    public var selectedText: String {
        get { return title(for: .normal) ?? "" }
        set(value) {
            currentView?.removeFromSuperview()
            currentView = nil
            setNeedsLayout()
            textString = value
        }
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        return currentView?.sizeThatFits(size) ?? super.sizeThatFits(size)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        currentView?.frame = self.bounds.inset(by: contentEdgeInsets)
    }

    @objc public func launchPicker() {
        becomeFirstResponder()
    }

    @objc public func doneClick() {
        resignFirstResponder()
    }

}
