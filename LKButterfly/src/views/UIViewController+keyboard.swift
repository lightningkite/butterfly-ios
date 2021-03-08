//
//  UIViewController+keyboard.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/21/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extensions to make view controller keyboard-aware.
// Move these to a separate file if you want

public extension ViewControllerAccess {
    func runKeyboardUpdate(root: UIView? = nil, discardingRoot: UIView? = nil) {
        let currentFocus = UIResponder.current as? UIView
        var dismissOld = false
        if let currentFocus = currentFocus {
            if let discardingRoot = discardingRoot, discardingRoot.containsSub(other: currentFocus) {
                //We're discarding the focus
                dismissOld = true
            }
        }
        if let root = root, let keyboardView = root.findFirstFocus(startup: true) {
            post {
                if keyboardView.window != nil {
                    keyboardView.requestFocus()
                }
            }
            dismissOld = false
        }
        if dismissOld {
            self.parentViewController.view.endEditing(true)
        }
    }
}

private extension UIView {
    func containsSub(other: UIView?) -> Bool {
        if self === other { return true }
        guard let other = other else { return false }
        return self.containsSub(other: other.superview)
    }
}

public extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
}

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil

    public static var current: UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }

    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}
