import UIKit

// MARK: - 静态属性
public extension SaberEx where Base: UITabBarController {
    /// `UITabBarController`选中索引
    static var selectedIndex: Int {
        get {
            currentTabBarController?.selectedIndex ?? 0
        }
        set {
            currentTabBarController?.selectedIndex = newValue
        }
    }

    /// 当前有效的`UITabBarController`
    static var currentTabBarController: UITabBarController? {
        guard let currentTabBarController = UIWindow.sb.window?.rootViewController as? UITabBarController else {
            return nil
        }
        return currentTabBarController
    }
}
