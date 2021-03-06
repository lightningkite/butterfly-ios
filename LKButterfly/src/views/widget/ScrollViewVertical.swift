//
//  ScrollViewHorizontal.swift
//  Alamofire
//
//  Created by Joseph Ivie on 12/6/19.
//

import UIKit

public class ScrollViewVertical: UIScrollView, ListensToChildSize {
    public var fillViewport = false
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let childSize = subviews.first?.sizeThatFits(size)
        return CGSize(width: childSize?.width ?? 0, height: 0)
    }
    override public func layoutSubviews() {
        guard let view = subviews.first else { return }
        let measuredSize = view.sizeThatFits(self.bounds.size)
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.size.width,
            height: fillViewport ? max(measuredSize.height, self.bounds.size.height) : measuredSize.height
        )
        self.contentSize = CGSize(width: 0, height: measuredSize.height)
    }
    public func childSizeUpdated(_ child: UIView) {
        self.setNeedsLayout()
    }
}
