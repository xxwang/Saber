import UIKit

// MARK: - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ AppDelegate ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
public let kAppDelegate = UIApplication.shared.delegate
public let kSceneDelegate = UIApplication.shared.delegate
// MARK: - ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ AppDelegate ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

// MARK: - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ UIWindow ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
/// 屏幕上所有的`UIWindow`
public var kAllWindows: [UIWindow] {
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

/// 应用当前的`keyWindow`
public var kKeyWindow: UIWindow? {
    if #available(iOS 13.0, *) {
        for window in kAllWindows {
            if window.isKeyWindow { return window }
        }
    } else {
        if let window = UIApplication.shared.keyWindow { return window }
    }
    return nil
}

/// 获取`AppDelegate`的`window`属性(iOS13之后非自定义项目框架, 该属性为`nil`)
public var kDelegateWindow: UIWindow? {
    guard let delegateWindow = UIApplication.shared.delegate?.window,
          let window = delegateWindow
    else {
        return nil
    }
    return window
}

/// 获取一个可用的`UIWindow`
public var kWindow: UIWindow? {
    var usableWindow: UIWindow?
    if let window = kAllWindows.last {
        usableWindow = window
    }

    if let window = kKeyWindow {
        usableWindow = window
    }

    if let window = kDelegateWindow {
        usableWindow = window
    }

    if usableWindow?.windowLevel == .normal {
        return usableWindow
    }

    kAllWindows.forEach { window in
        if window.windowLevel == .normal {
            usableWindow = window
        }
    }
    return usableWindow
}

// MARK: - ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ UIWindow ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

// MARK: - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 常用判断 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

// MARK: - ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ 常用判断 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

// MARK: - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 屏幕尺寸 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
/// 屏幕`bounds`
public let kScreenBounds = UIScreen.main.bounds
/// 屏幕大小
public let kScreenSize = kScreenBounds.size
/// 屏幕宽度
public let kScreenWidth = min(kScreenSize.width, kScreenSize.height)
/// 屏幕高度
public let kScreenHeight = max(kScreenSize.width, kScreenSize.height)
/// 状态栏高度
public let kStatusBarHeight: CGFloat = UIDevice.isIphoneXLast ? 44 : 20
/// 导航栏高度
public let kNavBarHeight: CGFloat = 44
/// 导航整体高度
public let kNavAllHeight = kStatusBarHeight + kNavBarHeight
/// 标签栏高度
public let kTabBarHeight: CGFloat = 49
/// 标签栏与底部的间距
public let kBottomIndent: CGFloat = UIDevice.isIphoneXLast ? 34 : 0
/// 标签栏整体高度
public let kTabAllHeight: CGFloat = kTabBarHeight + kBottomIndent
/// 安全区域
public var kSafeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) { return kWindow?.safeAreaInsets ?? .zero }
    return .zero
}

// MARK: - ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ 屏幕尺寸 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
