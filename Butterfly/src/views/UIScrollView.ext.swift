//
//  ScrollView.actual.swift
//  Alamofire
//
//  Created by Joseph Ivie on 1/4/20.
//

import UIKit

public extension UIScrollView {
    func scrollTo(_ x: Int, _ y: Int) {
        self.setContentOffset(CGPoint(x: CGFloat(x), y: CGFloat(y)), animated: false)
    }
    func smoothScrollTo(_ x: Int, _ y: Int) {
        self.setContentOffset(CGPoint(x: CGFloat(x), y: CGFloat(y)), animated: true)
    }
    var scrollX: Int {
        return Int(self.contentOffset.x)
    }
    var scrollY: Int {
        return Int(self.contentOffset.y)
    }
    func scrollToBottom(){
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: true)
    }
    public func flexFix(_ sub: UIView){
        let dg = ScrollSavingDelegate()
        delegate = dg
        self.addOnLayoutSubviews { [weak self, weak sub] in
            guard let self = self, let sub = sub else { return }
            self.contentSize = sub.frame.size
            self.contentOffset = dg.lastNonzeroOffset
        }
    }
}

public class ScrollSavingDelegate : NSObject, UIScrollViewDelegate {
    public var lastNonzeroOffset: CGPoint = CGPoint.zero
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset != CGPoint.zero {
            print("Set offset to \(scrollView.contentOffset)")
            lastNonzeroOffset = scrollView.contentOffset
        }
    }
}
