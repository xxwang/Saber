import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var CallbackKey = "UIControl" + "CallbackKey"
    static var HitTimerKey = "UIControl" + "HitTimerKey"
}

// MARK: - 方法
public extension SaberEx where Base: UIControl {
    /// 设置指定时长(单位:秒)内不可重复点击
    /// - Parameter hitTime:时长
    func doubleHit(time: Double = 1) {
        base.doubleHit(hitTime: time)
    }

    /// 添加`UIControl`事件回调
    /// - Parameters:
    ///   - callback:事件回调
    ///   - controlEvent:事件类型
    func addCallback(_ callback: @escaping sb1.Callbacks.ControlResult, for controlEvent: UIControl.Event = .touchUpInside) {
        base.addTarget(base, action: #selector(base.controlClickEventHandler(_:)), for: controlEvent)
        base.swiftCallback = callback
    }
}

// MARK: - 限制连续点击时间间隔
private extension UIControl {
    /// 重复点击限制时间
    var hitTime: Double? {
        get { return AssociatedObject.object(self, &AssociateKeys.HitTimerKey) }
        set { AssociatedObject.associate(self, &AssociateKeys.HitTimerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    /// 点击回调
    var swiftCallback: sb1.Callbacks.ControlResult? {
        get { return AssociatedObject.object(self, &AssociateKeys.CallbackKey) }
        set { AssociatedObject.associate(self, &AssociateKeys.CallbackKey, newValue) }
    }

    /// 设置指定时长(单位:秒)内不可重复点击
    /// - Parameter hitTime:时长
    func doubleHit(hitTime: Double) {
        self.hitTime = hitTime
        addTarget(self, action: #selector(c_preventDoubleHit), for: .touchUpInside)
    }

    /// 防止重复点击实现
    /// - Parameter sender:被点击的`UIControl`
    @objc func c_preventDoubleHit(_ sender: UIControl) {
        isUserInteractionEnabled = false
        DispatchQueue.sb.delay_main_task(hitTime ?? 1.0) { [weak self] in
            guard let self else {
                return
            }
            self.isUserInteractionEnabled = true
        }
    }

    /// 事件处理方法
    /// - Parameter sender:事件发起者
    @objc func controlClickEventHandler(_ sender: UIControl) {
        if let block = swiftCallback {
            block(sender)
        }
    }
}

extension UIControl: Defaultable {}

// MARK: - 链式语法
public extension UIControl {
    /// 关联类型
    typealias Associatedtype = UIControl

    /// 创建默认`UIControl`
    @objc class func `default`() -> Associatedtype {
        let control = UIControl()
        return control
    }

    /// 设置控件是否可用
    /// - Parameter isEnabled:是否可用
    /// - Returns:`Self`
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }

    /// 设置是否可点击
    /// - Parameter isSelected:点击状态
    /// - Returns:`Self`
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }

    /// 设置是否高亮
    /// - Parameter isHighlighted:高亮状态
    /// - Returns:`Self`
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> Self {
        self.isHighlighted = isHighlighted
        return self
    }

    /// 设置垂直方向对齐
    /// - Parameter contentVerticalAlignment:对齐方式
    /// - Returns:`Self`
    @discardableResult
    func contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = contentVerticalAlignment
        return self
    }

    /// 设置水平方向对齐
    /// - Parameter contentHorizontalAlignment:对齐方式
    /// - Returns:`Self`
    @discardableResult
    func contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }

    /// 添加事件(默认点击事件:`touchUpInside`)
    /// - Parameters:
    ///   - target:被监听的对象
    ///   - action:事件
    ///   - events:事件的类型
    /// - Returns:`Self`
    @discardableResult
    func add(_ target: Any?, action: Selector, events: UIControl.Event = .touchUpInside) -> Self {
        addTarget(target, action: action, for: events)
        return self
    }

    /// 移除事件(默认移除 点击事件:touchUpInside)
    /// - Parameters:
    ///   - target:被监听的对象
    ///   - action:事件
    ///   - events:事件的类型
    /// - Returns:`Self`
    @discardableResult
    func remove(_ target: Any?, action: Selector, events: UIControl.Event = .touchUpInside) -> Self {
        removeTarget(target, action: action, for: events)
        return self
    }

    /// 设置在指定时间内禁用多次点击
    /// - Parameter hitTime:禁用时长
    /// - Returns:`Self`
    @discardableResult
    func disableMultiTouch(_ hitTime: Double = 1) -> Self {
        doubleHit(hitTime: hitTime)
        return self
    }
}
