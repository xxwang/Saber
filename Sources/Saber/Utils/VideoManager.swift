import AVFoundation
import AVKit
import Photos
import UIKit

public class VideoManager: NSObject {}

// MARK: - 播放
public extension VideoManager {
    /// 播放视频(`AVPlayerViewController`)
    /// - Parameters:
    ///   - url:视频`URL`
    ///   - target:弹出控制器的源控制器
    static func playVideo(_ url: URL, target: UIViewController) {
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        target.present(controller, animated: true) {
            player.play()
        }
    }
}

// MARK: - 截图
public extension VideoManager {
    /// 截图视频封面(同步)
    /// - Parameter url:视频`URL`
    /// - Returns:封面图片
    static func videoCover(_ url: URL?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        // 截图的时候调整到正确的方向
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    /// 截图视频封面(异步)
    /// - Parameter url:视频`URL`
    /// - Parameter success:结果回调
    /// - Returns:封面图片
    static func videoCover(_ videoURL: URL, success: ((UIImage?) -> Void)?) {
        DispatchQueue.global().async {
            let avAsset = AVURLAsset(url: videoURL, options: nil)
            /// 生成视频截图
            let generator = AVAssetImageGenerator(asset: avAsset)
            generator.appliesPreferredTrackTransform = true
            generator.apertureMode = .encodedPixels
            let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
            var actualTime = CMTimeMake(value: 10, timescale: 10)
            var imageRef: CGImage?
            var image: UIImage?
            do {
                imageRef = try generator.copyCGImage(at: time, actualTime: &actualTime)
                if let cgimage = imageRef {
                    image = UIImage(cgImage: cgimage)
                }
            } catch {
                Saber.info("出现错误!\(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                success?(image)
            }
        }
    }
}

// MARK: - 存取
public extension VideoManager {
    /// 保存视频,`url`需要是本地路径
    /// - Parameters:
    ///   - url:视频保存的地址
    ///   - completed:完成回调
    static func saveVideo(_ url: URL, completed: ((Bool) -> Void)?) {
        AuthorizedManager.authorizePhotoWith { isOK in
            if isOK {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }) { success, error in
                    if let error = error {
                        Saber.info(error.localizedDescription)
                    }
                    completed?(success)
                }
            }
        }
    }

    /// 视频格式转换 & 压缩` .mov `转成` .mp4`
    /// - Parameters:
    ///   - file:文件URL
    ///   - completed:完成回调
    static func mov2mp4(_ file: URL, completed: ((URL) -> Void)?) {
        let asset = AVURLAsset(url: file, options: nil)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            return
        }
        let output = "\(Date().timestamp).mp4".sb.urlByCache()
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = output
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .failed:
                let exportError = exportSession.error
                if let exportError = exportError {
                    Saber.info("AVAssetExportSessionStatusFailed:\(exportError.localizedDescription)")
                }
            case .completed:
                completed?(output)
            default: break
            }
        })
    }

    /// 从`PHAsset`中获取`MP4`链接
    /// - Parameters:
    ///   - asset:`PHAsset`
    ///   - completed:完成回调
    static func mp4Path(from asset: PHAsset, completed: ((String?) -> Void)?) {
        let assetResources = PHAssetResource.assetResources(for: asset)
        var _resource: PHAssetResource?
        for res in assetResources {
            if res.type == .video {
                _resource = res
                break
            }
        }
        guard let resource = _resource else {
            completed?(nil)
            return
        }
        let fileName = resource.originalFilename.components(separatedBy: ".")[0] + ".mp4"

        if asset.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            let savePath = NSTemporaryDirectory() + fileName
            if FileManager.default.fileExists(atPath: savePath) {
                completed?(savePath)
                return
            }
            PHAssetResourceManager.default().writeData(for: resource, toFile: URL(fileURLWithPath: savePath), options: nil, completionHandler: { error in
                if let error = error {
                    Saber.info("convert mp4 failed. \(error)")
                    completed?(nil)
                } else {
                    Saber.info("convert mp4 success")
                    completed?(savePath)
                }
            })
        }
    }
}
