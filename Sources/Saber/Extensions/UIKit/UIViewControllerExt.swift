import UIKit

// MARK: - 属性
public extension UIViewController {
    /// 检查`UIViewController`是否加载完成且在`UIWindow`上
    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }
}

// MARK: - `NotificationCenter`通知
public extension UIViewController {
    /// 指定当前控制器为通知的监听者
    /// - Parameters:
    ///   - name: 通知名称
    ///   - selector: 接收到通知要运行的方法
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    /// 把当前控制器从通知监听中移除
    /// - Parameter name: 通知名称
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    /// 移除所有通知监听者
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 类方法
public extension UIViewController {
    /// 从`UIStoryboard`中实例化`UIViewController`
    /// - Parameters:
    ///   - storyboard: `UIViewController`所在的`UIStoryboard`的名称
    ///   - bundle: 故事板所在的`Bundle`
    ///   - identifier: `UIViewController`的`UIStoryboard`标识符
    /// - Returns: 从`UIStoryboard`实例化的`UIViewController`实例
    class func instantiateViewController(from storyboard: String = "Main", bundle: Bundle? = nil, identifier: String? = nil) -> Self {
        let viewControllerIdentifier = identifier ?? String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        guard let viewController = storyboard
            .instantiateViewController(withIdentifier: viewControllerIdentifier) as? Self
        else {
            preconditionFailure(
                "Unable to instantiate view controller with identifier \(viewControllerIdentifier) as type \(type(of: self))")
        }
        return viewController
    }
}

// MARK: - 方法
public extension UIViewController {
    /// 将UIViewController添加为当前控制器childViewController
    /// - Parameters:
    ///   - child: 子控制器
    ///   - containerView: 子控制器view要添加到的父view
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// 从其父级移除当前控制器及其view
    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    /// 用于在做任意控制器上显示`UIAlertController`
    /// - Parameters:
    ///   - title: 提示标题
    ///   - message: 提示内容
    ///   - btnTitles: 按钮标题数组
    ///   - highlightedBtnIndex: 高亮按钮索引
    ///   - completion: 完成回调
    /// - Returns: `UIAlertController`实例
    @discardableResult
    func showAlertController(
        title: String?,
        message: String?,
        buttonTitles: [String]? = nil,
        highlightedButtonIndex: Int? = nil,
        completion: ((Int) -> Void)? = nil
    ) -> UIAlertController {
        // 弹窗控制器实例
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // 按钮标题数组
        var allButtons = buttonTitles ?? [String]()
        // 如果标题数组为空, 添加一个`确定`按钮
        if allButtons.count == 0 {
            allButtons.append("确定")
        }

        for index in 0 ..< allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
                completion?(index)
            })
            alertController.addAction(action)
            // 高亮按钮
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }

    /// 将`UIViewController`显示为弹出框(`Popover`样式显示)
    /// - Parameters:
    ///   - contentVC: 要展示的内容控制器
    ///   - sourcePoint: 箭头位置(从哪里显示出来)
    ///   - contentSize: 内容大小
    ///   - delegate: 代理
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func presentPopover(
        _ contentVC: UIViewController,
        sourcePoint: CGPoint,
        contentSize: CGSize? = nil,
        delegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        // 设置`modal`样式为`popover`
        contentVC.modalPresentationStyle = .popover
        if let contentSize = contentSize {
            contentVC.preferredContentSize = contentSize
        }

        // 设置`popoverPresentationController`
        if let popoverPresentationController = contentVC.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(origin: sourcePoint, size: .zero)
            popoverPresentationController.delegate = delegate
        }
        present(contentVC, animated: animated, completion: completion)
    }
}

// MARK: - 路由
public extension UIViewController {
    /// Modal显示控制器
    /// - Parameters:
    ///   - viewController: 要显示的控制器
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func presentVC(_ viewController: UIViewController, fullScreen: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        if fullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        present(viewController, animated: animated, completion: completion)
    }

    /// 释放`Modal`显示控制器
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func dismissVC(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }

