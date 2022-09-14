import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var closure = "UISwitch" + "closure"
}

// MARK: - 方法
public extension UISwitch {
    /// 切换开关状态
    /// - Parameter animated: 是否动画
    func toggle(animated: Bool = true) {
        setOn(!isOn, animated: animated)
    }

    /// 添加事件回调
    /// - Parameters:
    ///   - controlEvents: 事件类型
    ///   - switchCallBack: 事件闭包
    /// - Returns: 闭包函数
    func addActionHandler(_ action: ((_ isOn: Bool?) -> Void)?, controlEvent: UIControl.Event = .touchUpInside) {
        swiftCallback = action
        addTarget(self, action: #selector(switchEventHandler(_:)), for: controlEvent)
    }
}

// MARK: - AssociateCompatible
extension UISwitch: AssociateCompatible {
    internal typealias T = Bool
    internal var swiftCallback: SwiftCallback? {
        get {
            return AssociatedObject.object(self, &AssociateKeys.closure)
        }
        set {
            AssociatedObject.associate(self, &AssociateKeys.closure, newValue)
        }
    }

    /// 事件处理
    /// - Parameter event: 事件发生者
    @objc internal func switchEventHandler(_ event: UISwitch) {
        swiftCallback?(event.isOn)
    }
}
