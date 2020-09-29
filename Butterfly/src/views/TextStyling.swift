//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit


//--- TextView.textResource
//--- TextView.textString
//--- TextView.setTextColorResource(ColorResource)
//--- TextView.setColor(ColorResource)
//--- ToggleButton.textResource
//--- ToggleButton.textString

private let viewLetterSpacing = ExtensionProperty<UIView, CGFloat>()
private let viewAllCaps = ExtensionProperty<UIView, Bool>()
public var defaultLetterSpacing: CGFloat = 0

public extension UILabel {
    var lineSpacingMultiplier: CGFloat {
        get {
            if let attr = self.attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                return attr.lineHeightMultiple
            } else {
                return 1
            }
        }
        set(value){
            guard let labelText = self.text else { return }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = value

            let attributedString:NSMutableAttributedString
            if let labelattributedText = self.attributedText {
                attributedString = NSMutableAttributedString(attributedString: labelattributedText)
            } else {
                attributedString = NSMutableAttributedString(string: labelText)
            }

            // Line spacing attribute
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

            self.attributedText = attributedString
        }
    }

    public var maxLines: Int32{
        get{
            return Int32(self.numberOfLines)
        }
        set(newLineCount){
            if self.numberOfLines != Int(newLineCount) {
                self.numberOfLines = Int(newLineCount)
            }
        }
    }

    var letterSpacing: CGFloat {
        get{
            return viewLetterSpacing.get(self) ?? defaultLetterSpacing
        }
        set(value){
            viewLetterSpacing.set(self, value)
            let current = textString
            textString = current
        }
    }
    var textAllCaps: Bool {
        get{
            return viewAllCaps.get(self) ?? false
        }
        set(value){
            viewAllCaps.set(self, value)
            let current = textString
            textString = current
        }
    }
    
    var textResource: String {
        get {
            return text ?? ""
        }
        set(value) {
            textString = value
        }
    }
    var textString: String {
        get {
            return text ?? ""
        }
        set(value) {
            var toSet = value
            if textAllCaps {
                toSet = toSet.uppercased()
            }
            self.attributedText = NSAttributedString(string: toSet, attributes: [.kern: letterSpacing * font.pointSize])
        }
    }

    func setTextColorResource(color: ColorResource){
        textColor = color
    }

    func setTextColorResource(_ color: ColorResource){
        textColor = color
    }
}

public extension UITextView {
    var letterSpacing: CGFloat {
        get{
            return viewLetterSpacing.get(self) ?? defaultLetterSpacing
        }
        set(value){
            viewLetterSpacing.set(self, value)
            let current = textString
            textString = current
        }
    }
    var textAllCaps: Bool {
        get{
            return viewAllCaps.get(self) ?? false
        }
        set(value){
            viewAllCaps.set(self, value)
            let current = textString
            textString = current
        }
    }
    var textResource: String {
        get {
            return text ?? ""
        }
        set(value) {
            textString = value
        }
    }
    var textString: String {
        get {
            return text ?? ""
        }
        set(value) {
            var toSet = value
            if textAllCaps {
                toSet = toSet.uppercased()
            }
            self.attributedText = NSAttributedString(string: toSet, attributes: [.kern: letterSpacing * (font?.pointSize ?? 12)])
        }
    }
}

public extension UITextField {
    var letterSpacing: CGFloat {
        get{
            return viewLetterSpacing.get(self) ?? defaultLetterSpacing
        }
        set(value){
            viewLetterSpacing.set(self, value)
            let current = textString
            textString = current
        }
    }
    var textAllCaps: Bool {
        get{
            return viewAllCaps.get(self) ?? false
        }
        set(value){
            viewAllCaps.set(self, value)
            let current = textString
            textString = current
        }
    }
    var textResource: String {
        get {
            return text ?? ""
        }
        set(value) {
            textString = value
        }
    }
    var textString: String {
        get {
            return text ?? ""
        }
        set(value) {
            var toSet = value
            if textAllCaps {
                toSet = toSet.uppercased()
            }
            self.attributedText = NSAttributedString(string: toSet, attributes: [.kern: letterSpacing * (font?.pointSize ?? 12)])
        }
    }
}

public extension UIButton {
    var letterSpacing: CGFloat {
        get{
            return viewLetterSpacing.get(self) ?? defaultLetterSpacing
        }
        set(value){
            viewLetterSpacing.set(self, value)
            let current = textString
            textString = current
        }
    }
    var textAllCaps: Bool {
        get{
            return viewAllCaps.get(self) ?? false
        }
        set(value){
            viewAllCaps.set(self, value)
            let current = textString
            textString = current
        }
    }
    @objc var text: String {
        get {
            return title(for: .normal) ?? ""
        }
        set(value) {
            textString = value
        }
    }
    @objc var textResource: String {
        get {
            return title(for: .normal) ?? ""
        }
        set(value) {
            textString = value
        }
    }
    @objc var textString: String {
        get {
            return title(for: .normal) ?? ""
        }
        set(value) {
            var toSet = value
            if textAllCaps {
                toSet = toSet.uppercased()
            }
            setAttributedTitle(
                NSAttributedString(string: toSet, attributes: [.kern: letterSpacing * (titleLabel?.font.pointSize ?? 12)]),
                for: .normal
            )
        }
    }
}

public extension HasLabelView where Self: UIView {
    var letterSpacing: CGFloat {
        get{
            return viewLetterSpacing.get(self) ?? defaultLetterSpacing
        }
        set(value){
            viewLetterSpacing.set(self, value)
            let current = textString
            textString = current
        }
    }
    var textAllCaps: Bool {
        get{
            return viewAllCaps.get(self) ?? false
        }
        set(value){
            viewAllCaps.set(self, value)
            let current = textString
            textString = current
        }
    }
    var text: String {
        get {
            return self.labelView.textResource
        }
        set(value) {
            self.labelView.textString = value
        }
    }
    var textResource: String {
        get {
            return self.labelView.textResource
        }
        set(value) {
            self.labelView.textString = value
        }
    }
    var textString: String {
        get {
            return self.labelView.textString
        }
        set(value) {
            self.labelView.textString = value
        }
    }
}
