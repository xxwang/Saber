import UIKit

// MARK: - 静态属性
public extension UITabBarController {
    /// `UITabBarController`选中索引
    static var selectedIdx: Int {
        get {
            availableTabBarController?.selectedIndex ?? 0
        }
        set {
            availableTabBarController?.selectedIndex = newValue
        }
    }

    /// 当前有效的`UITabBarController`
    static var availableTabBarController: UITabBarController? {
        guard let rootViewController = UIWindow.sb.window?.rootViewController as? UITabBarController else {
            return nil
        }
        return rootViewController
    }
}
