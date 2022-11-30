import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var CallbackKey = "UIBarButtonItem" + "CallbackKey"
}

// MARK: - 属性
public extension SaberEx where Base: UIBarButtonItem {
    /// 获取自定义的标题`view`
    var customView: UIView? {
        return base.customView
    }
}

// MARK: - 构造方法
public extension UIBarButtonItem {
    /// 创建固定宽度的弹簧
    /// - Parameter spacing: 宽度
    convenience init(flexible spacing: CGFloat) {
        self.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        width = spacing
    }

    /// 创建自定义`UIBarButtonItem`
    /// - Parameters:
    ///   - imageName:图片名称
    ///   - highlightedImageName:高亮图片名称
    ///   - title:标题
    ///   - font:字体
    ///   - titleColor:标题颜色
    ///   - highlightedTitleColor:高亮标题颜色
    ///   - target:事件响应方
    ///   - action:事件处理方法
    convenience init(
        imageName: String? = nil,
        highlightedImageName: String? = nil,
        title: String? = nil,
        font: UIFont? = nil,
        titleColor: UIColor? = nil,
        highlightedTitleColor: UIColor? = nil,
        target: Any? = nil,
        action: Selector?
    ) {
        let button = UIButton(type: .custom)
        // 设置默认图片
        if let imageName = imageName {
            button.setImage(imageName.sb.toImage(), for: .normal)
        }
        // 设置高亮图片
        if let highlightedImageName = highlightedImageName {
            button.setImage(highlightedImageName.sb.toImage(), for: .highlighted)
        }
        // 设置标题文字
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        // 设置标题字体
        if let font = font {
            button.titleLabel?.font = font
        }
        // 设置标题颜色
        if let titleColor = titleColor {
            button.setTitleColor(titleColor, for: .normal)
        }
        // 设置高亮标题颜色
        if let highlightedTitleColor = highlightedTitleColor {
            button.setTitleColor(highlightedTitleColor, for: .highlighted)
        }
        // 设置响应方法
        if let target = target,
           let action = action
        {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        button.spacing(3)

        self.init(customView: button)
    }
}

extension UIBarButtonItem: Defaultable {}

// MARK: - 链式方法
public extension UIBarButtonItem {
    typealias Associatedtype = UIBarButtonItem

    /// 创建默认`UIBarButtonItem`
    static func `default`() -> UIBarButtonItem {
        let item = UIBarButtonItem()
        return item
    }

    /// 设置图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置自定义标题
    /// - Parameter view: 自定义`view`
    /// - Returns: `Self`
    @discardableResult
    func customView(_ view: UIView?) -> Self {
        customView = view
        return self
    }

    /// 设置宽度
    /// - Parameter width: 宽度
    /// - Returns: `Self`
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        self.width = width
        return self
    }

    /// 将事件响应者及事件响应方法添加到`UIBarButtonItem`
    /// - Parameters:
    ///   - target:事件响应者
    ///   - action:事件响应方法
    @discardableResult
    func addAction(_ target: AnyObject, action: Selector) -> Self {
        self.target = target
        self.action = action
        return self
    }

    /// 添加事件响应者
    /// - Parameter action: 事件响应者
    /// - Returns: `Self`
    @discardableResult
    func target(_ target: AnyObject) -> Self {
        self.target = target
        return self
    }

    /// 添加事件响应方法
    /// - Parameter action: 事件响应方法
    /// - Returns: `Self`
    @discardableResult
    func action(_ action: Selector) -> Self {
        self.action = action
        return self
    }

    /// 添加事件处理回调
    /// - Parameters:
    ///   - callback:事件处理回调
    /// - Returns:`Self`
    @discardableResult
    func addCallback(_ callback: ((UIBarButtonItem?) -> Void)?) -> Self {
        swiftCallback = callback
        addAction(self, action: #selector(eventHandler(_:)))
        return self
    }
}

// MARK: - AssociatedAttributes
extension UIBarButtonItem: AssociatedAttributes {
    internal typealias T = UIBarButtonItem
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
    @objc internal func eventHandler(_ event: UIBarButtonItem) {
        swiftCallback?(event)
    }
}
