import UIKit

// MARK: - 静态属性
public extension SaberEx where Base: UIScene {
    /// 获取`bounds`
    static var bounds: CGRect {
        return UIScreen.main.bounds
    }

    /// 获取大小
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }

    /// 获取宽度
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    /// 获取宽度
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    /// 屏幕缩放比
    static var scale: CGFloat {
        return UIScreen.main.scale
    }
}

// MARK: - 静态方法
public extension SaberEx where Base: UIScene {
    /// 检查截屏或者录屏并发送通知
    /// - Parameter action:回调
    static func detectScreenShot(_ action: @escaping (String) -> Void) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { _ in
            action("截屏")
        }
        // 监听录屏通知,iOS 11后才有录屏
        if #available(iOS 11.0, *) {
            // 如果正在捕获此屏幕(例如,录制、空中播放、镜像等),则为真
            if UIScreen.main.isCaptured {
                action("录屏")
            }
            // 捕获的屏幕状态发生变化时,会发送UIScreenCapturedDidChange通知,监听该通知
            NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: mainQueue) { _ in
                action("录屏")
            }
        }
    }
}
