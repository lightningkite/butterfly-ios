// File: views/ImageView.loadVideoThumbnail.kt
// Package: com.lightningkite.butterfly.views
import UIKit
import Foundation

public extension ViewWithImage {
    func loadVideoThumbnail(video: Video?) -> Void {
        if video == nil { return }
        self.loadImage(image: nil)
        video!.thumbnail().subscribe(onSuccess: { (it) -> Void in self.loadImage(image: it) }, onError: { (it) -> Void in self.loadImage(image: nil) }).forever()
    }
}

