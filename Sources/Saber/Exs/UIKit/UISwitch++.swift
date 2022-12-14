import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var CallbackKey = "UISwitch" + "CallbackKey"
}

// MARK: - 方法
public extension SaberEx where Base: UISwitch {
    /// 切换开关状态
    /// - Parameter animated:是否动画
    func toggle(animated: Bool = true) {
        base.setOn(!base.isOn, animated: animated)
    }

    /// 添加事件回调
    /// - Parameters:
    ///   - callback: 闭包
    ///   - controlEvent: 事件
    func addCallback(_ callback: ((_ isOn: Bool?) -> Void)?, controlEvent: UIControl.Event = .touchUpInside) {
        base.swiftCallback = callback
        base.addTarget(base, action: #selector(base.addCallback(_:)), for: controlEvent)
    }
}

// MARK: - AssociatedAttributes
extension UISwitch: AssociatedAttributes {
    internal typealias T = Bool
    internal var swiftCallback: SwiftCallback? {
        get {
            return AssociatedObject.object(self, &AssociateKeys.CallbackKey)
        }
        set {
            AssociatedObject.associate(self, &AssociateKeys.CallbackKey, newValue)
        }
    }

    /// 事件处理
    /// - Parameter event:事件发生者
    @objc internal func addCallback(_ event: UISwitch) {
        swiftCallback?(event.isOn)
    }
}

// MARK: - 链式语法
public extension UISwitch {
    typealias Associatedtype = UISwitch

    /// 创建默认`UISlider`
    override class func `default`() -> Associatedtype {
        let switchBtn = UISwitch()
        return switchBtn
    }
}
