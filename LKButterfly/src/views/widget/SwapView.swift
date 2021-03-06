//
//  SwapView.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/24/19.
//  Copyright © 2019 Lightning Kite. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class SwapView: UIView {
    public enum Animation {
        case push
        case pop
        case fade
    }
    struct AnimationGoal {
        let startedAt: Date
        let alpha: CGFloat
        let scaledFrame: CGRect
        var frame: CGRect?
        var completion: (UIView)->Void = { _ in }
    }
    
    let animateDestinationExtension = ExtensionProperty<UIView, AnimationGoal>()
    var current: UIView?
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        return current?.sizeThatFits(size) ?? .zero
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateAnimations()
    }
    
    public override func willRemoveSubview(_ subview: UIView) {
        post {
            subview.refreshLifecycle()
        }
    }
    
    public override func didAddSubview(_ subview: UIView) {
        subview.refreshLifecycle()
    }
    
    private var hiding = false

    private func updateAnimations(){
        for view in subviews {
            guard var goal = animateDestinationExtension.get(view) else { continue }
            let toFrame = CGRect(
                x: goal.scaledFrame.origin.x * self.bounds.width,
                y: goal.scaledFrame.origin.y * self.bounds.height,
                width: goal.scaledFrame.size.width * self.bounds.width,
                height: goal.scaledFrame.size.height * self.bounds.height
            )
            guard goal.frame != toFrame else { continue }
            goal.frame = toFrame
            animateDestinationExtension.set(view, goal)
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    view.alpha = goal.alpha
                    view.frame = toFrame
                    ButterflyViewController.refreshBackgroundColorEvent.invokeAll(())
                },
                completion: { done in
                    view.setNeedsLayout()
                    goal.completion(view)
                }
            )
        }
    }
    var swapping = false
    open func swap(dependency: ViewControllerAccess, to: UIView?, animation: Animation){
        if swapping {
            fatalError()
        }
        swapping = true
        let previousView = current
        if let old = current {
            let goal: AnimationGoal
            if to == nil {
                goal = AnimationGoal(
                    startedAt: Date(),
                    alpha: 0.0,
                    scaledFrame: CGRect(x: 0, y: 0, width: 1, height: 1),
                    frame: nil,
                    completion: { view in view.removeFromSuperview() }
                )
            } else {
                switch animation {
                case .fade:
                    goal = AnimationGoal(
                        startedAt: Date(),
                        alpha: 0.0,
                        scaledFrame: CGRect(x: 0, y: 0, width: 1, height: 1),
                        frame: nil,
                        completion: { view in view.removeFromSuperview() }
                    )
                case .pop:
                    goal = AnimationGoal(
                        startedAt: Date(),
                        alpha: 1.0,
                        scaledFrame: CGRect(x: 1, y: 0, width: 1, height: 1),
                        frame: nil,
                        completion: { view in view.removeFromSuperview() }
                    )
                case .push:
                    goal = AnimationGoal(
                        startedAt: Date(),
                        alpha: 1.0,
                        scaledFrame: CGRect(x: -1, y: 0, width: 1, height: 1),
                        frame: nil,
                        completion: { view in view.removeFromSuperview() }
                    )
                }
            }
            animateDestinationExtension.set(old, goal)
            updateAnimations()
        }
        if let new = to {
            new.translatesAutoresizingMaskIntoConstraints = true
            if self.hiding {
                visibility = UIView.VISIBLE
                self.hiding = false
                alpha = 1
                setNeedsLayout()
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 1
                }, completion: { _ in
                })
                UIView.performWithoutAnimation {
                    new.frame = CGRect(
                        x: 0,
                        y: 0,
                        width: self.bounds.width,
                        height: self.bounds.height
                    )
                    new.setNeedsLayout()
                    new.layoutIfNeeded()
                    self.addSubview(new)
                }
            } else {
                UIView.performWithoutAnimation {
                    switch animation {
                    case .fade:
                        new.frame = CGRect(
                            x: 0,
                            y: 0,
                            width: self.bounds.width,
                            height: self.bounds.height
                        )
                        new.alpha = 0.0
                    case .pop:
                        new.frame = CGRect(
                            x: -self.bounds.width,
                            y: 0,
                            width: self.bounds.width,
                            height: self.bounds.height
                        )
                    case .push:
                        new.frame = CGRect(
                            x: self.bounds.width,
                            y: 0,
                            width: self.bounds.width,
                            height: self.bounds.height
                        )
                    }
                }
                new.setNeedsLayout()
                new.layoutIfNeeded()
                self.addSubview(new)
            }
            animateDestinationExtension.set(new, AnimationGoal(
                startedAt: Date(),
                alpha: 1.0,
                scaledFrame: CGRect(x: 0, y: 0, width: 1, height: 1),
                frame: nil,
                completion: { _ in }
            ))
            updateAnimations()
            current = new
        } else {
            current = nil
            hiding = true
            if self.hiding {
                self.visibility = UIView.INVISIBLE
            } else {
                self.alpha = 1
                self.visibility = UIView.VISIBLE
            }
        }
        dependency.runKeyboardUpdate(root: to, discardingRoot: previousView)
        notifyParentSizeChanged()
        swapping = false
    }
    
    weak var lastHit: UIView?
    var lastPoint: CGPoint?
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        lastPoint = point
        for key in subviews.reversed() {
            guard !key.isHidden, key.alpha > 0.1, key.includeInLayout else { continue }
            if key.frame.contains(point) {
                lastHit = key
                if let sub = key.hitTest(key.convert(point, from: self), with: event) {
                    return sub
                } else {
                    return key
                }
            }
        }
        return nil
    }}

