//
//  DateButton.swift
//  Lifting Generations
//
//  Created by Joseph Ivie on 5/13/19.
//  Copyright © 2019 Joseph Ivie. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay


@IBDesignable
public class DateButton : UIButtonWithLayer {

    var mode: UIDatePicker.Mode {
        get {
            return picker.datePickerMode
        }
        set(value) {
            picker.datePickerMode = value
        }
    }

    public var onDateEntered = PublishSubject<Date?>()
    
    var format: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .medium;
        format.timeStyle = .none;
        return format
    }()
    
    var defaultText: String = ""

    var picker = UIDatePicker(frame: .zero)
    let toolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true

        toolBar.sizeToFit()

        return toolBar
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit(){
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker.datePickerMode = .date
        picker.addAction(for: .valueChanged, id: "0", action: { [weak picker, weak self] in
            self?.date = picker?.date ?? Date()
        })
        self.isUserInteractionEnabled = true
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([ spaceButton, doneButton], animated: false)
        
        addAction {
            self.becomeFirstResponder()
        }
    }

    @objc public func doneClick() {
        self.resignFirstResponder()
        self.date = self.picker.date
    }

    public var date: Date? = nil {
        didSet {
            picker.date = date ?? Date()
            onDateEntered.invokeAll(self.date)
            updateText()
        }
    }

    public func updateText() {
        if let date = date {
            setTitle(format.string(from: date), for: .normal)
        } else {
            setTitle(defaultText, for: .normal)
        }
    }

    override public var inputView: UIView {
        get {
            return self.picker
        }
    }

    override public var inputAccessoryView: UIView {
        get {
            return self.toolbar
        }
    }

    override public var canBecomeFirstResponder: Bool {
        return true
    }
}
