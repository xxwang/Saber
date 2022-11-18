import AssetsLibrary
import AVFoundation
import CoreLocation
import Photos
import UIKit

public enum AuthorizedManager {
    /// 相机权限
    static func authorizeCameraWith(completion: @escaping (Bool) -> Void) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch granted {
        case .authorized:
            completion(true)
        case .denied:
            UIApplication.openSettings()
        case .restricted:
            UIApplication.openSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            UIApplication.openSettings()
        }
    }

    /// 相册权限
    static func authorizePhotoWith(comletion: ((Bool) -> Void)? = nil) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion?(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            UIApplication.openSettings()
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    comletion?(status == PHAuthorizationStatus.authorized)
                }
            }
        case .limited:
            comletion?(true)
        @unknown default:
            UIApplication.openSettings()
        }
    }

    /// 麦克风
    static func authorizeMicrophoneWith(completion: @escaping (Bool) -> Void) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch granted {
        case .authorized:
            completion(true)
        case .denied:
            UIApplication.openSettings()
        case .restricted:
            UIApplication.openSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            UIApplication.openSettings()
        }
    }

    /// 定位
    static func authorizeLocationWith(completion: @escaping (Bool) -> Void) {
        if CLLocationManager.locationServicesEnabled() == false {
            Saber.info("请打开定位功能!")
            completion(false)
            return
        }
        var granted: CLAuthorizationStatus = .denied
        if #available(iOS 14.0, *) {
            granted = CLLocationManager().authorizationStatus
        } else {
            granted = CLLocationManager.authorizationStatus()
        }
        switch granted {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        case .denied:
            UIApplication.openSettings()
        case .restricted:
            UIApplication.openSettings()
        case .notDetermined:
            CLLocationManager().requestAlwaysAuthorization()
            CLLocationManager().requestWhenInUseAuthorization()
        @unknown default:
            UIApplication.openSettings()
        }
    }
}
