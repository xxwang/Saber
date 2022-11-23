import UIKit

// MARK: - 方法
public extension UINavigationController {
    /// `Push`方法(把控制器压入导航栈中)
    /// - Parameters:
    ///   - viewController:要入栈的控制器
    ///   - animated:是否动画
    ///   - completion:完成回调
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    /// `pop`方法(把控制器从栈中移除)
    /// - Parameters:
    ///   - animated:是否动画
    ///   - completion:完成回调
    func popViewController(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    /// 设置导航条为透明
    /// - Parameter tintColor:导航条tintColor
    func setupTransparent(with tintColor: UIColor = .white) {
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = .clear
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = tintColor
        navigationBar.titleTextAttributes = [.foregroundColor: tintColor]
    }
}
