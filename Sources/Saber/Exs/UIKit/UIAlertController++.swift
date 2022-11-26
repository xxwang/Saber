import AudioToolbox
import UIKit

// MARK: - 构造方法
public extension UIAlertController {
    /// 创建 `UIAlertController`
    /// - Parameters:
    ///   - title:标题
    ///   - message:详细的信息
    ///   - btnTitle:默认按钮标题
    ///   - style:样式
    ///   - tintColor:`UIAlertController`的`tintColor`
    convenience init(
        _ title: String? = nil,
        message: String? = nil,
        btnTitle: String? = nil,
        style: UIAlertController.Style = .alert,
        tintColor: UIColor? = nil
    ) {
        self.init(title: title, message: message, preferredStyle: style)
        if let color = tintColor { view.tintColor = color }
        if let btnTitle = btnTitle {
            let defaultAction = UIAlertAction(title: btnTitle, style: .cancel, handler: nil)
            addAction(defaultAction)
        }
    }
}

// MARK: - 方法
public extension SaberEx where Base: UIAlertController {
    /// 弹起`UIAlertController`
    /// - Parameters:
    ///   - animated:是否动画
    ///   - shake:是否震动
    ///   - deadline:消失时间
    ///   - completion:完成回调
    func show(
        animated: Bool = true,
        shake: Bool = false,
        deadline: TimeInterval? = nil,
        completion: (() -> Void)? = nil
    ) {
        UIWindow.sb.window?.rootViewController?.present(base, animated: animated, completion: completion)
        if shake { AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) }
        guard let deadline = deadline else { return }
        DispatchQueue.sb.after(deadline) { [weak self] in
            guard let self = self else { return }
            self.base.dismiss(animated: animated, completion: nil)
        }
    }

    /// 添加一个`UIAlertAction`
    /// - Parameters:
    ///   - title:标题
    ///   - style:样式
    ///   - isEnable:是否激活
    ///   - action:点击处理回调
    /// - Returns:`Self`
    func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        isEnabled: Bool = true,
        action: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: action)
        action.isEnabled = isEnabled
        base.addAction(action)
        return action
    }
}

extension UIAlertController: Defaultable {}

// MARK: - 链式语法
public extension UIAlertController {
    /// 关联类型
    typealias Associatedtype = UIAlertController

    /// 创建默认`UIAlertController``.alert`样式
    @objc class func `default`() -> Associatedtype {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        return alertVC
    }

    /// 设置标题
    /// - Parameter title:标题
    /// - Returns:`Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置消息(副标题)
    /// - Parameter message:消息内容
    /// - Returns:`Self`
    @discardableResult
    func message(_ message: String?) -> Self {
        self.message = message
        return self
    }

    /// 添加 `UIAlertAction`
    /// - Parameter action:`UIAlertAction` 事件
    /// - Returns:`Self`
    @discardableResult
    func addAction(action: UIAlertAction) -> Self {
        addAction(action)
        return self
    }

    /// 添加一个`UIAlertAction`
    /// - Parameters:
    ///   - title:标题
    ///   - style:样式
    ///   - isEnable:是否激活
    ///   - action:点击处理回调
    /// - Returns:`Self`
    @discardableResult
    func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        action: ((UIAlertAction) -> Void)? = nil
    ) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: action)
        addAction(action)
        return self
    }

    /// 添加一个`UITextField`
    /// - Parameters:
    ///   - text:输入框默认文字
    ///   - placeholder:占位文本
    ///   - target:事件响应者
    ///   - action:事件响应方法
    /// - Returns:`Self`
    @discardableResult
    func addTextField(
        text: String? = nil,
        placeholder: String? = nil,
        target: Any?,
        action: Selector?
    ) -> Self {
        addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            if let target = target,
               let action = action
            {
                textField.addTarget(target, action: action, for: .editingChanged)
            }
        }
        return self
    }
}
