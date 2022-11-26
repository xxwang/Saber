import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var CallbackKey = "UIBarButtonItem" + "CallbackKey"
}

// MARK: - 静态属性
public extension UIBarButtonItem {
    /// 创建一个弹性的`UIBarButtonItem`
    static var flexibleSpace: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}

// MARK: - 方法
public extension UIBarButtonItem {
    /// 将事件响应者及事件响应方法添加到`UIBarButtonItem`
    /// - Parameters:
    ///   - target:事件响应者
    ///   - action:事件响应方法
    func addAction(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }

    /// 添加事件处理回调
    /// - Parameters:
    ///   - action:事件处理回调
    /// - Returns:`Self`
    @discardableResult
    func addActionHandler(_ action: ((UIBarButtonItem?) -> Void)?) -> Self {
        swiftCallback = action
        addAction(self, action: #selector(eventHandler(_:)))
        return self
    }
}

// MARK: - 静态方法
public extension UIBarButtonItem {
    /// 创建特定宽度的`UIBarButtonItem`
    /// - Parameter width:UIBarButtonItem的宽度
    static func fixedSpace(width: CGFloat) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        barButtonItem.width = width
        return barButtonItem
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
    /// - Returns:`UIBarButtonItem`
    static func create(
        imageName: String? = nil,
        highlightedImageName: String? = nil,
        title: String? = nil,
        font: UIFont? = nil,
        titleColor: UIColor? = nil,
        highlightedTitleColor: UIColor? = nil,
        target: Any? = nil,
        action: Selector?
    ) -> UIBarButtonItem {
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

        button.sizeToFit()
        return UIBarButtonItem(customView: button)
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
