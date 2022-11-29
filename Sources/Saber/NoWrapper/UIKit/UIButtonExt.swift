import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var CallbackKey = "UIButton" + "CallbackKey"
    static var ExpandSizeKey = "UIButton" + "ExpandSizeKey"
}

// MARK: - 属性
public extension UIButton {
    /// 按钮禁用状态的图像；也可以从故事板上查看
    @IBInspectable
    var imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }

    /// 按钮高亮显示状态的图像；也可以从故事板上查看
    @IBInspectable
    var imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }

    /// 按钮正常状态的图像；也可以从故事板上查看
    @IBInspectable
    var imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }

    /// 按钮所选状态的图像；也可以从故事板上查看
    @IBInspectable
    var imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }

    /// 按钮禁用状态的标题颜色；也可以从故事板上查看
    @IBInspectable
    var titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }

    /// 按钮高亮显示状态的标题颜色；也可以从故事板上查看
    @IBInspectable
    var titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }

    /// 按钮正常状态的标题颜色；也可以从故事板上查看
    @IBInspectable
    var titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }

    /// 按钮所选状态的标题颜色；也可以从故事板上查看
    @IBInspectable
    var titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }

    /// 按钮的禁用状态标题；也可以从故事板上查看
    @IBInspectable
    var titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }

    /// 按钮高亮显示状态的标题；也可以从故事板上查看
    @IBInspectable
    var titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }

    /// 按钮的正常状态标题；也可以从故事板上查看
    @IBInspectable
    var titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }

    /// 按钮所选状态的标题；也可以从故事板上查看
    @IBInspectable
    var titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }
}

// MARK: - 纯文字按钮尺寸
public extension UIButton {
    /// 获取指定宽度下字符串的Size
    func textSize(_ maxWidth: CGFloat = sb1.sc.width) -> CGSize {
        if let label = titleLabel {
            return label.textSize(maxWidth)
        }
        return .zero
    }

    /// 获取指定宽度下属性字符串的Size
    func attributedSize(_ maxWidth: CGFloat = sb1.sc.width) -> CGSize {
        if let attText = currentAttributedTitle {
            return attText.sb.strSize(maxWidth)
        }
        return .zero
    }
}

// MARK: - UIButton图片与title位置
public enum CMButtonLyoutStyle {
    case imageTop
    case imageBottom
    case imageLeft
    case imageRight
}

// MARK: - 按钮布局
public extension UIButton {
    /// 按枚举将 btn 的 image 和 title 之间位置处理
    ///  ⚠️ frame 大小必须已确定
    /// - Parameters:
    ///   - padding:间距
    ///   - style:布局样式
    func changeLayout(_ padding: CGFloat, style: CMButtonLyoutStyle) {
        let imageRect: CGRect = imageView?.frame ?? .zero
        let titleRect: CGRect = titleLabel?.frame ?? .zero
        let buttonWidth: CGFloat = frame.size.width
        let buttonHeight: CGFloat = frame.size.height
        let totalHeight = titleRect.size.height + padding + imageRect.size.height

        switch style {
        case .imageLeft:
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: padding / 2,
                bottom: 0,
                right: -padding / 2
            )
            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -padding / 2,
                bottom: 0,
                right: padding / 2
            )
        case .imageRight:
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -(imageRect.size.width + padding / 2),
                bottom: 0,
                right: imageRect.size.width + padding / 2
            )
            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: titleRect.size.width + padding / 2,
                bottom: 0,
                right: -(titleRect.size.width + padding / 2)
            )
        case .imageTop:
            titleEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y,
                left: (buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2,
                bottom: -((buttonHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y),
                right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2
            )
            imageEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 - imageRect.origin.y,
                left: buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2,
                bottom: -((buttonHeight - totalHeight) / 2 - imageRect.origin.y),
                right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2)
            )
        case .imageBottom:
            titleEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 - titleRect.origin.y,
                left: (buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2,
                bottom: -((buttonHeight - totalHeight) / 2 - titleRect.origin.y),
                right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2
            )
            imageEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y,
                left: buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2,
                bottom: -((buttonHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2)
            )
        }
    }

    /// 调整图标与文字的间距(必须左图右字)
    func spacing(_ spacing: CGFloat) {
        let sp = spacing * 0.5
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -sp, bottom: 0, right: sp)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: sp, bottom: 0, right: -sp)
    }
}

// MARK: - 按钮事件处理
public extension UIButton {
    /// `button`的事件
    /// - Parameters:
    ///   - controlEvents:事件类型,默认是 `touchUpInside`
    ///   - ButtonResult:事件
    /// - Returns:闭包事件
    func addActionHandler(_ action: ((_ button: UIButton?) -> Void)?, controlEvent: UIControl.Event = .touchUpInside) {
        swiftCallback = action
        addTarget(self, action: #selector(swiftButtonAction), for: controlEvent)
    }
}

// MARK: - AssociatedAttributes
extension UIButton: AssociatedAttributes {
    internal typealias T = UIButton
    internal var swiftCallback: SwiftCallback? {
        get { return AssociatedObject.object(self, &AssociateKeys.CallbackKey) }
        set { AssociatedObject.associate(self, &AssociateKeys.CallbackKey, newValue) }
    }