    /// Push控制器
    /// - Parameters:
    ///   - viewController: 要压入栈的控制器
    ///   - animated: 是否动画
    func pushVC(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// POP控制器
    /// - Parameters:
    ///   - animated: 是否动画
    func popVC(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    /// POP到指定控制器
    /// - Parameters:
    ///   - viewController: 指定的控制器
    ///   - animated: 是否动画
    func popTo(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(viewController, animated: animated)
    }

    /// POP到`navigationController`的根控制器
    /// - Parameters:
    ///   - animated: 是否动画
    func popToRootVC(_ animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }

    /// 往前返回(POP)几个控制器
    /// - Parameters:
    ///   - count: 返回(POP)几个控制器
    ///   - animated: 是否有动画
    func pop(count: Int, animated: Bool) {
        guard let navigationController = navigationController else {
            return
        }

        guard count >= 1 else {
            print("can't pop count less 1")
            return
        }
        let viewControllerCount = self.navigationController?.viewControllers.count ?? 0
        if count >= viewControllerCount {
            print("count: \(count), must less than viewControllers count: \(viewControllerCount); will pop to root now!")
            navigationController.popToRootViewController(animated: animated)
            return
        }

        let viewController = navigationController.viewControllers[viewControllerCount - count - 1]
        navigationController.popToViewController(viewController, animated: animated)
    }

    /// `pop`最后一个控制器然后`push`指定控制器
    /// - Parameters:
    ///   - viewController: 要压入栈的控制器
    ///   - animated: 是否要动画
    func popLastAndPush(_ viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = navigationController else {
            return
        }
        var viewControllers = navigationController.viewControllers
        guard viewControllers.count >= 1 else {
            return
        }
        viewControllers.removeLast()
        viewControllers.append(viewController)
        navigationController.setViewControllers(viewControllers, animated: animated)
    }

    /// 往前返回(POP)几个控制器 后`push`进某个控制器
    /// - Parameters:
    ///   - count: 返回(POP)几个控制器
    ///   - vc: 被push的控制器
    ///   - animated: 是否要动画
    func pop(count: Int, andPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = navigationController else {
            return
        }

        if count < 1 {
            print("can't pop count less 1")
            return
        }

        let viewControllerCount = navigationController.viewControllers.count
        if count >= viewControllerCount {
            print("count: \(count), must less than viewControllers count: \(viewControllerCount); will pop to root now!")
            if let first = navigationController.viewControllers.first {
                navigationController.setViewControllers([first, viewController], animated: animated)
            }
            return
        }

        var vcs = navigationController.viewControllers[0 ... (viewControllerCount - count - 1)]
        vcs.append(viewController)
        // 如果栈中控制器数量大于0就隐藏tabBar
        viewController.hidesBottomBarWhenPushed = vcs.count > 0
        navigationController.setViewControllers(Array(vcs), animated: animated)
    }

    /// `POP`到指定类型控制器, 从栈顶逐个遍历
    /// - Parameters:
    ///   - aClass: 要`POP`到的控制器类型
    ///   - animated: 是否动画
    /// - Returns: 是否成功
    @discardableResult
    func popToViewController(as aClass: AnyClass, animated: Bool) -> Bool {
        guard let navigationController = navigationController else {
            return false
        }

        for viewController in navigationController.viewControllers.reversed() {
            if viewController.isMember(of: aClass) {
                navigationController.popToViewController(viewController, animated: animated)
                return true
            }
        }
        return false
    }

    /// pop回上一个界面
    func popToPreviousVC() {
        guard let nav = navigationController else { return }
        if let index = nav.viewControllers.firstIndex(of: self), index > 0 {
            let vc = nav.viewControllers[index - 1]
            nav.popToViewController(vc, animated: true)
        }
    }

    /// 关闭控制器
    /// - Parameter animated: 是否动画
    func closeVC(_ animated: Bool = true) {
        guard let navVC = navigationController else {
            dismiss(animated: animated, completion: nil)
            return
        }

        if navVC.viewControllers.count > 1 {
            navVC.popViewController(animated: animated)
        } else if let _ = navVC.presentingViewController {
            navVC.dismiss(animated: animated, completion: nil)
        }
    }

    /// 获取`push`进来的`UIViewController`
    /// - Returns: `UIViewController`
    func previousPushVc() -> UIViewController? {
        guard let nav = navigationController else { return nil }
        if nav.viewControllers.count <= 1 {
            return nil
        }
        if let index = nav.viewControllers.firstIndex(of: self), index > 0 {
            let vc = nav.viewControllers[index - 1]
            return vc
        }
        return nil
    }
}

// MARK: - Runtime
@objc extension UIViewController {
    /// 交换方法
    override public class func initializeMethod() {
        super.initializeMethod()

        if self == UIViewController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
            DispatchQueue.once(token: onceToken) {
                // viewDidLoad
                let oriSel = #selector(viewDidLoad)
                let repSel = #selector(hook_viewDidLoad)
                _ = hookInstanceMethod(of: oriSel, with: repSel)

                // viewWillAppear
                let oriSel1 = #selector(viewWillAppear(_:))
                let repSel1 = #selector(hook_viewWillAppear(animated:))
                _ = hookInstanceMethod(of: oriSel1, with: repSel1)

                // viewWillDisappear
                let oriSel2 = #selector(viewWillDisappear(_:))
                let repSel2 = #selector(hook_viewWillDisappear(animated:))
                _ = hookInstanceMethod(of: oriSel2, with: repSel2)

                // present
                let oriSelPresent = #selector(present(_:animated:completion:))
                let repSelPresent = #selector(hook_present(_:animated:completion:))
                _ = hookInstanceMethod(of: oriSelPresent, with: repSelPresent)
            }
        } else if self == UINavigationController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
            DispatchQueue.once(token: onceToken) {
                // pushViewController
                let oriSel = #selector(UINavigationController.pushViewController(_:animated:))
                let repSel = #selector(UINavigationController.hook_pushViewController(_:animated:))
                _ = hookInstanceMethod(of: oriSel, with: repSel)
            }
        }
    }

    /// hook`viewDidLoad`
    /// - Parameter animated: 是否动画
    private func hook_viewDidLoad(animated: Bool) {
        hook_viewDidLoad(animated: animated)
    }

    /// hook`viewWillAppear`
    /// - Parameter animated: 是否动画
    private func hook_viewWillAppear(animated: Bool) {
        // 需要注入的代码写在此处
        hook_viewWillAppear(animated: animated)
    }

    /// hook`viewWillDisappear`
    /// - Parameter animated: 是否动画
    private func hook_viewWillDisappear(animated: Bool) {
        // 需要注入的代码写在此处
        hook_viewWillDisappear(animated: animated)
    }

    /// hook`present`
    /// - Parameters:
    ///   - viewControllerToPresent: 要`modal`的控制器
    ///   - flag: 是否动画
    ///   - completion: 完成回调
    private func hook_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.presentationController == nil {
            viewControllerToPresent.presentationController?.presentedViewController.dismiss(animated: false, completion: nil)
            Log.error("viewControllerToPresent.presentationController 不能为 nil")
            return
        }
        hook_present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

@objc public extension UINavigationController {
    /// hook`pushViewController`
    /// - Parameters:
    ///   - viewController: 要压入栈的控制器
    ///   - animated: 是否动画
    func hook_pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 判断是否是根控制器
        if viewControllers.count <= 1 {}
        // push进入下一个控制器
        hook_pushViewController(viewController, animated: animated)
    }
}
