//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import CoreGraphics
import UIKit

public extension CGContext {
    func completePath(_ path: CGPath, _ paint: Paint) {
        if let shader = paint.shader {
            UIBezierPath(cgPath: path).addClip()
            shader(self)
            resetClip()
        } else {
            setAlpha(CGFloat(paint.alpha) / 255)
            setLineWidth(CGFloat(paint.strokeWidth))
            self.addPath(path)
            switch paint.style {
            case .FILL:
                setFillColor(paint.color.cgColor)
                fillPath()
            case .FILL_AND_STROKE:
                setFillColor(paint.color.cgColor)
                setStrokeColor(paint.color.cgColor)
                fillPath()
                strokePath()
            case .STROKE:
                setStrokeColor(paint.color.cgColor)
                strokePath()
            }
        }
    }

    func clipRect(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat){
        clip(to: CGRect(
            x: CGFloat(left),
            y: CGFloat(top),
            width: CGFloat(right-left),
            height: CGFloat(bottom-top)
        ))
    }
    func clipRect(_ rect: CGRect){
        clip(to: rect)
    }

    func drawCircle(_ cx: CGFloat, _ cy: CGFloat, _ radius: CGFloat, _ paint: Paint) {
        let path = Path()
        path.addArc(center: CGPoint(x: CGFloat(cx), y: CGFloat(cy)), radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.closeSubpath()
        self.completePath(path, paint)
    }

    func drawRect(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat, _ paint: Paint) {
        self.completePath(
            CGPath(
                rect: CGRect(
                    x: CGFloat(left),
                    y: CGFloat(top),
                    width: CGFloat(right-left),
                    height: CGFloat(bottom-top)
                ),
                transform: nil
            ),
            paint
        )
    }
    func drawRect(_ rect: CGRect, _ paint: Paint) {
        self.completePath(
            CGPath(
                rect: rect,
                transform: nil
            ),
            paint
        )
    }

    func drawOval(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat, _ paint: Paint) {
        self.completePath(
            CGPath(
                ellipseIn: CGRect(
                    x: CGFloat(left),
                    y: CGFloat(top),
                    width: CGFloat(right-left),
                    height: CGFloat(bottom-top)
                ),
                transform: nil
            ),
            paint
        )
    }
    func drawOval(_ rect: CGRect, _ paint: Paint) {
        self.completePath(
            CGPath(
                ellipseIn: rect,
                transform: nil
            ),
            paint
        )
    }

    func drawRoundRect(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat, _ rx: CGFloat, _ ry: CGFloat, _ paint: Paint) {
        self.completePath(
            CGPath(
                roundedRect: CGRect(x: CGFloat(left), y: CGFloat(top), width: CGFloat(right-left), height: CGFloat(bottom-top)),
                cornerWidth: CGFloat(rx),
                cornerHeight: CGFloat(ry),
                transform: nil
            ),
            paint
        )
    }
    func drawRoundRect(_ rect: CGRect, _ rx: CGFloat, _ ry: CGFloat, _ paint: Paint) {
        self.completePath(
            CGPath(
                roundedRect: rect,
                cornerWidth: CGFloat(rx),
                cornerHeight: CGFloat(ry),
                transform: nil
            ),
            paint
        )
    }

    func drawLine(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ paint: Paint) {
        let path = Path()
        path.moveTo(x1, y1)
        path.lineTo(x2, y2)
        self.completePath(
            path,
            paint
        )
    }

    func drawPath(_ path: Path, _ paint: Paint) {
        self.completePath(path, paint)
    }

    func save(){
        self.saveGState()
    }

    func restore(){
        self.restoreGState()
    }

    func translate(_ dx: CGFloat, _ dy: CGFloat) {
        self.translateBy(x: CGFloat(dx), y: CGFloat(dy))
    }

    func scale(_ scaleX: CGFloat, _ scaleY: CGFloat) {
        self.scaleBy(x: CGFloat(scaleX), y: CGFloat(scaleY))
    }

    func rotate(_ degrees: CGFloat) {
        self.rotate(by: CGFloat(degrees) * CGFloat.pi / 180)
    }

    func drawTextCentered(text: String,  centerX: CGFloat,  centerY: CGFloat,  paint: Paint) {
        drawText(text, centerX, centerY, .center, paint)
    }

    func drawText(_ text: String, _ x: CGFloat, _ y: CGFloat, _ gravity: AlignPair, _ paint: Paint) {
        let sizeTaken = CGFloat(paint.measureText(text))
        var dx = CGFloat(x)
        var dy = CGFloat(y)
        switch gravity.horizontal {
        case .start:
            break
        case .fill, .center:
            dx = dx - sizeTaken / 2
        case .end:
            dx = dx - sizeTaken
        }
        switch gravity.vertical {
        case .start:
            break
        case .fill, .center:
            dy = dy - CGFloat(paint.textHeight) / 2
        case .end:
            dy = dy - CGFloat(paint.textHeight)
        }
        text.draw(at: CGPoint(x: dx, y: dy), withAttributes: paint.attributes)
    }
    func drawText(text: String, x: CGFloat, y: CGFloat, gravity: AlignPair, paint: Paint) {
        drawText(text, x, y, gravity, paint)
    }

    //We draw this upside-down to compensate for the reversed coordinate system

    func drawBitmap(_ bitmap: UIImage, _ left: CGFloat, _ top: CGFloat) {
        let bounds = CGRect(x: left, y: top, width: bitmap.size.width, height: bitmap.size.height)
        bitmap.draw(in: bounds)
    }
    func drawBitmap(bitmap: UIImage, left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        let bounds = CGRect(x: left, y: top, width: right-left, height: bottom-top)
        let drawScale = max(max(max(self.ctm.a, self.ctm.b), self.ctm.c), self.ctm.d) / UIScreen.main.scale
        let rawScale = max((right-left) * drawScale / bitmap.size.width, (bottom-top) * drawScale / bitmap.size.height)
        let factor = getScaleFactor(from: rawScale)
        (bitmap.optimizedForDrawing(scaling: factor) ?? bitmap).draw(in: bounds)
    }
}

private func getScaleFactor(from: CGFloat) -> Int {
    return min(16, max(1, Int(pow(Double(2), Double(ceil(log2(1 / from)))))))
}

private extension UIImage {
    private static let cgImageInSpaceCache = ExtensionProperty<UIImage, Dictionary<Int, UIImage>>()
    func optimizedForDrawing(scaling: Int) -> UIImage? {
        if let cache = UIImage.cgImageInSpaceCache.get(self), let mine = cache[scaling] {
            return mine
        }
        let cgScale: CGFloat = 1.0 / CGFloat(scaling)
        let newSize = CGSize(width: self.size.width * cgScale, height: self.size.height * cgScale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var cache = UIImage.cgImageInSpaceCache.get(self) ?? [:]
        cache[scaling] = image
        UIImage.cgImageInSpaceCache.set(self, cache)
        return image
    }
}
