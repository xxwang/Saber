import UIKit

// MARK: - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 屏幕尺寸 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
public let kScreenBounds = UIScreen.main.bounds
public let kScreenSize = kScreenBounds.size
public let kScreenWidth = min(kScreenSize.width, kScreenSize.height)
public let kScreenHeight = max(kScreenSize.width, kScreenSize.height)

public let kStatusBarHeight: CGFloat = Saber.isIphoneXSeries ? 44 : 20
public let kNavBarHeight: CGFloat = 44
public let kNavAllHeight = kStatusBarHeight + kNavBarHeight

public let kTabBarHeight: CGFloat = 49
public let kBottomIndent: CGFloat = Saber.isIphoneXSeries ? 34 : 0
public let kTabAllHeight: CGFloat = kTabBarHeight + kBottomIndent

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
