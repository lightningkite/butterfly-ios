
import UIKit

@IBDesignable
public class MaterialSegmentedControl: UISegmentedControl {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        startup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        startup()
    }
    
    private func startup(){
        materialTabStyle()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            var base = super.intrinsicContentSize
            base.height = max(base.height, 32)
            return base
        }
    }

    public var reselectable: Bool = false
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let previousSelectedSegmentIndex = self.selectedSegmentIndex

        super.touchesEnded(touches, with: event)

        if reselectable, previousSelectedSegmentIndex == self.selectedSegmentIndex {
            let touch = touches.first!
            let touchLocation = touch.location(in: self)
            if bounds.contains(touchLocation) {
                self.sendActions(for: .valueChanged)
            }
        }
    }
    
    @IBInspectable
    public var indicatorColor: UIColor = .black {
        didSet {
            indicatorView?.backgroundColor = indicatorColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var textColor: UIColor {
        get { self.titleTextAttributes(for: .normal)?[NSAttributedString.Key.foregroundColor] as? UIColor ?? .black }
        set(value){
            var existing = self.titleTextAttributes(for: .normal) ?? [:]
            existing[NSAttributedString.Key.foregroundColor] = value
            self.setTitleTextAttributes(existing, for: .normal)
        }
    }
    
    @IBInspectable
    public var textSize: CGFloat {
        get { (self.titleTextAttributes(for: .normal)?[NSAttributedString.Key.font] as? UIFont)?.pointSize ?? 14 }
        set(value){
            var existing = self.titleTextAttributes(for: .normal) ?? [:]
            existing[NSAttributedString.Key.font] = UIFont.get(size: value, style: [])
            self.setTitleTextAttributes(existing, for: .normal)
        }
    }

    private var indicatorView: UIView? = nil

    private func materialTabStyle() {

        #if !TARGET_INTERFACE_BUILDER
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = .clear
        }
        tintColor = .clear
        backgroundColor = .clear

           // Run this code only in the app
        let imageBounds = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, 1)
        UIColor.clear.setFill()
        UIRectFill(imageBounds)
        let clearImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        setBackgroundImage(clearImage, for: .selected, barMetrics: .default)
        setBackgroundImage(clearImage, for: .highlighted, barMetrics: .default)
        setBackgroundImage(clearImage, for: [.highlighted, .selected], barMetrics: .default)
        setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)



        setBackgroundImage(clearImage, for: .normal, barMetrics: UIBarMetrics.default)
        setBackgroundImage(clearImage, for: .focused, barMetrics: UIBarMetrics.default)
        setBackgroundImage(clearImage, for: .highlighted, barMetrics: UIBarMetrics.default)
        setBackgroundImage(clearImage, for: .selected, barMetrics: UIBarMetrics.default)
        
        delay(milliseconds: 16) {
            self.addIndicator()
        }
        #else
           // Run this code only in Interface Builder
        #endif
    }
    private func getSegment(index: Int) -> UIView? {
        let title = self.titleForSegment(at: index)
        for s in subviews {
            if (s.find { ($0 as? UILabel)?.text == title }) != nil {
                return s
            }
        }
        return nil
    }
    private func addIndicator(size: CGFloat = 4){
        let buttonBar = UIView()
        // This needs to be false since we are using auto layout constraints
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = indicatorColor
        addSubview(buttonBar)
        indicatorView = buttonBar

        let getNewBounds: ()->CGRect = { [weak self, weak buttonBar] in
            guard let self = self else { return .zero }
            let selectedSegmentIndex = min(max(self.selectedSegmentIndex, 0), self.numberOfSegments - 1)
            guard
                let segment = self.getSegment(index: selectedSegmentIndex)
                else {
                return CGRect.zero
            }
            let newBounds = CGRect(
                x: segment.frame.origin.x,
                y: self.bounds.size.height - size,
                width: segment.frame.size.width,
                height: size
            )
            return newBounds
        }

        let newBounds = getNewBounds()
        buttonBar.frame = newBounds

        var midAnimation = false

        self.addOnLayoutSubviews { [weak self, weak buttonBar] in
            guard let buttonBar = buttonBar else { return }
            let newBounds = getNewBounds()
            if newBounds != buttonBar.frame {
                midAnimation = true
                UIView.animate(withDuration: 0.3, animations: {
                    buttonBar.frame = newBounds
                }, completion: { _ in
                    midAnimation = false
                })
            }
        }

        self.addAction(for: .allEvents, action: { [weak self, weak buttonBar] in
            guard let buttonBar = buttonBar else { return }
            let newBounds = getNewBounds()
            if newBounds != buttonBar.frame {
                midAnimation = true
                UIView.animate(withDuration: 0.3, animations: {
                    buttonBar.frame = newBounds
                }, completion: { _ in
                    midAnimation = false
                })
            }
        })
    }

}

private extension UIView {
    func find(_ filter: (UIView)->Bool) -> UIView? {
        if filter(self) {
            return self
        }
        for s in subviews {
            if let found = s.find(filter) {
                return found
            }
        }
        return nil
    }
}
