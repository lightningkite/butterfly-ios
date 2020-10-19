//
//  LabeledToggle.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/2/20.
//

import UIKit

@IBDesignable
public class LabeledToggle: UIButton {
    
    public var toggleDisplayView: UIView { fatalError() }
    public var checkSize: CGSize { fatalError() }
    public var checkPadding: CGFloat = 8
    
    public var rightSide: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var labelView: UILabel { return titleLabel! }
    
    public var verticalAlign: Align {
        get {
            switch(contentVerticalAlignment){
            case .center, .fill:
                return .center
            case .top:
                return .start
            case .bottom:
                return .end
            @unknown default:
                return .center
            }
        }
        set(value){
            switch(value){
            case .center, .fill:
                contentVerticalAlignment = .center
            case .start:
                contentVerticalAlignment = .top
            case .end:
                contentVerticalAlignment = .bottom
            }
        }
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var value = super.sizeThatFits(size)
        value.width += checkSize.width + checkPadding
        value.height = max(value.height, checkSize.height)
        if let titleLabel = titleLabel {
            var smallerSize = size
            smallerSize.width -= checkSize.width + checkPadding
            value.height = max(value.height, titleLabel.sizeThatFits(smallerSize).height + contentEdgeInsets.top + contentEdgeInsets.bottom)
        }
        return value
    }
    
    override public var intrinsicContentSize: CGSize {
        var value = super.intrinsicContentSize
        value.width += checkSize.width + checkPadding
        value.height = max(value.height, checkSize.height)
        if let titleLabel = titleLabel {
            value.height = max(value.height, titleLabel.intrinsicContentSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
        }
        return value
    }
    
    public override func layoutSubviews() {
        let inMargins = self.bounds.inset(by: self.contentEdgeInsets)
        if rightSide {
            self.titleLabel?.frame = CGRect(inMargins.left, inMargins.top, inMargins.right - (checkPadding + checkSize.width), inMargins.bottom)
            switch(contentVerticalAlignment) {
            case .center, .fill:
                self.toggleDisplayView.frame = CGRect(x: inMargins.right - checkSize.width, y: inMargins.midY - checkSize.height / 2, width: checkSize.width, height: checkSize.height)
            case .top:
                self.toggleDisplayView.frame = CGRect(x: inMargins.right - checkSize.width, y: inMargins.top, width: checkSize.width, height: checkSize.height)
            case .bottom:
                self.toggleDisplayView.frame = CGRect(x: inMargins.right - checkSize.width, y: inMargins.bottom - checkSize.height, width: checkSize.width, height: checkSize.height)
            @unknown default:
                break
                // do nothing
            }
        } else {
            self.titleLabel?.frame = CGRect(inMargins.left + checkPadding + checkSize.width, inMargins.top, inMargins.right, inMargins.bottom)
            switch(contentVerticalAlignment) {
            case .center, .fill:
                self.toggleDisplayView.frame = CGRect(x: inMargins.left, y: inMargins.midY - checkSize.height / 2, width: checkSize.width, height: checkSize.height)
            case .top:
                self.toggleDisplayView.frame = CGRect(x: inMargins.left, y: inMargins.top, width: checkSize.width, height: checkSize.height)
            case .bottom:
                self.toggleDisplayView.frame = CGRect(x: inMargins.left, y: inMargins.bottom - checkSize.height, width: checkSize.width, height: checkSize.height)
            @unknown default:
                break
                // do nothing
            }
        }
    }
    
    public override func prepareForInterfaceBuilder() {
         invalidateIntrinsicContentSize()
    }
}
