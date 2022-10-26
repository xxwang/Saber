import UIKit

// MARK: - 链式语法
public extension UITabBarItem {
    /// 设置标题
    /// - Parameter title:标题
    /// - Returns:`Self`
    @discardableResult
    func title(_ title: String) -> Self {
        self.title = title
        return self
    }

    /// 设置默认图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func image(_ image: UIImage) -> Self {
        self.image = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置默认图片
    /// - Parameter imageName:图片名称
    /// - Returns:`Self`
    @discardableResult
    func image(_ imageName: String) -> Self {
        image = imageName.image?.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置选中图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func selectedImage(_ image: UIImage) -> Self {
        selectedImage = image
        return self
    }

    /// 设置选中图片
    /// - Parameter imageName:图片名称
    /// - Returns:`Self`
    @discardableResult
    func selectedImage(_ imageName: String) -> Self {
        selectedImage = imageName.image?.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置`badgeColor`颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func badgeColor(_ color: UIColor) -> Self {
        badgeColor = color
        return self
    }

    /// 设置`badgeColor`颜色
    /// - Parameter hex:十六进制颜色
    /// - Returns:`Self`
    @discardableResult
    func badgeColor(_ hex: String) -> Self {
        badgeColor = UIColor(hex: hex)
        return self
    }

    /// 设置`badgeValue`值
    /// - Parameter value:值
    /// - Returns:`Self`
    @discardableResult
    func badgeValue(_ value: String) -> Self {
        badgeValue = value
        return self
    }
}
