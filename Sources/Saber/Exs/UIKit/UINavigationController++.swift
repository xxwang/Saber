import UIKit

// MARK: - 方法
public extension SaberEx where Base: UINavigationController {
    /// `Push`方法(把控制器压入导航栈中)
    /// - Parameters:
    ///   - viewController: 要入栈的控制器
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func push(
        _ viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    /// `pop`方法(把控制器从栈中移除)
    /// - Parameters:
    ///   - animated:是否动画
    ///   - completion:完成回调
    func pop(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popViewController(animated: animated)
        CATransaction.commit()
    }

    /// 设置导航条为透明
    /// - Parameter tintColor:导航条`tintColor`
    func transparent(with tintColor: UIColor = .white) {
        base.navigationBar.isTranslucent = true
        base.navigationBar.setBackgroundImage(UIImage(), for: .default)
        base.navigationBar.backgroundColor = .clear
        base.navigationBar.barTintColor = .clear
        base.navigationBar.shadowImage = UIImage()
        base.navigationBar.tintColor = tintColor
        base.navigationBar.titleTextAttributes = [.foregroundColor: tintColor]
    }
}

extension UINavigationController: Defaultable {}
public extension UINavigationController {
    /// 关联类型
    typealias Associatedtype = UINavigationController

    /// 创建默认`UINavigationController`
    static func `default`() -> UINavigationController {
        let item = UINavigationController()
        return item
    }
}
