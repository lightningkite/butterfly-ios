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
private let viewLineSpacingMultiplier = ExtensionProperty<UIView, CGFloat>()
public var defaultLetterSpacing: CGFloat = 0
public var defaultLineSpacingMultiplier: CGFloat = 1

public extension UILabel {
    var lineSpacingMultiplier: CGFloat {
        get{
            return viewLineSpacingMultiplier.get(self) ?? defaultLineSpacingMultiplier
        }
        set(value){
            viewLineSpacingMultiplier.set(self, value)
            let current = textString
            textString = current
        }
    }

    var maxLines: Int {
        get{
            return self.numberOfLines
        }
        set(newLineCount){
            if self.numberOfLines != newLineCount {
                self.numberOfLines = newLineCount
                self.notifyParentSizeChanged()
            }
        }
    }

    @objc
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
    @objc
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
            notifyParentSizeChanged()
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
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineHeightMultiple = lineSpacingMultiplier
            
            self.attributedText = NSAttributedString(string: toSet, attributes: [.kern: letterSpacing * font.pointSize, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            notifyParentSizeChanged()
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
    var lineSpacingMultiplier: CGFloat {
        get{
            return viewLineSpacingMultiplier.get(self) ?? defaultLineSpacingMultiplier
        }
        set(value){
            viewLineSpacingMultiplier.set(self, value)
            let current = textString
            textString = current
        }
    }
    @objc
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
    @objc
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
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineHeightMultiple = lineSpacingMultiplier
            
            self.attributedText = NSAttributedString(string: toSet, attributes: [.kern: letterSpacing * (font?.pointSize ?? 12), NSAttributedString.Key.paragraphStyle: paragraphStyle])
            notifyParentSizeChanged()
        }
    }
}

public extension UITextField {
    var lineSpacingMultiplier: CGFloat {
        get{
            return viewLineSpacingMultiplier.get(self) ?? defaultLineSpacingMultiplier
        }
        set(value){
            viewLineSpacingMultiplier.set(self, value)
            let current = textString
            textString = current
        }
    }
    @objc
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
    @objc
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
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineHeightMultiple = lineSpacingMultiplier
            
            self.attributedText = NSAttributedString(string: toSet, attributes: [.kern: letterSpacing * (font?.pointSize ?? 12), NSAttributedString.Key.paragraphStyle: paragraphStyle])
            notifyParentSizeChanged()
        }
    }
}

public extension UIButton {
    var lineSpacingMultiplier: CGFloat {
        get{
            return viewLineSpacingMultiplier.get(self) ?? defaultLineSpacingMultiplier
        }
        set(value){
            viewLineSpacingMultiplier.set(self, value)
            let current = textString
            textString = current
        }
    }
    @objc
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
    @objc
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
    @objc
    var textResource: String {
        get {
            return title(for: .normal) ?? ""
        }
        set(value) {
            textString = value
        }
    }
    @objc
    var textString: String {
        get {
            return title(for: .normal) ?? ""
        }
        set(value) {
            var toSet = value
            if textAllCaps {
                toSet = toSet.uppercased()
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineHeightMultiple = lineSpacingMultiplier
            let font = titleLabel?.font
            self.setAttributedTitle(NSAttributedString(string: toSet, attributes: [.kern: letterSpacing * (font?.pointSize ?? 12), NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
            notifyParentSizeChanged()
        }
    }
    var text: String {
        get {
            return title(for: .normal) ?? ""
        }
        set(value) {
            self.textString = value
        }
    }
}
