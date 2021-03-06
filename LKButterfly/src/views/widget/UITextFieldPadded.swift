import UIKit

@IBDesignable
public class UITextFieldPadded: UITextField {

    public var padding: UIEdgeInsets {
        get { return layoutMargins }
        set(value) {
            layoutMargins = value
            self.setNeedsDisplay()
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var compoundPadding: CGFloat = 8 {
        didSet {
            self.setNeedsDisplay()
            self.setNeedsLayout()
        }
    }
    
    private var totalPadding: UIEdgeInsets {
        get {
            return UIEdgeInsets(
                top: padding.top,
                left: leftView == nil ? padding.left : padding.left + leftView!.bounds.size.width + compoundPadding,
                bottom: padding.bottom,
                right: rightView == nil ? padding.right : padding.right + rightView!.bounds.size.width + compoundPadding
            )
        }
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: totalPadding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: totalPadding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: totalPadding)
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftView = leftView else { return bounds }
        let size = leftView.bounds.size
        return CGRect(bounds.left + padding.left, bounds.centerY() - size.height/2, bounds.left + padding.left + size.width, bounds.centerY() + size.height/2)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let rightView = rightView else { return bounds }
        let size = rightView.bounds.size
        return CGRect(bounds.right - padding.right - size.width, bounds.centerY()-size.height/2, bounds.right - padding.right, bounds.centerY()+size.height/2)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        leftView?.frame = leftViewRect(forBounds: self.bounds)
        rightView?.frame = rightViewRect(forBounds: self.bounds)
    }
}

@IBDesignable
public class UIAutoCompleteTextFieldPadded: UIAutoCompleteTextField {
    
    public var padding: UIEdgeInsets {
        get { return layoutMargins }
        set(value) {
            layoutMargins = value
            self.notifyParentSizeChanged()
        }
    }
    @IBInspectable
    public var compoundPadding: CGFloat = 8 {
        didSet {
            self.notifyParentSizeChanged()
        }
    }
    
    private var totalPadding: UIEdgeInsets {
        get {
            return UIEdgeInsets(
                top: padding.top,
                left: leftView == nil ? padding.left : padding.left + leftView!.bounds.size.width + compoundPadding,
                bottom: padding.bottom,
                right: rightView == nil ? padding.right : padding.right + rightView!.bounds.size.width + compoundPadding
            )
        }
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: totalPadding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: totalPadding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: totalPadding)
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftView = leftView else { return bounds }
        let size = leftView.bounds.size
        return CGRect(bounds.left + padding.left, bounds.centerY() - size.height/2, bounds.left + padding.left + size.width, bounds.centerY() + size.height/2)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let rightView = rightView else { return bounds }
        let size = rightView.bounds.size
        return CGRect(bounds.right - padding.right - size.width, bounds.centerY()-size.height/2, bounds.right - padding.right, bounds.centerY()+size.height/2)
    }
}
