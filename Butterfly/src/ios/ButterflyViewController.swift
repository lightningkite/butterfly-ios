//
//  ButterflyViewController.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/21/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


open class ButterflyViewController: UIViewController, UINavigationControllerDelegate {
    
    private var _viewSafeAreaLayoutGuide: UILayoutGuide? = nil
    private var _viewSafeAreaLayoutGuideTop: NSLayoutConstraint? = nil
    private var _viewSafeAreaLayoutGuideBottom: NSLayoutConstraint? = nil
    private var _viewSafeAreaLayoutGuideLeft: NSLayoutConstraint? = nil
    private var _viewSafeAreaLayoutGuideRight: NSLayoutConstraint? = nil
    public var viewSafeAreaLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide
        } else {
            if let x = _viewSafeAreaLayoutGuide {
                return x
            } else {
                let guide = UILayoutGuide()
                self.view.addLayoutGuide(guide)
                _viewSafeAreaLayoutGuideLeft = guide.leftAnchor.constraint(equalTo: self.view.leftAnchor)
                _viewSafeAreaLayoutGuideLeft?.isActive = true
                _viewSafeAreaLayoutGuideRight = guide.rightAnchor.constraint(equalTo: self.view.rightAnchor)
                _viewSafeAreaLayoutGuideRight?.isActive = true
                _viewSafeAreaLayoutGuideTop = guide.topAnchor.constraint(equalTo: self.view.topAnchor)
                _viewSafeAreaLayoutGuideTop?.isActive = true
                _viewSafeAreaLayoutGuideBottom = guide.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                _viewSafeAreaLayoutGuideBottom?.isActive = true
                _viewSafeAreaLayoutGuide = guide
                return guide
            }
        }
    }
    private var _viewAdditionalSafeAreaInsets: UIEdgeInsets = .zero
    public var viewAdditionalSafeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.additionalSafeAreaInsets
            } else {
                return _viewAdditionalSafeAreaInsets
            }
        }
        set(value) {
            if #available(iOS 11.0, *) {
                self.additionalSafeAreaInsets = value
            } else {
                _viewAdditionalSafeAreaInsets = value
                _viewSafeAreaLayoutGuideTop?.constant = value.top
                _viewSafeAreaLayoutGuideBottom?.constant = value.bottom
                _viewSafeAreaLayoutGuideLeft?.constant = value.left
                _viewSafeAreaLayoutGuideRight?.constant = value.right
            }
        }
    }
    public var viewSafeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.view.safeAreaInsets
            } else {
                return _viewAdditionalSafeAreaInsets
            }
        }
    }
    
    open var main: ViewGenerator
    public init(_ main: ViewGenerator){
        self.main = main
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        self.main = ViewGenerator.Default()
        super.init(coder: coder)
    }
    
    static public let refreshBackgroundColorEvent = PublishSubject<Void>()
    
    weak var backgroundLayerBottom: UIView!
    weak var innerView: UIView!
    
    public var defaultBackgroundColor: UIColor = .white
    public var overrideBottomBackgroundColor: UIColor? = nil
    public var forceDefaultBackgroundColor: Bool = false
    public var drawOverSystemWindows: Bool = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = UIView(frame: .zero)
        self.view.backgroundColor = defaultBackgroundColor
        
        let m = main.generate(dependency: ViewControllerAccess(self))
        innerView = m
        innerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(innerView)
        
        if drawOverSystemWindows {
            m.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            m.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            m.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            m.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        } else {
            m.leftAnchor.constraint(equalTo: self.viewSafeAreaLayoutGuide.leftAnchor).isActive = true
            m.rightAnchor.constraint(equalTo: self.viewSafeAreaLayoutGuide.rightAnchor).isActive = true
            m.topAnchor.constraint(equalTo: self.viewSafeAreaLayoutGuide.topAnchor).isActive = true
            m.bottomAnchor.constraint(equalTo: self.viewSafeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
        showDialogEvent.addWeak(referenceA: self){ (this, request) in
            let dep = ViewControllerAccess(self)
            let message = request.string.get(dependency: dep)
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            if let confirmation = request.confirmation {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    confirmation()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    
                }))
            } else {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                }))
            }
            this.present(alert, animated: true, completion: {})
        }
        
        hideKeyboardWhenTappedAround()

         ApplicationAccess.INSTANCE.softInputActive.subscribeBy { it in
            guard !self.suppressKeyboardUpdate else { return }
             if it {
                self.view.findNextFocus()?.becomeFirstResponder()
             } else {
                self.resignAllFirstResponders()
             }
        }.forever()
    }
    
    private var suppressKeyboardUpdate: Bool = false
    
    
    override open func viewDidAppear(_ animated: Bool) {
        addKeyboardObservers()
    }
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObservers()
    }
    
    /// Asks the system to resign all first responders (usually input fields), which effectively
    /// causes the keyboard to dismiss itself.
    func resignAllFirstResponders() {
        view.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        post {
            self.resignAllFirstResponders()
        }
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    /// Remove observers that were added previously.
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: self.view.window
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: self.view.window
        )
    }

    var suppressIsActive = false
    
    /// Method's notified when the keyboard is about to be shown or change its size.
    ///
    /// - Parameter notification: System keyboard notification
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if
            let window = view.window,
            let responder = view.firstResponder,
            let userInfo = notification.userInfo,
            let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        {
            let keyboardHeight = keyboardFrameValue.cgRectValue.height
            if keyboardHeight > 20 {
                post {
                    self.suppressKeyboardUpdate = true
                    if !ApplicationAccess.INSTANCE.softInputActive.value {
                        ApplicationAccess.INSTANCE.softInputActive.value = true
                    }
                    self.suppressKeyboardUpdate = false
                }
            }
            UIView.animate(
                withDuration: keyboardAnimationDuration.doubleValue,
                animations: {
                    self.viewAdditionalSafeAreaInsets.bottom = keyboardHeight
                    self.view.layoutIfNeeded()
                },
                completion: { [weak self] _ in
                }
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if let view = UIResponder.current as? UIView {
                    view.scrollToMe(animated: true)
                }
            })
        }
    }
    
    /// Method's notified when the keyboard is about to be dismissed.
    ///
    /// - Parameter notification: System keyboard notification
    @objc func keyboardWillHide(notification: NSNotification) {
        if
            let window = self.view.window,
            let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.suppressKeyboardUpdate = true
                ApplicationAccess.INSTANCE.softInputActive.value = false
                self.suppressKeyboardUpdate = false
            }
            UIView.animate(
                withDuration: animationDuration.doubleValue,
                animations: {
                    self.viewAdditionalSafeAreaInsets.bottom = 0
                    self.view.layoutIfNeeded()
                },
                completion: { [weak self] _ in
                }
            )
        }
    }

    override open func viewWillLayoutSubviews(){
        if self.viewSafeAreaInsets != UIView.fullScreenSafeInsetsObs.value {
            UIView.fullScreenSafeInsetsObs.value = self.viewSafeAreaInsets
            innerView.updateSafeInsets(self.viewSafeAreaInsets)
        }
        super.viewWillLayoutSubviews()
    }
}

