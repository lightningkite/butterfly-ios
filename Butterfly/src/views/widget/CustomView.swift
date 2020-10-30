//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit
import CoreGraphics


//--- CustomView.{
@IBDesignable
public class CustomView: FrameLayout {
    
    //--- CustomView.Primary Constructor
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private let imageLayer = CALayer()
    private func commonInit() {
        self.clipsToBounds = true
        self.removed.call(DisposableLambda { [weak self] in
            self?.delegate = nil
        })
        self.layer.addSublayer(imageLayer)
    }
    
    //--- CustomView.delegate
    public var delegate: CustomViewDelegate? {
        willSet {
            isOpaque = false
            delegate?.customView = nil
            delegate?.dispose()
        }
        didSet {
            delegate?.customView = self
            self.isUserInteractionEnabled = true
            self.isMultipleTouchEnabled = true
            if UIAccessibility.isVoiceOverRunning {
                if let accessibilityView = delegate?.generateAccessibilityView() {
                    addSubview(accessibilityView, gravity: .fillFill)
                    self.accessibilityView = accessibilityView
                }
            }
        }
    }
    
    //--- CustomView.accessibilityView
    public weak var accessibilityView: UIView?
    
    //--- CustomView implementation
    let scaleInformation = DisplayMetrics(
        density: (UIScreen.main.scale),
        scaledDensity: (UIScreen.main.scale),
        widthPixels: Int(UIScreen.main.bounds.width * UIScreen.main.scale),
        heightPixels: Int(UIScreen.main.bounds.height * UIScreen.main.scale)
    )
    
    var stage = Atomic<Int>(0)
    var needsAnotherRender = false
    private var drawCount = 0
    private var started = CFAbsoluteTimeGetCurrent()
    private var lastMessage = CFAbsoluteTimeGetCurrent()
    
    func startRefresh(){
        let size = self.frame.size
        if stage.compareAndSet(expected: 0, setTo: 1) {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                self.needsAnotherRender = false
                self.drawCount += 1
                let start = CFAbsoluteTimeGetCurrent()
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                if let ctx = UIGraphicsGetCurrentContext() {
                    ctx.clear(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    ctx.scale(1/self.scaleInformation.density, 1/self.scaleInformation.density)
                    self.delegate?.draw(canvas: ctx, width: (size.width) * self.scaleInformation.density, height: (size.height) * self.scaleInformation.density, displayMetrics: self.scaleInformation)
                }
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                DispatchQueue.main.async { [weak self] in
                    UIView.performWithoutAnimation {
                        if let self = self {
                            self.stage.mutate { $0 = 0 }
                            if let image = image, let cgImage = image.cgImage {
                                self.imageLayer.contents = cgImage
                            }
                            self.setNeedsDisplay()
                            if self.needsAnotherRender {
                                self.startRefresh()
                            }
                        }
                    }
                }
                if start - self.lastMessage > 5 {
                    let end = CFAbsoluteTimeGetCurrent()
                    self.lastMessage = end
                    print("CustomView draw took \(end-start) seconds, \(Double(self.drawCount) / (end - self.started)) FPS")
                }
            }
        } else {
            needsAnotherRender = true
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.imageLayer.frame = self.bounds
        startRefresh()
    }
    
    private var touchIds = Dictionary<UITouch, Int>()
    private var currentTouchId: Int = 0
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
        super.touchesBegan(touches, with: event)
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
        super.touchesMoved(touches, with: event)
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
        super.touchesEnded(touches, with: event)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
        super.touchesEnded(touches, with: event)
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        if let delegate = delegate {
            return CGSize(
                width: CGFloat(delegate.sizeThatFitsWidth(width: (size.width), height: (size.height))),
                height: CGFloat(delegate.sizeThatFitsHeight(width: (size.width), height: (size.height)))
            )
        } else {
            return super.sizeThatFits(size)
        }
    }
    
    private func handleTouches(_ touches: Set<UITouch>){
        for touch in touches {
            let loc = touch.location(in: self)
            switch touch.phase {
            case .began:
                let id = currentTouchId
                currentTouchId += 1
                touchIds[touch] = id
                let _ = delegate?.onTouchDown(
                    id: id,
                    x: (loc.x) * scaleInformation.density,
                    y: (loc.y) * scaleInformation.density,
                    width: (frame.size.width) * scaleInformation.density,
                    height: (frame.size.height) * scaleInformation.density
                )
            case .moved:
                if let id = touchIds[touch] {
                    let _ = delegate?.onTouchMove(
                        id: id,
                        x: (loc.x) * scaleInformation.density,
                        y: (loc.y) * scaleInformation.density,
                        width: (frame.size.width) * scaleInformation.density,
                        height: (frame.size.height) * scaleInformation.density
                    )
                }
            case .ended:
                if let id = touchIds[touch] {
                    let _ = delegate?.onTouchUp(
                        id: id,
                        x: (loc.x) * scaleInformation.density,
                        y: (loc.y) * scaleInformation.density,
                        width: (frame.size.width) * scaleInformation.density,
                        height: (frame.size.height) * scaleInformation.density
                    )
                }
                touchIds.removeValue(forKey: touch)
            case .cancelled:
                if let id = touchIds[touch] {
                    let _ = delegate?.onTouchCancelled(
                        id: id,
                        x: (loc.x) * scaleInformation.density,
                        y: (loc.y) * scaleInformation.density,
                        width: (frame.size.width) * scaleInformation.density,
                        height: (frame.size.height) * scaleInformation.density
                    )
                }
                touchIds.removeValue(forKey: touch)
            default:
                break
            }
        }
    }
    
    //--- CustomView.}
}


final class Atomic<A: Equatable> {
    private let queue = DispatchQueue(label: "Atomic serial queue")
    private var _value: A
    init(_ value: A) {
        self._value = value
    }
    
    var value: A {
        get {
            return queue.sync { self._value }
        }
    }
    
    func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
    
    func compareAndSet(expected: A, setTo: A) -> Bool {
        var result = false
        queue.sync {
            if _value == expected {
                _value = setTo
                result = true
            } else {
                result = false
            }
        }
        return result
    }
}
