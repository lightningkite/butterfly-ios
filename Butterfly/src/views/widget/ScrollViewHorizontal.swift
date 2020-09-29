//
//  ScrollViewHorizontal.swift
//  Alamofire
//
//  Created by Joseph Ivie on 12/6/19.
//

import UIKit

@available(*, deprecated, message: "Just use a normal scroll view.")
public class ScrollViewHorizontal: UIScrollView {
    public var fillViewport = false
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let childSize = subviews.first?.sizeThatFits(size)
        return CGSize(width: 0, height: childSize?.height ?? 0)
    }
    override public func layoutSubviews() {
        guard let view = subviews.first else { return }
        let measuredSize = view.sizeThatFits(self.bounds.size)
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: fillViewport ? max(measuredSize.width, self.bounds.size.width) : measuredSize.width,
            height: self.bounds.size.height
        )
        self.contentSize = CGSize(width: measuredSize.width, height: 0)
    }
}
