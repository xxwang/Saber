import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var statusBar = "UINavigationBar" + "statusBar"
}

// MARK: - 方法
public extension UINavigationBar {
    /// 设置导航条为透明
    /// - Parameter tintColor:`tintColor`
    func setupTransparent(with tintColor: UIColor = .white) {
        isTranslucent = true
        backgroundColor = .clear
        barTintColor = .clear
        setBackgroundImage(UIImage(), for: .default)
        self.tintColor = tintColor
        titleTextAttributes = [.foregroundColor: tintColor]
        shadowImage = UIImage()
    }

    /// 设置导航条背景和文字颜色
    /// - Parameters:
    ///   - background:背景颜色
    ///   - text:文字颜色
    func setupColors(background: UIColor, text: UIColor) {
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
        setBackgroundImage(UIImage(), for: .default)
        tintColor = text
        titleTextAttributes = [.foregroundColor: text]
    }

    /// 修改`statusBar`的背景颜色
    /// - Parameter color:要设置的颜色
    func setupStatusBarBackgroundColor(with color: UIColor) {
        if self.statusBar == nil {
            let statusBar = UIView(frame: CGRect(
                x: 0,
                y: -kSTATUSBAR_HEIGHT,
                width: kSCREEN_WIDTH,
                height: kSCREEN_HEIGHT
            ))
            statusBar.backgroundColor = .clear
            addSubview(statusBar)
            self.statusBar = statusBar
        }
        guard let statusBar = statusBar else {
            return
        }
        statusBar.backgroundColor = color
    }

    /// 移除`statusBar`
    func clearStatusBar() {
        statusBar?.removeFromSuperview()
        statusBar = nil
    }
}

// MARK: - 链式语法
public extension UINavigationBar {
    /// 是否半透明
    /// - Parameter isTranslucent:是否半透明
    /// - Returns:`Self`
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    /// 设置是否大导航
    /// - Parameter large:是否大导航
    /// - Returns:`Self`
    func prefersLargeTitles(_ large: Bool) -> Self {
        prefersLargeTitles = large
        return self
    }

    /// 设置标题字体
    /// - Parameters:
    ///   - font:字体
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.titleTextAttributes
            attributeds[.font] = font
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = titleTextAttributes ?? [:]
            attributeds[.font] = font
            titleTextAttributes = attributeds
        }
        return self
    }

    /// 设置大标题字体
    /// - Parameters:
    ///   - font:字体
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func largeTitleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.largeTitleTextAttributes
            attributeds[.font] = font
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = largeTitleTextAttributes ?? [:]
            attributeds[.font] = font
            titleTextAttributes = attributeds
        }
        return self
    }

    /// 设置标题颜色
    /// - Parameters:
    ///   - color:颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func titleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.titleTextAttributes
            attributeds[.foregroundColor] = color
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = titleTextAttributes ?? [:]
            attributeds[.foregroundColor] = color
            titleTextAttributes = attributeds
        }
        return self
    }

    /// 设置标题颜色
    /// - Parameters:
    ///   - hex:十六进制颜色值
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func titleColor(_ hex: String) -> Self {
        return titleColor(UIColor(hex: hex))
    }

    /// 设置大标题颜色
    /// - Parameters:
    ///   - color:颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func largeTitleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.largeTitleTextAttributes
            attributeds[.foregroundColor] = color
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = largeTitleTextAttributes ?? [:]
            attributeds[.foregroundColor] = color
            titleTextAttributes = attributeds
        }
        return self
    }

    /// 设置大标题颜色
    /// - Parameters:
    ///   - hex:十六进制颜色值
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func largeTitleColor(_ hex: String) -> Self {
        return largeTitleColor(UIColor(hex: hex))
    }

    /// 设置背景颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func backgroundColor(with color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.backgroundColor = color
            appearance.backgroundEffect = nil
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            backgroundColor = color
            barTintColor = color
        }
        return self
    }

    /// 设置背景颜色
    /// - Parameter hex:十六进制颜色
    /// - Returns:`Self`
    @discardableResult
    func backgroundColor(with hex: String) -> Self {
        return backgroundColor(UIColor(hex: hex))
    }

    /// 设置背景图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func backgroundImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.backgroundImage = image
            appearance.backgroundEffect = nil
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            setBackgroundImage(image, for: .default)
        }
        return self
    }

    /// 设置背景图片
    /// - Parameter imageName:图片名称
    /// - Returns:`Self`
    @discardableResult
    func backgroundImage(_ imageName: String) -> Self {
        if let image = imageName.image {
            return backgroundImage(image)
        }
        return self
    }

    /// 设置阴影图片
    /// - Parameter imageName:图片
    /// - Returns:`Self`
    @discardableResult
    func shadowImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.shadowImage = image.withRenderingMode(.alwaysOriginal)
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            shadowImage = image.withRenderingMode(.alwaysOriginal)
        }
        return self
    }

    /// 设置阴影图片
    /// - Parameter imageName:图片名称
    /// - Returns:`Self`
    @discardableResult
    func shadowImage(_ imageName: String) -> Self {
        if let image = imageName.image {
            return shadowImage(image)
        }
        return self
    }

    /// 设置当页面中有滚动时`UITabBar`的外观与`standardAppearance`一致
    /// - Returns:`Self`
    @discardableResult
    func scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = standardAppearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        }
        return self
    }

    /// 设置渐变背景
    /// - Parameters:
    ///   - colors:颜色数组
    ///   - direction:渐变方向
    /// - Returns:`Self`
    @discardableResult
    func gradient(_ colors: [UIColor], direction: SBGradientDirection) -> Self {
        guard let backgroundColor = colors.linearGradientColor(size, direction: direction) else {
            return self
        }
        return self.backgroundColor(with: backgroundColor)
    }
}

// MARK: - 关联属性
private extension UINavigationBar {
    /// 通过 Runtime 的属性关联添加自定义 View
    var statusBar: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociateKeys.statusBar) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.statusBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
