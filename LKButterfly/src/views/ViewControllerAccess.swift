//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import Alamofire
import AlamofireImage
import MapKit


//--- ViewControllerAccess
@objc public class ViewControllerAccess: NSObject {
    public unowned let parentViewController: UIViewController
    public init(_ parentViewController: UIViewController){
        self.parentViewController = parentViewController
    }
}

public extension ViewControllerAccess {
    func pickLayout(view: UIView, passOrFail: @escaping () -> Bool) -> Bool {
        return (parentViewController as! ButterflyViewController).pickLayout(view: view, passOrFail: passOrFail)
    }
}
