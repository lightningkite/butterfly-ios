//Stub file made with Khrysalis 2 (by Lightning Kite)
import Foundation
import Alamofire
import AlamofireImage
import Photos
import AVKit
import MapKit
import EventKitUI
import DKImagePickerController
import MobileCoreServices

//--- ViewControllerAccess
public extension ViewControllerAccess {
    //--- ViewControllerAccess image helpers
    private static let imageDelegateExtension = ExtensionProperty<ViewControllerAccess, ImageDelegate>()
    private static let documentDelegateExtension = ExtensionProperty<ViewControllerAccess, DocumentDelgate>()
    private var imageDelegate: ImageDelegate {
        if let existing = ViewControllerAccess.imageDelegateExtension.get(self) {
            return existing
        }
        let new = ImageDelegate()
        ViewControllerAccess.imageDelegateExtension.set(self, new)
        return new
    }

    private var documentDelegate: DocumentDelgate {
        if let existing = ViewControllerAccess.documentDelegateExtension.get(self) {
            return existing
        }
        let new = DocumentDelgate()
        ViewControllerAccess.documentDelegateExtension.set(self, new)
        return new
    }

    private func withLibraryPermission(action: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            action()
        } else {
            PHPhotoLibrary.requestAuthorization {_ in
                DispatchQueue.main.async {
                    action()
                }
            }
        }
    }
    //--- ViewControllerAccess.requestImageGallery((URL)->Unit)
    func requestImageGallery(callback: @escaping (URL) -> Void) {
        withLibraryPermission {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                let imageDelegate = self.imageDelegate
                imageDelegate.forImages()
                imageDelegate.onImagePicked = callback
                imageDelegate.prepareGallery()
                self.parentViewController.present(imageDelegate.imagePicker, animated: true, completion: nil)
            }
        }
    }


    //--- ViewControllerAccess.requestVideoGallery((URL)->Unit)
    func requestVideoGallery(callback: @escaping (URL) -> Void) -> Void {
        withLibraryPermission {if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                let imageDelegate = self.imageDelegate
                imageDelegate.forVideo()
                imageDelegate.onImagePicked = callback
                imageDelegate.prepareGallery()
                self.parentViewController.present(imageDelegate.imagePicker, animated: true, completion: nil)
            }
        }
    }


    //--- ViewControllerAccess.requestVideosGallery((List<URL>)->Unit)
    func requestVideosGallery(callback: @escaping (Array<URL>) -> Void) -> Void {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.requestImagesGalleryRaw(type: .allVideos, callback: callback)
        } else {
            PHPhotoLibrary.requestAuthorization {_ in
                DispatchQueue.main.async {
                    self.requestImagesGalleryRaw(type: .allVideos, callback: callback)
                }
            }
        }
    }


    //--- ViewControllerAccess.requestVideoCamera(Boolean, (URL)->Unit)
    func requestVideoCamera(front: Bool = false, callback: @escaping (URL) -> Void) -> Void {
        withCameraPermission {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    if(UIImagePickerController.availableMediaTypes(for: .camera)?.contains("public.movie") == true) {
                        let imageDelegate = self.imageDelegate
                        imageDelegate.onImagePicked = callback
                        imageDelegate.forVideo()
                        imageDelegate.prepareCamera(front: front)
                        self.parentViewController.present(imageDelegate.imagePicker, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    //--- ViewControllerAccess.requestMediasGallery((List<URL>)->Unit)
    func requestMediasGallery(callback: @escaping (Array<URL>) -> Void) -> Void {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.requestImagesGalleryRaw(type: .allAssets, callback: callback)
        } else {
            PHPhotoLibrary.requestAuthorization {_ in
                DispatchQueue.main.async {
                    self.requestImagesGalleryRaw(type: .allAssets, callback: callback)
                }
            }
        }
    }

    //--- ViewControllerAccess.requestMediaGallery((URL)->Unit)
    func requestMediaGallery(callback: @escaping (URL) -> Void) -> Void {
        withLibraryPermission {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                let imageDelegate = self.imageDelegate
                imageDelegate.forAll()
                imageDelegate.onImagePicked = callback
                imageDelegate.prepareGallery()
                self.parentViewController.present(imageDelegate.imagePicker, animated: true, completion: nil)
            }
        }
    }

    //--- ViewControllerAccess.requestImagesGallery((List<URL>)->Unit)
    func requestImagesGallery(callback: @escaping (Array<URL>) -> Void) -> Void {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.requestImagesGalleryRaw(type: .allPhotos, callback: callback)
        } else {
            PHPhotoLibrary.requestAuthorization {_ in
                DispatchQueue.main.async {
                    self.requestImagesGalleryRaw(type: .allPhotos, callback: callback)
                }
            }
        }
    }
    private func requestImagesGalleryRaw(type: DKImagePickerControllerAssetType, callback: @escaping (Array<URL>) -> Void) {
        let pickerController = DKImagePickerController()
        pickerController.assetType = type
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            DKImageAssetExporter.sharedInstance.exportAssetsAsynchronously(assets: assets, completion: { info in
                callback(assets.map { $0.localTemporaryPath! })
            })
        }
        self.parentViewController.present(pickerController, animated: true){}
    }

    //--- ViewControllerAccess.requestImageCamera((URL)->Unit)
    func requestImageCamera(front:Bool = false, callback: @escaping (URL) -> Void) {
        withCameraPermission {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    if(UIImagePickerController.availableMediaTypes(for: .camera)?.contains("public.image") == true) {
                        let imageDelegate = self.imageDelegate
                        imageDelegate.onImagePicked = callback
                        imageDelegate.forImages()
                        imageDelegate.prepareCamera(front: front)
                        self.parentViewController.present(imageDelegate.imagePicker, animated: true, completion: nil)
                    }
                }
            }
        }
    }


    func getMimeType(uri:URL) -> String? {
        let pathExtension = uri.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return nil
    }
    
    func requestDocuments(callback: @escaping (Array<URL>) -> Void){
        let docDelegate = self.documentDelegate
        docDelegate.onDocumentsPicked = callback
        docDelegate.prepareMenu()
        self.parentViewController.present(docDelegate.documentPicker, animated: true, completion: nil)
    }

    func requestDocument(callback: @escaping (URL) -> Void){
        let docDelegate = self.documentDelegate
        docDelegate.onDocumentPicked = callback
        docDelegate.prepareMenu()
        self.parentViewController.present(docDelegate.documentPicker, animated: true, completion: nil)
    }
    
    func requestFiles(callback: @escaping (Array<URL>) -> Void){
        let optionMenu = UIAlertController(
            title: nil,
            message: "What kind of file?",
            preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
        )
            
        let image = UIAlertAction(title: "Images", style: .default, handler: { _ in
            self.requestImagesGallery(callback: callback)
        })
        let video = UIAlertAction(title: "Videos", style: .default, handler: { _ in
            self.requestVideosGallery(callback: callback)
        })
        let doc = UIAlertAction(title: "Documents", style: .default, handler: { _ in
            self.requestDocuments(callback: callback)
        })
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        optionMenu.addAction(image)
        optionMenu.addAction(video)
        optionMenu.addAction(doc)
        optionMenu.addAction(cancelAction)
        
        if let b = self.parentViewController as? ButterflyViewController {
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x: b.lastTapPosition.x, y: b.lastTapPosition.y, width: 1, height: 1)
        } else {
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.parentViewController.view.frame.centerX(), y: self.parentViewController.view.frame.centerY(), width: 1, height: 1)
        }
        self.parentViewController.present(optionMenu, animated: true, completion: nil)
    }

    func requestFile(callback: @escaping (URL) -> Void){
        let optionMenu = UIAlertController(
            title: nil,
            message: "What kind of file?",
            preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
        )
            
        let image = UIAlertAction(title: "Image", style: .default, handler: { _ in
            self.requestImageGallery(callback: callback)
        })
        let video = UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.requestVideoGallery(callback: callback)
        })
        let doc = UIAlertAction(title: "Document", style: .default, handler: { _ in
            self.requestDocument(callback: callback)
        })
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        optionMenu.addAction(image)
        optionMenu.addAction(video)
        optionMenu.addAction(doc)
        optionMenu.addAction(cancelAction)
        
        if let b = self.parentViewController as? ButterflyViewController {
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x: b.lastTapPosition.x, y: b.lastTapPosition.y, width: 1, height: 1)
        } else {
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.parentViewController.view.frame.centerX(), y: self.parentViewController.view.frame.centerY(), width: 1, height: 1)
        }
        self.parentViewController.present(optionMenu, animated: true, completion: nil)
    }

    func getFileName(uri:URL) -> String? {
        return UUID().uuidString + uri.lastPathComponent
    }
    
    func getFileName(name: String, type: HttpMediaType) -> String? {
        return UUID().uuidString + name
    }
    
    func downloadFile(url:String){
        let url = URL(string: url)!

        let documentsUrl:URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationFileUrl = documentsUrl?.appendingPathComponent(getFileName(uri: url)!)

        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localTemp = localURL, let destination = destinationFileUrl{
                do {
                    try FileManager.default.copyItem(at: localTemp, to: destination)
                    
                    DispatchQueue.main.sync {
                        let ac = UIActivityViewController(activityItems: [destination], applicationActivities: nil)
                        ac.popoverPresentationController?.sourceView = self.parentViewController.view
                        if let b = self.parentViewController as? ButterflyViewController {
                            ac.popoverPresentationController?.sourceRect = CGRect(x: b.lastTapPosition.x, y: b.lastTapPosition.y, width: 1, height: 1)
                        } else {
                            ac.popoverPresentationController?.sourceRect = CGRect(x: self.parentViewController.view.frame.centerX(), y: self.parentViewController.view.frame.centerY(), width: 1, height: 1)
                        }
                        self.parentViewController.present(ac, animated: true)
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destination) : \(writeError)")
                }
            }
        }

        task.resume()
    }
    
    func downloadFileData(data: Data, name: String, type: HttpMediaType){

        let documentsUrl:URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationFileUrl = documentsUrl?.appendingPathComponent(getFileName(name: name, type: type)!)
        if let destination = destinationFileUrl{
            do {
                try data.write(to: destination)
                let ac = UIActivityViewController(activityItems: [destination], applicationActivities: nil)
                ac.popoverPresentationController?.sourceView = self.parentViewController.view
                if let b = self.parentViewController as? ButterflyViewController {
                    ac.popoverPresentationController?.sourceRect = CGRect(x: b.lastTapPosition.x, y: b.lastTapPosition.y, width: 1, height: 1)
                } else {
                    ac.popoverPresentationController?.sourceRect = CGRect(x: self.parentViewController.view.frame.centerX(), y: self.parentViewController.view.frame.centerY(), width: 1, height: 1)
                }
                self.parentViewController.present(ac, animated: true)
            } catch (let writeError) {
                print("Error creating a file \(destination) : \(writeError)")
            }
        }
    }

    private func withCameraPermission(action: @escaping ()->Void) {
        DispatchQueue.main.async {
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            if PHPhotoLibrary.authorizationStatus() == .authorized {
                                action()
                            } else {
                                PHPhotoLibrary.requestAuthorization {_ in
                                    action()
                                }
                            }
                        }
                    }
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            if PHPhotoLibrary.authorizationStatus() == .authorized {
                                    action()
                            } else {
                                PHPhotoLibrary.requestAuthorization {_ in
                                    action()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


private class DocumentDelgate : NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    var documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
    var onDocumentsPicked: ((Array<URL>) -> Void)? = nil
    var onDocumentPicked: ((URL) -> Void)? = nil

    func prepareMenu(){
        documentPicker.delegate = self
    }

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.onDocumentsPicked?(urls)
        if let first = urls.first{
            self.onDocumentPicked?(first)
        }
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


//--- Image helpers

private class ImageDelegate : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    var onImagePicked: ((URL)->Void)? = nil

    func forVideo(){
        imagePicker.mediaTypes = ["public.movie"]
    }
    func forImages(){
        imagePicker.mediaTypes = ["public.image"]
    }
    func forAll(){
        imagePicker.mediaTypes = ["public.image", "public.movie"]
    }

    func prepareGallery(){
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    func prepareCamera(front:Bool){
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        if imagePicker.mediaTypes.contains("public.image") {
            imagePicker.cameraCaptureMode = .photo
        } else {
            imagePicker.cameraCaptureMode = .video
        }
        if front{
            imagePicker.cameraDevice = .front
        }else{
            imagePicker.cameraDevice = .rear
        }
        imagePicker.allowsEditing = false
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if #available(iOS 11.0, *) {
            if let image = info[.imageURL] as? URL ?? info[.mediaURL] as? URL {
                print("Image retrieved directly using .imageURL")
                DispatchQueue.main.async {
                    picker.dismiss(animated: true, completion: {
                        self.onImagePicked?(image)
                        self.onImagePicked = nil
                    })
                }
                return
            }
        }
        if let originalImage = info[.editedImage] as? UIImage, let url = originalImage.saveTemp() {
            print("Image retrieved using save as backup")
            picker.dismiss(animated: true, completion: {
                self.onImagePicked?(url)
                self.onImagePicked = nil
            })
        } else if let originalImage = info[.originalImage] as? UIImage, let url = originalImage.saveTemp() {
            print("Image retrieved using save as backup")
            picker.dismiss(animated: true, completion: {
                self.onImagePicked?(url)
                self.onImagePicked = nil
            })
        } else {
            picker.dismiss(animated: true, completion: {
                self.onImagePicked = nil
            })
        }
    }
}

// save
extension UIImage {

    func saveTemp() -> URL? {
        let id = UUID().uuidString
        let tempDirectoryUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp-butterfly-photos-\(id)")
        guard let url2 = self.save(at: tempDirectoryUrl) else {
            return nil
        }
        print(url2)
        return url2
    }

    func save(at directory: FileManager.SearchPathDirectory,
              pathAndImageName: String,
              createSubdirectoriesIfNeed: Bool = true,
              compressionQuality: CGFloat = 1.0)  -> URL? {
        do {
        let documentsDirectory = try FileManager.default.url(for: directory, in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: false)
        return save(at: documentsDirectory.appendingPathComponent(pathAndImageName),
                    createSubdirectoriesIfNeed: createSubdirectoriesIfNeed,
                    compressionQuality: compressionQuality)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }

    func save(at url: URL,
              createSubdirectoriesIfNeed: Bool = true,
              compressionQuality: CGFloat = 1.0)  -> URL? {
        do {
            if createSubdirectoriesIfNeed {
                try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            }
            guard let data = jpegData(compressionQuality: compressionQuality) else { return nil }
            try data.write(to: url)
            return url
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
}

// load from path

extension UIImage {
    convenience init?(fileURLWithPath url: URL, scale: CGFloat = 1.0) {
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data, scale: scale)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
}

