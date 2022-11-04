import UIKit

// MARK: - UIWindow
public extension UIWindow {
    /// 获取一个可用的`UIWindow`
    static var availableWindow: UIWindow {
        var window: UIWindow?
        if let w = keyWindow {
            window = w
        } else if let w = delegateWindow {
            window = w
        } else if let w = windows.last {
            window = w
        }

        if window?.windowLevel != .normal {
            for tempWindow in windows {
                if tempWindow.windowLevel == .normal {
                    window = tempWindow
                    break
                }
            }
        }
        return window!
    }

    /// 获取`AppDelegate`的`window`属性(iOS13之后非自定义项目框架, 该属性为`nil`)
    static var delegateWindow: UIWindow? {
        guard let delegateWindow = UIApplication.shared.delegate?.window,
              let window = delegateWindow
        else {
            return nil
        }
        return window
    }

    /// 获取`UIApplication`的`keyWindow`属性
    static var keyWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            self.windows.forEach { w in
                if w.isKeyWindow {
                    window = w
                }
            }
        } else {
            if let w = UIApplication.shared.keyWindow {
                window = w
            }
        }
        return window
    }

    /// 获取所有`UIWindow`
    static var windows: [UIWindow] {
        if #available(iOS 13.0, *) {
            let connectedScenes = UIApplication.shared.connectedScenes
            var connectedWindows: [UIWindow] = []
            connectedScenes.forEach { connectedScene in
                if let windowScene = connectedScene as? UIWindowScene,
                   let windowSceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
                   let sceneWindow = windowSceneDelegate.window as? UIWindow
                {
                    connectedWindows.append(sceneWindow)
                }
            }
            return connectedWindows
        } else {
            let windows = UIApplication.shared.windows
            return windows
        }
    }
}

// MARK: - UIViewController
public extension UIWindow {
    /// 获取可用窗口的根控制器
    static var windowRootViewController: UIViewController? {
        var window: UIWindow = availableWindow
        if let keyWindow = keyWindow { window = keyWindow }
        if let delegateWindow = delegateWindow { window = delegateWindow }
        return window.rootViewController
    }

    /// 递归找当前控制器最顶层的`UIViewController`
    static var topViewController: UIViewController? {
        return self.topViewController()
    }

    /// 获取基准控制器的最顶层控制器
    /// - Parameter base:基准控制器
    /// - Returns:返回 UIViewController
    static func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
        var vc: UIViewController = windowRootViewController!
        if let base = base {
            vc = base
        }

        if let navVC = vc as? UINavigationController {
            return topViewController(navVC.visibleViewController)
        }

        if let tabVC = vc as? UITabBarController {
            return topViewController(tabVC.selectedViewController)
        }

        if let presentedVC = vc.presentedViewController {
            return topViewController(presentedVC.presentedViewController)
        }

        return vc
    }
}

// MARK: - 方法
public extension UIWindow {
    /// 设置`rootViewController`(如果设置之前已经存在`rootViewController`那么切换为新的`viewController`)
    /// - Parameters:
    ///   - viewController:要设置的`viewController`
    ///   - animated:是否动画
    ///   - duration:动画时长
    ///   - options:动画选项
    ///   - competion:完成回调
    func setupRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.25,
        options: UIView.AnimationOptions = .transitionFlipFromRight,
        competion: Callbacks.TaskCallback?
    ) {
        guard animated else {
            rootViewController = viewController
            competion?()
            return
        }

        UIView.transition(with: self, duration: duration, options: options) {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        } completion: { _ in
            competion?()
        }
    }
}

// MARK: - 屏幕方向
public extension UIWindow {
    /// 锁定屏幕方向
    /// - Parameter isLandscape:锁定方向是否为横屏,`true`为锁定横屏
    /// - Parameter block:是否锁定
    /// - Returns:允许方向
    static func blockOrientation(isLandscape: Bool, block: Bool) -> UIInterfaceOrientationMask {
        if isLandscape {
            return block ? .landscape : .allButUpsideDown
        }
        return block ? .portrait : .allButUpsideDown
    }

    /// 屏幕方向切换
    /// - Parameter isLandscape:是否是横屏
    static func changeOrientation(isLandscape: Bool) {
        if isLandscape { // 横屏
            if UIDevice.isLandscape {
                return
            }
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")

            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.landscapeRight.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")

        } else { // 竖屏
            if UIDevice.isPortrait {
                return
            }
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")

            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }
    }
}
