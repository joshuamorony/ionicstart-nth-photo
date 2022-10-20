import Capacitor
import Photos

@objc(NthPhotoPlugin)
public class NthPhotoPlugin: CAPPlugin {
    @objc func getNthPhoto(_ call: CAPPluginCall) {
        let photoAt = Int(call.getString("photoAt") ?? "0") ?? 0
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    let base64String = self.getPhoto(photoAt: photoAt);
                    call.resolve([
                        "image": base64String
                    ])
                } else {
                    call.reject("Not authorised to access Photos")
                }
            })
        } else if photos == .authorized {
            let base64String = self.getPhoto(photoAt: photoAt);
            call.resolve([
                "image": base64String
            ])
        } else {
            call.reject("Something went wrong");
        }
        
    }
    
    func getPhoto(photoAt: Int) -> String {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 100
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let image = self.getAssetThumbnail(asset: fetchResult.object(at: photoAt))
        let imageData:Data =  image.pngData()!
        return imageData.base64EncodedString()
    }

    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
