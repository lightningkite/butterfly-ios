//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit
import CoreGraphics


public class Paint {

    public init() {
    }

    public var flags: Int = 0
    public var color: UIColor = UIColor.black
    public var strokeWidth: CGFloat = 0
    public var alpha: Int = 255
    public var style: Style = .FILL_AND_STROKE
    public var textSize: CGFloat = 12
    public var shader: ShaderValue? = nil
    public var isAntiAlias: Bool = false
    public var isFakeBoldText: Bool = false

    public enum Style { case FILL, STROKE, FILL_AND_STROKE }

    private struct MeasureTextCacheKey: Hashable {
        var text: String
        var textSize: CGFloat
    }
    static private var measureText_cache: Dictionary<MeasureTextCacheKey, CGFloat> = Dictionary()
    public func measureText(_ text: String) -> CGFloat {
        let key = MeasureTextCacheKey(text: text, textSize: textSize)
        if let result = Paint.measureText_cache[key] {
            return result
        }
        let result = CGFloat(NSString(string: text).size(withAttributes: attributes).width)
//        Paint.measureText_cache[key] = result
        return result
    }
    public func measureText(text: String) -> CGFloat {
        return measureText(text)
    }

    public var textHeight: CGFloat {
        let font = UIFont.get(size: CGFloat(textSize), style: [])
        return CGFloat(font.lineHeight)
    }

    var attributes: Dictionary<NSAttributedString.Key, Any> {
        return [
            .font: UIFont.get(size: CGFloat(textSize), style: isFakeBoldText ? ["bold"] : []),
            .foregroundColor: color
        ]
    }

}
