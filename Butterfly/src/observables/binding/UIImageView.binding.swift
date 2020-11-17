//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import AlamofireImage
import Alamofire


//--- ImageView.loadImage(Image?)

//--- ImageView.bindImage(ObservableProperty<Image?>)
public extension ViewWithImage {
    func bindImage(_ image: ObservableProperty<Image?>) -> Void {
        image.subscribeBy { it in
            self.loadImage(it)
        }.until(self.removed)
    }
    func bindImage(image: ObservableProperty<Image?>) -> Void {
        return bindImage(image)
    }
    
    func bindImage(_ image: ObservableProperty<Image>) -> Void {
        image.subscribeBy { it in
            self.loadImage(it)
        }.until(self.removed)
    }
    func bindImage(image: ObservableProperty<Image>) -> Void {
        return bindImage(image)
    }
    
    func bindVideoThumbnail(video: ObservableProperty<Video?>) -> Void {
        video.subscribeBy { it in
            self.loadVideoThumbnail(video: it)
        }.until(self.removed)
    }
}
