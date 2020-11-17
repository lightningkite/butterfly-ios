//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import Alamofire
import AlamofireImage
import MapKit


public extension ViewControllerAccess {

    func share(shareTitle: String, message: String? = nil, url: String? = nil, image: Image? = nil) -> Void {
        var items: Array<Any> = []
        if let message = message {
            items.append(message)
        }
        if let url = url, let fixed = URL(string: url) {
            items.append(fixed)
        }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.parentViewController.view
        if let b = self.parentViewController as? ButterflyViewController {
            vc.popoverPresentationController?.sourceRect = CGRect(x: b.lastTapPosition.x, y: b.lastTapPosition.y, width: 1, height: 1)
        } else {
            vc.popoverPresentationController?.sourceRect = CGRect(x: self.parentViewController.view.frame.centerX(), y: self.parentViewController.view.frame.centerY(), width: 1, height: 1)
        }
        self.parentViewController.present(vc, animated: true, completion: nil)
    }

    func openUrl(url: String) -> Bool {
        if let url = URL(string: url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return true
            } else {
                return false
            }
        }
        return false
    }

    func openAndroidAppOrStore(packageName: String) {
        let _ = openUrl(url: "market://details?id=\(packageName)")
    }

    func openIosStore(numberId: String) {
        let _ = openUrl(url: "https://apps.apple.com/us/app/taxbot/id\(numberId)")
    }

    func openMap(coordinate: GeoCoordinate, label: String? = nil, zoom: Float? = nil) -> Void {
        var options: Array<(String, ()->Void)> = [
            ("Apple Maps", {
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate.toIos(), addressDictionary: nil))
                mapItem.name = label
                mapItem.openInMaps()
            })
        ]
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            options.append(("Google Maps", {
                var url = "string: comgooglemaps://?center=\(coordinate.latitude),\(coordinate.longitude)"
                if let zoom = zoom {
                    url += "&zoom=\(zoom)"
                }
                if let label = label {
                    url += "&q=\(label)"
                }
                UIApplication.shared.open(URL(string: url)!)
            }))
        }
        //TODO: Could add more options
        if options.count == 1 {
            options[0].1()
        } else {
            let optionsView = UIAlertController(title: "Open in Maps", message: nil, preferredStyle: .actionSheet)
            for option in options {
                optionsView.addAction(UIAlertAction(title: option.0, style: .default, handler: { (action) in
                    optionsView.dismiss(animated: true, completion: nil)
                    option.1()
                }))
            }
            self.parentViewController.present(optionsView, animated: true, completion: nil)
        }
    }
}
