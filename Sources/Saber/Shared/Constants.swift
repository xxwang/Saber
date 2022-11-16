import UIKit

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
public let kStatusBarHeight: CGFloat = Saber.isXSeries ? 44 : 20
/// 导航栏高度
public let kNavBarHeight: CGFloat = 44
/// 导航整体高度
public let kNavAllHeight = kStatusBarHeight + kNavBarHeight
/// 标签栏高度
public let kTabBarHeight: CGFloat = 49
/// 标签栏与底部的间距
public let kBottomIndent: CGFloat = Saber.isXSeries ? 34 : 0
/// 标签栏整体高度
public let kTabAllHeight: CGFloat = kTabBarHeight + kBottomIndent
/// 安全区域
public var kSafeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) { return UIWindow.sb.window?.safeAreaInsets ?? .zero }
    return .zero
}

// MARK: - ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ 屏幕尺寸 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

// MARK: - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ AppDelegate ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
public let kAppDelegate = UIApplication.shared.delegate

@available(iOS 13.0, *)
public var kSceneDelegate: UIWindowSceneDelegate {
    let connectedScenes = UIApplication.shared.connectedScenes
    var sceneDelegate: UIWindowSceneDelegate!
    connectedScenes.forEach { scene in
        if let windowScene = scene as? UIWindowScene,
           let windowSceneDelegate = windowScene.delegate as? UIWindowSceneDelegate
        {
            sceneDelegate = windowSceneDelegate
            return
        }
    }
    return sceneDelegate
}

// MARK: - ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ AppDelegate ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
