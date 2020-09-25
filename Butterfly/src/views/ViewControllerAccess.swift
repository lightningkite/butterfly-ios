//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import Alamofire
import AlamofireImage
import MapKit


//--- ViewControllerAccess
public class ViewControllerAccess: NSObject {
    public unowned let parentViewController: UIViewController
    public init(_ parentViewController: UIViewController){
        self.parentViewController = parentViewController
    }
}