    @objc internal func swiftButtonAction(_ button: UIButton) {
        swiftCallback?(button)
    }
}

// MARK: - Button扩大点击事件
public extension UIButton {
    /// 扩大UIButton的点击区域,向四周扩展10像素的点击范围
    /// - Parameter size:向四周扩展像素的点击范围
    func expandSize(size: CGFloat) {
        objc_setAssociatedObject(self, &AssociateKeys.ExpandSizeKey, size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }

    fileprivate func expandRect() -> CGRect {
        let expandSize = objc_getAssociatedObject(self, &AssociateKeys.ExpandSizeKey)
        if expandSize != nil {
            return CGRect(x: bounds.origin.x - (expandSize as! CGFloat), y: bounds.origin.y - (expandSize as! CGFloat), width: bounds.size.width + 2 * (expandSize as! CGFloat), height: bounds.size.height + 2 * (expandSize as! CGFloat))
        } else {
            return bounds
        }
    }
}

// MARK: - 触摸范围
public extension UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = expandRect()
        if buttonRect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        } else {
            return buttonRect.contains(point)
        }
    }
}

// MARK: - 方法
public extension UIButton {
    private var states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }

    /// 为按钮的所有状态设置同样的图片
    /// - Parameter image:要设置的图片
    func setImageForAllStates(_ image: UIImage) {
        states.forEach { setImage(image, for: $0) }
    }

    /// 为按钮的所有状态设置同样的标题颜色
    /// - Parameter color:要设置的颜色
    func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { setTitleColor(color, for: $0) }
    }

    /// 为按钮的所有状态设置同样的标题
    /// - Parameter title:标题文字
    func setTitleForAllStates(_ title: String) {
        states.forEach { setTitle(title, for: $0) }
    }

    /// 将标题文本和图像居中对齐
    /// - Parameters:
    ///   - imageAboveText:设置为true可使图像位于标题文本上方,默认值为false,图像位于文本左侧
    ///   - spacing:标题文本和图像之间的间距
    func centerTextAndImage(imageAboveText: Bool = false, spacing: CGFloat) {
        if imageAboveText {
            guard
                let imageSize = imageView?.image?.size,
                let text = titleLabel?.text,
                let font = titleLabel?.font else { return }

            let titleSize = text.size(withAttributes: [.font: font])

            let titleOffset = -(imageSize.height + spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleOffset, right: 0.0)

            let imageOffset = -(titleSize.height + spacing)
            imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0.0, bottom: 0.0, right: -titleSize.width)

            let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
            contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
        } else {
            let insetAmount = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
}

// MARK: - 链式语法
public extension UIButton {
    /// 创建默认`UIButton`
    static var defaultButton: UIButton {
        let button = UIButton(type: .custom)
        return button
    }

    /// 设置`title`
    /// - Parameters:
    ///   - text:文字
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func title(_ text: String, _ state: UIControl.State = .normal) -> Self {
        setTitle(text, for: state)
        return self
    }

    /// 设置属性文本标题
    /// - Parameters:
    ///   - title:属性文本标题
    ///   - state:状态
    /// - Returns:`Self`
    func attributedTitle(_ title: NSAttributedString?, _ state: UIControl.State = .normal) -> Self {
        setAttributedTitle(title, for: state)
        return self
    }

    /// 设置文字颜色
    /// - Parameters:
    ///   - color:文字颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func titleColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }

    /// 设置文字颜色
    /// - Parameters:
    ///   - hex:文字颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func titleColor(_ hex: String, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(UIColor(hex: hex), for: state)
        return self
    }

    /// 设置字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }

    /// 设置系统字体
    /// - Parameter fontSize:字体大小
    /// - Returns:`Self`
    @discardableResult
    func systemFont(_ fontSize: CGFloat) -> Self {
        titleLabel?.font = .systemFont(ofSize: fontSize)
        return self
    }

    /// 设置系统粗体
    /// - Parameter fontSize:字体大小
    /// - Returns:`Self`
    @discardableResult
    func boldSystemFont(_ fontSize: CGFloat) -> Self {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        return self
    }

    /// 设置图片
    /// - Parameters:
    ///   - image:图片
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func image(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }

    /// 设置图片(通过Bundle加载)
    /// - Parameters:
    ///   - bundle:Bundle
    ///   - imageName:图片名字
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func image(in bundle: Bundle? = nil, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        setImage(image, for: state)
        return self
    }

    /// 设置图片(通过`Bundle`加载)
    /// - Parameters:
    ///   - aClass:`className` `bundle`所在的类的类名
    ///   - bundleName:`bundle` 的名字
    ///   - imageName:图片的名字
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func image(forParent aClass: AnyClass, bundleName: String, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        setImage(image, for: state)
        return self
    }

    /// 设置图片(纯颜色的图片)
    /// - Parameters:
    ///   - color:图片颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func image(_ color: UIColor, _ size: CGSize = CGSize(width: 20.0, height: 20.0), _ state: UIControl.State = .normal) -> Self {
        let image = UIImage(color, size: size)
        setImage(image, for: state)
        return self
    }

    /// 设置背景图片
    /// - Parameters:
    ///   - image:图片
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func backgroundImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - aClass:className bundle所在的类的类名
    ///   - bundleName:bundle 的名字
    ///   - imageName:图片的名字
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func backgroundImage(forParent aClass: AnyClass, bundleName: String, _ imageName: String, state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - bundle:Bundle
    ///   - imageName:图片的名字
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func backgroundImage(in bundle: Bundle? = nil, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(纯颜色的图片)
    /// - Parameters:
    ///   - color:背景色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func backgroundImage(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage(color)
        setBackgroundImage(image, for: state)
        return self
    }
}
