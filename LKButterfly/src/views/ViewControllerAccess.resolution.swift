//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import Alamofire
import AlamofireImage
import MapKit


public extension ViewControllerAccess {
    func getString(resource: StringResource) -> String {
        return resource
    }
    func getColor(resource: ColorResource) -> UIColor {
        return resource
    }
    var displayMetrics: DisplayMetrics {
        return DisplayMetrics(
            density: UIScreen.main.scale,
            scaledDensity: UIScreen.main.scale,
            widthPixels: Int(UIScreen.main.bounds.width * UIScreen.main.scale),
            heightPixels: Int(UIScreen.main.bounds.height * UIScreen.main.scale)
        )
    }

}
