// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: views/CustomViewDelegate.kt
// Package: com.lightningkite.butterfly.views
import RxSwift
import UIKit
import Foundation
import CoreGraphics

open class CustomViewDelegate {
    public init() {
        self.customView = nil
        self.toDispose = []
        self._removed = nil
        //Necessary properties should be initialized now
        self._removed = DisposeCondition(call: { [weak self] (it) -> Void in self?.toDispose.append(it) })
    }
    
    public var customView: CustomView?
    open func generateAccessibilityView() -> UIView? { TODO() }
    open func draw(canvas: CGContext, width: CGFloat, height: CGFloat, displayMetrics: DisplayMetrics) -> Void { TODO() }
    open func onTouchDown(id: Int, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Bool { return false }
    open func onTouchMove(id: Int, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Bool { return false }
    open func onTouchCancelled(id: Int, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Bool { return false }
    open func onTouchUp(id: Int, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Bool { return false }
    open func onWheel(delta: Float) -> Bool { return false }
    open func sizeThatFitsWidth(width: CGFloat, height: CGFloat) -> CGFloat { return width }
    open func sizeThatFitsHeight(width: CGFloat, height: CGFloat) -> CGFloat { return height }
    
    public func invalidate() -> Void { self.customView?.invalidate() }
    public func postInvalidate() -> Void { self.customView?.postInvalidate() }
    
    public var toDispose: Array<Disposable>
    private var _removed: DisposeCondition?
    public var removed: DisposeCondition {
        get { return self._removed! }
    }
    
    public func dispose() -> Void {
        for item in (self.toDispose){
            item.dispose()
        }
    }
}


