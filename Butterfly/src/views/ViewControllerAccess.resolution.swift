//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import Alamofire
import AlamofireImage
import MapKit


public class ViewControllerAccess: NSObject {
    public func getString(resource: StringResource) -> String {
        return resource
    }
    public func getColor(resource: ColorResource) -> UIColor {
        return resource
    }
    public var displayMetrics: DisplayMetrics {
        return DisplayMetrics(
            density: 1,
            scaledDensity: 1,
            widthPixels: Int(UIScreen.main.bounds.width * UIScreen.main.scale),
            heightPixels: Int(UIScreen.main.bounds.height * UIScreen.main.scale)
        )
    }

}
