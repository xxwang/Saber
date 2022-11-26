import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var CallbackKey = "UISlider" + "CallbackKey"
}

// MARK: - 方法
public extension UISlider {
    /// 设置`value`值
    /// - Parameters:
    ///   - value:要设置的值
    ///   - animated:是否动画
    ///   - duration:动画时间
    ///   - completion:完成回调
    func setValue(
        _ value: Float,
        animated: Bool = true,
        duration: TimeInterval = 1,
        completion: (() -> Void)? = nil
    ) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.setValue(value, animated: true)
            }, completion: { _ in
                completion?()
            })
        } else {
            setValue(value, animated: false)
            completion?()
        }
    }

    /// 添加事件处理
    /// - Parameters:
    ///   - action:响应事件的闭包
    ///   - controlEvent:事件类型
    func addActionHandler(_ action: ((Float?) -> Void)?, for controlEvent: UIControl.Event = .valueChanged) {
        swiftCallback = action
        addTarget(self, action: #selector(sliderEventHandler(_:)), for: controlEvent)
    }
}

// MARK: - AssociatedAttributes
extension UISlider: AssociatedAttributes {
    internal typealias T = Float
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
    @objc internal func sliderEventHandler(_ event: UISlider) {
        swiftCallback?(event.value)
    }
}
