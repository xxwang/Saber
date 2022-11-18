import UIKit
import WebKit

// MARK: - 枚举
public extension UIView {
    /// 抖动方向
    ///
    /// - horizontal:左右抖动
    /// - vertical:上下抖动
    enum ShakeDirection {
        /// 左右抖动
        case horizontal
        /// 上下抖动
        case vertical
    }

    /// 角度单位
    ///
    /// - degrees:度
    /// - radians:弧度
    enum AngleUnit {
        /// 度
        case degrees
        /// 弧度
        case radians
    }

    /// 抖动动画类型
    ///
    /// - linear:线性动画
    /// - easeIn:easeIn动画
    /// - easeOut:easeOut动画
    /// - easeInOut:easeInOut动画
    enum ShakeAnimationType {
        /// 线性动画
        case linear
        /// easeIn动画
        case easeIn
        /// easeOut动画
        case easeOut
        ///  easeInOut动画
        case easeInOut
    }
}

// MARK: - 属性
public extension UIView {
    /// 将 View 转换成图片(截图)
    @objc var screenshot: UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        layer.render(in: context)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }

    /// 查找一个视图的所有子视图
    var allSubViews: [UIView] {
        var views = [UIView]()
        for subView in subviews {
            views.append(subView)
            if !subView.subviews.isEmpty {
                let childView = subView.allSubViews
                views += childView
            }
        }
        return views
    }

    /// view的边框颜色；可以从故事板上查看
    @IBInspectable var layerBorderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // 修复React-Native冲突问题
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// view的边框宽度；可以从故事板上查看
    @IBInspectable var layerBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// view的角半径；可以从故事板上查看
    @IBInspectable var layerCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    /// 检查view书写方向是否为从右到左格式
    var isRightToLeft: Bool {
        if #available(iOS 10.0, macCatalyst 13.0, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }

    /// view的阴影颜色；可以从故事板上查看
    @IBInspectable var layerShadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// view的阴影偏移；可以从故事板上查看
    @IBInspectable var layerShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// view的阴影不透明度；可以从故事板上查看
    @IBInspectable var layerShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// view阴影的半径；可以从故事板上查看
    @IBInspectable var layerShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    /// 是否使用蒙版(范围为view.bounds); 可以从故事板上查看
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }

    /// 获取view的父视图控制器
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// MARK: - 属性`CGRect`
public extension UIView {
    /// 控件顶部(minY)
    var top: CGFloat {
        get { return frame.minY }
        set {
            var temp = frame
            temp.origin.y = newValue
            frame = temp
        }
    }

    /// 控件底部(maxY)
    var bottom: CGFloat {
        get { return frame.maxY }
        set {
            var temp = frame
            temp.origin.y = newValue - frame.size.height
            frame = temp
        }
    }

    /// 控件左边(minX)
    var left: CGFloat {
        get { return frame.minX }
        set {
            var temp = frame
            temp.origin.x = newValue
            frame = temp
        }
    }

    /// 控件右边(maxX)
    var right: CGFloat {
        get { return frame.maxX }
        set {
            var temp = frame
            temp.origin.x = newValue - frame.size.width
            frame = temp
        }
    }

    /// 控件X(minX)
    var x: CGFloat {
        get { return frame.minX }
        set {
            var temp = frame
            temp.origin.x = newValue
            frame = temp
        }
    }

    /// 控件Y(minY)
    var y: CGFloat {
        get { return frame.minY }
        set {
            var temp = frame
            temp.origin.y = newValue
            frame = temp
        }
    }

    /// 控件的宽度
    var width: CGFloat {
        get { return frame.width }
        set {
            var temp: CGRect = frame
            temp.size.width = newValue
            frame = temp
        }
    }

    /// 控件的高度
    var height: CGFloat {
        get { return frame.height }
        set {
            var temp: CGRect = frame
            temp.size.height = newValue
            frame = temp
        }
    }

    /// 控件中心点X
    var centerX: CGFloat {
        get { return center.x }
        set {
            var temp: CGPoint = center
            temp.x = newValue
            center = temp
        }
    }

    /// 控件中心点Y
    var centerY: CGFloat {
        get { return center.y }
        set {
            var temp: CGPoint = center
            temp.y = newValue
            center = temp
        }
    }

    /// 以bounds为基准的中心点
    var midpoint: CGPoint {
        get {
            return CGPoint(x: width / 2, y: height / 2)
        }
        set {
            origin = CGPoint(
                x: newValue.x - width / 2,
                y: newValue.y - height / 2
            )
        }
    }

    /// 控件的尺寸
    var size: CGSize {
        get { return frame.size }
        set {
            var temp: CGRect = frame
            temp.size = newValue
            frame = temp
        }
    }

    /// 控件的origin
    var origin: CGPoint {
        get { return frame.origin }
        set {
            var temp: CGRect = frame
            temp.origin = newValue
            frame = temp
        }
    }

    /// 控件位置/尺寸相关信息
    var rect: CGRect! {
        get {
            return frame
        }
        set {
            frame = newValue
        }
    }
}

// MARK: - 方法
public extension UIView {
    /// view所在控制器
    var controller: UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil

        return nil
    }

    /// 位置是否是视图内部
    /// - Parameter point:位置点
    /// - Returns:是否是视图内点击
    func containView(_ point: CGPoint) -> Bool {
        return point.x > frame.minX && point.x < frame.maxX && point.y > frame.minY && point.y < frame.maxY
    }

    /// 是否包含WKWebView
    /// - Returns:结果
    func containsWKWebView() -> Bool {
        if isKind(of: WKWebView.self) {
            return true
        }
        for subView in subviews {
            if subView.containsWKWebView() {
                return true
            }
        }
        return false
    }

    /// 递归查找第一响应者
    func firstResponder() -> UIView? {
        var views = [UIView](arrayLiteral: self)
        var index = 0
        repeat {
            let view = views[index]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            index += 1
        } while index < views.count
        return nil
    }

    /// 搜索所有父视图,直到找到具有此类的视图
    /// - Parameter name:要搜索的视图的类
    func ancestorView<T: UIView>(withClass name: T.Type) -> T? {
        return ancestorView(where: { $0 is T }) as? T
    }

    /// 搜索所有父视图,直到找到具有该条件的视图
    /// - Parameter predicate:对SuperView求值的谓词
    func ancestorView(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(superview) {
            return superview
        }
        return superview?.ancestorView(where: predicate)
    }

    /// 搜索子级视图查找指定类型
    /// - Returns:结果
    func descendantsView<T: UIView>(_ type: T.Type) -> T? {
        if let sub = self as? T {
            return sub
        }

        for subView in subviews {
            if let targetView = subView.descendantsView(type) {
                return targetView
            }
        }
        return nil
    }

    /// 寻找某个类型子视图
    /// - Parameters:
    ///   - type:子视图类型
    ///   - resursion:是否递归查找
    /// - Returns:返回找到的子视图
    func descendantsView(type: UIResponder.Type, resursion: Bool) -> UIView? {
        for e in subviews.enumerated() {
            if e.element.isKind(of: type) {
                return e.element
            }
        }
        // 是否递归查找
        guard resursion == true else {
            return nil
        }
        for e in subviews.enumerated() {
            let tmpView = e.element.descendantsView(type: type, resursion: resursion)
            if tmpView != nil {
                return tmpView
            }
        }
        return nil
    }

    /// 以递归方式返回给定类型的所有子视图
    /// 视图层次结构基于它所调用的视图
    /// - Parameter type:要搜索的视图的类
    /// - Returns:具有指定类型的所有子视图
    func descendantsViews<T>(of type: T.Type) -> [T] {
        var views = [T]()
        for subview in subviews {
            if let view = subview as? T {
                views.append(view)
            } else if !subview.subviews.isEmpty {
                views.append(contentsOf: subview.descendantsViews(of: T.self))
            }
        }
        return views
    }

    /// 添加子视图数组到self
    /// - Parameter subviews:子视图数组
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }

    /// 移除所有的子视图
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// 移除`layer`
    func removeLayer() {
        layer.mask = nil
        layer.borderWidth = 0
    }

    /// 隐藏键盘
    func hiddenKeyboard() {
        endEditing(true)
    }

    /// 强制更新布局(立即更新)
    func reloadLayout() {
        // 标记视图,runloop的下一个周期调用layoutSubviews
        setNeedsLayout()
        // 如果这个视图有被setNeedsLayout方法标记的, 会立即执行layoutSubviews方法
        layoutIfNeeded()
    }
}

// MARK: debug
public extension UIView {
    /// 图层调试>标记子视图边框(兼容OC)
    /// - Parameters:
    ///   - borderWidth:视图的边框宽度
    ///   - borderColor:视图的边框颜色
    ///   - backgroundColor:视图的背景色
    func stressView(
        _ borderWidth: CGFloat = 0.5,
        borderColor: UIColor = .random,
        backgroundColor: UIColor = .random
    ) {
        #if DEBUG
            let subviews = self.subviews
            if subviews.isEmpty {
                return
            }
            for subview in subviews {
                subview.layer.borderWidth = borderWidth
                subview.layer.borderColor = borderColor.cgColor
                subview.backgroundColor = backgroundColor
                subview.stressView(
                    borderWidth,
                    borderColor: borderColor,
                    backgroundColor: backgroundColor
                )
            }
        #endif
    }
}

// MARK: - Nib
public extension UIView {
    /// 从nib加载view
    /// - Parameters:
    ///   - name:nib名称
    ///   - bundle:nib的bundle(默认为nil)
    /// - Returns:从nib加载的view
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    /// 从nib加载特定类型的视图
    /// - Parameters:
    ///   - withClass:UIView类型
    ///   - bundle:nib所在bundle
    /// - Returns:UIView
    class func loadFromNib<T: UIView>(withClass name: T.Type, bundle: Bundle? = nil) -> T {
        let named = String(describing: name)
        guard let view = UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? T else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        return view
    }
}

// MARK: - 布局
public extension UIView {
    /// 将view的各个边锚定到它的superview(填充至父view)
    func fillToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }

    /// 将当前view任意一侧的定位添加到指定的定位中,并返回新添加的约束
    /// - Parameters:
    ///   - top:当前视图的顶部锚定将被锚定到指定的锚定中
    ///   - left:当前视图的左锚定将被锚定到指定的锚定中
    ///   - bottom:当前视图的底部锚定将被锚定到指定的锚定中
    ///   - right:当前视图的右锚定将被锚定到指定的锚定中
    ///   - topConstant:当前视图的顶部锚定边距
    ///   - leftConstant:当前视图的左锚定边距
    ///   - bottomConstant:当前视图的底部锚定边距
    ///   - rightConstant:当前视图的右定位边距
    ///   - widthConstant:当前视图的宽度
    ///   - heightConstant:当前视图的高度
    /// - Returns:新添加的约束数组(如果适用)
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }

        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }

        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }

        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }

        anchors.forEach { $0.isActive = true }

        return anchors
    }

    /// 将中心X固定到当前视图的superview中,并具有恒定的边距值
    /// - Parameter constant:锚定约束的常量(默认值为0)
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// 将中心Y固定到当前视图的superview中,并使用恒定的边距值
    /// - Parameter withConstant:锚定约束的常数(默认值为0)
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// 添加VFL格式约束
    /// - Parameters:
    ///   - withFormat:视觉格式语言
    ///   - views:从索引0开始访问的视图数组(例如:[v0],[v1],[v2]…)
    func addConstraints(withFormat: String, views: UIView...) {
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: withFormat,
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: viewsDictionary
        ))
    }

    /// 将中心X和Y锚定到当前视图的superview中
    func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }

    /// 搜索约束,直到找到给定视图的约束
    /// - Parameters:
    ///   - attribute:要查找的属性
    ///   - view:要查找的视图
    /// - Returns:匹配约束
    func findConstraint(attribute: NSLayoutConstraint.Attribute, for view: UIView) -> NSLayoutConstraint? {
        let constraint = constraints.first {
            ($0.firstAttribute == attribute && $0.firstItem as? UIView == view) ||
                ($0.secondAttribute == attribute && $0.secondItem as? UIView == view)
        }
        return constraint ?? superview?.findConstraint(attribute: attribute, for: view)
    }

    /// 这个视图的第一个宽度约束
    var widthConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .width, for: self)
    }

    /// 这个视图的第一个高度约束
    var heightConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .height, for: self)
    }

    /// 这个视图的第一个头部约束
    var leadingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .leading, for: self)
    }

    /// 这个视图的第一个尾随约束
    var trailingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .trailing, for: self)
    }

    /// 这个视图的第一个顶部约束
    var topConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .top, for: self)
    }

    /// 这个视图的第一个底部约束
    var bottomConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .bottom, for: self)
    }
}

// MARK: - 圆角、阴影、边框、虚线、水印、抖动
public extension UIView {
    /// 设置视图的部分或全部角半径
    /// ⚠️ frame 大小必须已确定
    /// - Parameters:
    ///   - corners:要更改的角数组(例如:[.bottomLeft、.topRight])
    ///   - radius:选定角的半径
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }

    /// 将阴影添加到view中
    ///
    /// - Note:此方法仅适用于不透明的背景色,或者如果视图设置了`shadowPath`
    ///   请参见参数`opacity`
    /// - Parameters:
    ///   - color:阴影颜色(默认值为#137992)
    ///   - radius:阴影半径(默认值为3)
    ///   - offset:阴影偏移(默认为.zero)
    ///   - opacity:阴影不透明度(默认值为0.5), 它还将受到`alpha` 和`backgroundColor`的影响
    func addShadow(
        ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    /// 添加阴影和圆角并存
    ///
    ///  ⚠️ frame 大小必须已确定
    /// - Parameter superview:父视图
    /// - Parameter conrners:具体哪个圆角
    /// - Parameter radius:圆角大小
    /// - Parameter shadowColor:阴影的颜色
    /// - Parameter shadowOffset:阴影的偏移度:CGSizeMake(X[正的右偏移,负的左偏移], Y[正的下偏移,负的上偏移])
    /// - Parameter shadowOpacity:阴影的透明度
    /// - Parameter shadowRadius:阴影半径,默认 3
    ///
    /// - Note:提示:如果在异步布局(如:SnapKit布局)中使用,要在布局后先调用 layoutIfNeeded,再使用该方法
    func addCornerAndShadow(
        superview: UIView,
        conrners: UIRectCorner,
        radius: CGFloat = 3,
        shadowColor: UIColor,
        shadowOffset: CGSize,
        shadowOpacity: Float,
        shadowRadius: CGFloat = 3
    ) {
        // 添加圆角
        roundCorners(conrners, radius: radius)

        // 设置阴影
        let subLayer = CALayer()
        let fixframe = frame
        subLayer.frame = fixframe
        subLayer.cornerRadius = shadowRadius
        subLayer.backgroundColor = shadowColor.cgColor
        subLayer.masksToBounds = false
        // shadowColor阴影颜色
        subLayer.shadowColor = shadowColor.cgColor
        // shadowOffset阴影偏移,x向右偏移3,y向下偏移2,默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOffset = shadowOffset
        // 阴影透明度,默认0
        subLayer.shadowOpacity = shadowOpacity
        // 阴影半径,默认3
        subLayer.shadowRadius = shadowRadius
        superview.layer.insertSublayer(subLayer, below: layer)
    }

    /// 添加边框
    /// - Parameters:
    ///   - width:边框宽度
    ///   - color:边框颜色
    func addBorder(
        borderWidth: CGFloat,
        borderColor: UIColor
    ) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

    /// 添加顶部的 边框
    /// - Parameters:
    ///   - borderWidth:边框宽度
    ///   - borderColor:边框颜色
    func addBorderTop(
        borderWidth: CGFloat,
        borderColor: UIColor
    ) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: borderWidth, color: borderColor)
    }

    /// 添加底部的 边框
    /// - Parameters:
    ///   - borderWidth:边框宽度
    ///   - borderColor:边框颜色
    func addBorderBottom(
        borderWidth: CGFloat,
        borderColor: UIColor
    ) {
        addBorderUtility(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth, color: borderColor)
    }

    /// 添加左边的 边框
    /// - Parameters:
    ///   - borderWidth:边框宽度
    ///   - borderColor:边框颜色
    func addBorderLeft(
        borderWidth: CGFloat,
        borderColor: UIColor
    ) {
        addBorderUtility(x: 0, y: 0, width: borderWidth, height: frame.height, color: borderColor)
    }

    /// 添加右边的 边框
    /// - Parameters:
    ///   - borderWidth:边框宽度
    ///   - borderColor:边框颜色
    func addBorderRight(
        borderWidth: CGFloat,
        borderColor: UIColor
    ) {
        addBorderUtility(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height, color: borderColor)
    }

    /// 绘制圆环
    /// - Parameters:
    ///   - fillColor:内环的颜色
    ///   - strokeColor:外环的颜色
    ///   - strokeWidth:外环的宽度
    func drawCircle(
        fillColor: UIColor,
        strokeColor: UIColor,
        strokeWidth: CGFloat
    ) {
        let ciecleRadius = bounds.width > bounds.height
            ? bounds.height
            : bounds.width
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: ciecleRadius, height: ciecleRadius), cornerRadius: ciecleRadius / 2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        layer.addSublayer(shapeLayer)
    }

    /// 绘制虚线
    /// - Parameters:
    ///   - strokeColor:虚线颜色
    ///   - lineLength:每段虚线的长度
    ///   - lineSpacing:每段虚线的间隔
    ///   - isHorizontal:是否水平方向
    func drawDashLine(
        strokeColor: UIColor,
        lineLength: Int = 4,
        lineSpacing: Int = 4,
        isHorizontal: Bool = true
    ) {
        // 线粗
        let lineWidth = isHorizontal ? bounds.height : bounds.width

        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor

        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        // 每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        // 起点
        let path = CGMutablePath()
        if isHorizontal {
            path.move(to: CGPoint(x: 0, y: lineWidth / 2))
            // 终点
            // 横向 y = lineWidth / 2
            path.addLine(to: CGPoint(x: bounds.width, y: lineWidth / 2))
        } else {
            path.move(to: CGPoint(x: lineWidth / 2, y: 0))
            // 终点
            // 纵向 Y = view 的height
            path.addLine(to: CGPoint(x: lineWidth / 2, y: bounds.height))
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }

    /// 添加内阴影
    /// - Parameters:
    ///   - shadowColor:阴影的颜色
    ///   - shadowOffset:阴影的偏移度:CGSizeMake(X[正的右偏移,负的左偏移], Y[正的下偏移,负的上偏移])
    ///   - shadowOpacity:阴影的透明度
    ///   - shadowRadius:阴影半径,默认 3
    ///   - insetBySize:内阴影偏移大小
    func addInnerShadowLayer(shadowColor: UIColor, shadowOffset: CGSize = CGSize(width: 0, height: 0), shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 3, insetBySize: CGSize = CGSize(width: -42, height: -42)) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.fillRule = .evenOdd
        let path = CGMutablePath()
        path.addRect(bounds.insetBy(dx: insetBySize.width, dy: insetBySize.height))

        // let someInnerPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:innerPathRadius).cgPath
        let someInnerPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowRadius).cgPath
        path.addPath(someInnerPath)
        path.closeSubpath()
        shadowLayer.path = path
        let maskLayer = CAShapeLayer()
        maskLayer.path = someInnerPath
        shadowLayer.mask = maskLayer
        layer.addSublayer(shadowLayer)
    }

    /// 添加水印
    /// - Parameters:
    ///   - markText:水印文字
    ///   - textColor:水印文字颜色
    ///   - font:水印文字大小
    func addWater(
        markText: String,
        textColor: UIColor = UIColor.black,
        font: UIFont = UIFont.systemFont(ofSize: 12)
    ) {
        let waterMark: NSString = markText.nsString
        let textSize: CGSize = waterMark.size(withAttributes: [NSAttributedString.Key.font: font])
        // 多少行
        let rowNum = NSInteger(bounds.height * 3.5 / 80)
        // 多少列:自己的宽度 / (每个水印的宽度+间隔)
        let colNum = NSInteger(bounds.width / markText.strSize(bounds.width, font: font).width)

        for i in 0 ..< rowNum {
            for j in 0 ..< colNum {
                let textLayer: CATextLayer = .init()
                // textLayer.backgroundColor = UIColor.randomColor().cgColor
                // 按当前屏幕分辨显示,否则会模糊
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = font
                textLayer.fontSize = font.pointSize
                textLayer.foregroundColor = textColor.cgColor
                textLayer.string = waterMark
                textLayer.frame = CGRect(x: CGFloat(j) * (textSize.width + 30), y: CGFloat(i) * 60, width: textSize.width, height: textSize.height)
                // 旋转文字
                textLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi * 0.2), 0, 0, 3)
                layer.addSublayer(textLayer)
            }
        }
    }

    /// 抖动view
    /// - Parameters:
    ///   - direction:抖动方向(水平或垂直)(默认为水平)
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - animationType:shake动画类型(默认为.easeOut)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func shake(
        direction: ShakeDirection = .horizontal,
        duration: TimeInterval = 1,
        animationType: ShakeAnimationType = .easeOut,
        completion: (() -> Void)? = nil
    ) {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
}

// MARK: - 私有(边框)
private extension UIView {
    /// 添加边框
    /// - Parameters:
    ///   - x:x坐标
    ///   - y:y坐标
    ///   - width:宽度
    ///   - height:高度
    ///   - color:颜色
    func addBorderUtility(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat,
        color: UIColor
    ) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
}

/*
 从m11到m44定义的含义如下:
 m11:x轴方向进行缩放
 m12:和m21一起决定z轴的旋转
 m13:和m31一起决定y轴的旋转
 m14:
 m21:和m12一起决定z轴的旋转
 m22:y轴方向进行缩放
 m23:和m32一起决定x轴的旋转
 m24:
 m31:和m13一起决定y轴的旋转
 m32:和m23一起决定x轴的旋转
 m33:z轴方向进行缩放
 m34:透视效果m34= -1/D,D越小,透视效果越明显,必须在有旋转效果的前提下,才会看到透视效果
 m41:x轴方向进行平移
 m42:y轴方向进行平移
 m43:z轴方向进行平移
 m44:初始为1
 */
// MARK: - 继承于`UIView`视图的平面、3D旋转以及缩放
public extension UIView {
    /// 平面旋转
    /// - Parameters:
    ///   - angle:旋转多少度
    ///   - isInverted:顺时针还是逆时针,默认是顺时针
    func setRotation(_ angle: CGFloat, isInverted: Bool = false) {
        transform = isInverted ? CGAffineTransform(rotationAngle: angle).inverted() : CGAffineTransform(rotationAngle: angle)
    }

    /// 沿X轴方向旋转多少度(3D旋转)
    /// - Parameter angle:旋转角度,angle参数是旋转的角度,为弧度制 0-2π
    func set3DRotationX(_ angle: CGFloat) {
        // 初始化3D变换,获取默认值
        // var transform = CATransform3DIdentity
        // 透视 1/ -D,D越小,透视效果越明显,必须在有旋转效果的前提下,才会看到透视效果
        // 当我们有垂直于z轴的旋转分量时,设置m34的值可以增加透视效果,也可以理解为景深效果
        // transform.m34 = 1.0 / -1000.0
        // 空间旋转,x,y,z决定了旋转围绕的中轴,取值为 (-1,1) 之间
        // transform = CATransform3DRotate(transform, angle, 1.0, 0.0, 0.0)
        // self.layer.transform = transform
        layer.transform = CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0)
    }

    /// 沿 Y 轴方向旋转多少度
    /// - Parameter angle:旋转角度,angle参数是旋转的角度,为弧度制 0-2π
    func set3DRotationY(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
        layer.transform = transform
    }

    /// 沿 Z 轴方向旋转多少度
    /// - Parameter angle:旋转角度,angle参数是旋转的角度,为弧度制 0-2π
    func set3DRotationZ(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 0.0, 1.0)
        layer.transform = transform
    }

    /// 沿 X、Y、Z 轴方向同时旋转多少度(3D旋转)
    /// - Parameters:
    ///   - xAngle:x 轴的角度,旋转的角度,为弧度制 0-2π
    ///   - yAngle:y 轴的角度,旋转的角度,为弧度制 0-2π
    ///   - zAngle:z 轴的角度,旋转的角度,为弧度制 0-2π
    func setRotation(xAngle: CGFloat, yAngle: CGFloat, zAngle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, xAngle, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, yAngle, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, zAngle, 0.0, 0.0, 1.0)
        layer.transform = transform
    }

    /// 设置 x,y 缩放
    /// - Parameters:
    ///   - x:x 放大的倍数
    ///   - y:y 放大的倍数
    func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        layer.transform = transform
    }
}

// MARK: - 过渡动画效果
public extension UIView {
    /// view淡入效果(从透明到不透明)
    /// - Parameters:
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /// view淡出效果(从不透明到透明)
    /// - Parameters:
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}

// MARK: - transform
public extension UIView {
    /// 按相对轴上的角度旋转视图
    /// - Parameters:
    ///   - angle:旋转视图的角度
    ///   - type:旋转角度的类型
    ///   - animated:设置为true以设置旋转动画(默认值为true)
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func rotate(
        byAngle angle: CGFloat,
        ofType type: AngleUnit,
        animated: Bool = false,
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () in
            self.transform = self.transform.rotated(by: angleWithType)
        }, completion: completion)
    }

    /// 将视图旋转到固定轴上的角度
    /// - Parameters:
    ///   - angle:旋转视图的角度
    ///   - type:旋转角度的类型
    ///   - animated:设置为true以设置旋转动画(默认值为false)
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func rotate(
        toAngle angle: CGFloat,
        ofType type: AngleUnit,
        animated: Bool = false,
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
        }, completion: completion)
    }

    /// 按偏移缩放视图
    /// - Parameters:
    ///   - offset:缩放偏移
    ///   - animated:设置为true以设置缩放动画(默认值为false)
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func scale(
        by offset: CGPoint,
        animated: Bool = false,
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }
}

// MARK: 手势
public extension UIView {
    /// 将手势识别器附加到视图.将手势识别器附加到视图定义所表示手势的范围,使其接收到该视图及其所有子视图的触碰(建立手势识别器与视图的强引用)
    /// - Parameter gestureRecognizers:要添加到视图中的手势识别器数组
    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            addGestureRecognizer(recognizer)
        }
    }

    /// 将手势识别器与接收视图分离.此方法除了将手势识别器从视图中分离外,还将释放它们
    /// - Parameter gestureRecognizers:要从视图中移除的手势识别器数组
    func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            removeGestureRecognizer(recognizer)
        }
    }

    /// 删除所有手势识别器
    func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }

    /// 通用事件处理回调
    /// - Parameter action:事件回调
    func addActionHandler(_ action: @escaping (UITapGestureRecognizer?, UIView, Int) -> Void) {
        if let sender = self as? UIButton {
            sender.addActionHandler({ button in
                action(nil, button, button.tag)
            }, for: .touchUpInside)
        } else if let sender = self as? UIControl {
            sender.addActionHandler({ control in
                action(nil, control, control.tag)
            }, for: .valueChanged)
        } else {
            _ = addTapGestureRecognizer { recognizer in
                if let recognizer = recognizer as? UITapGestureRecognizer {
                    action(recognizer, recognizer.view!, recognizer.view!.tag)
                }
            }
        }
    }

    /// 添加`UITapGestureRecognizer`(点击)
    /// - Parameter action:事件处理
    /// - Returns:`UITapGestureRecognizer`
    @discardableResult
    func addTapGestureRecognizer(_ action: @escaping Callbacks.GestureResult) -> UITapGestureRecognizer {
        let obj = UITapGestureRecognizer(target: nil, action: nil)
        // 轻点次数
        obj.numberOfTapsRequired = 1
        // 手指个数
        obj.numberOfTouchesRequired = 1
        addCommonGestureRecognizer(obj)

        obj.addActionHandler { recognizer in
            action(recognizer)
        }

        return obj
    }

    /// 添加`UILongPressGestureRecognizer`(长按)
    /// - Parameters:
    ///   - action:事件处理
    ///   - minimumPressDuration:最小长按时间
    /// - Returns:`UILongPressGestureRecognizer`
    @discardableResult
    func addLongPressGestureRecognizer(
        _ action: @escaping Callbacks.GestureResult,
        for minimumPressDuration: TimeInterval
    ) -> UILongPressGestureRecognizer {
        let obj = UILongPressGestureRecognizer(target: nil, action: nil)
        obj.minimumPressDuration = minimumPressDuration
        addCommonGestureRecognizer(obj)

        obj.addActionHandler { recognizer in
            action(recognizer)
        }
        return obj
    }

    /// 添加`UIPanGestureRecognizer`(拖拽)
    /// - Parameter action:事件处理
    /// - Returns:`UIPanGestureRecognizer`
    @discardableResult
    func addPanGestureRecognizer(_ action: @escaping Callbacks.GestureResult) -> UIPanGestureRecognizer {
        let obj = UIPanGestureRecognizer(target: nil, action: nil)
        obj.minimumNumberOfTouches = 1
        obj.maximumNumberOfTouches = 3
        addCommonGestureRecognizer(obj)

        obj.addActionHandler { recognizer in
            if let sender = recognizer as? UIPanGestureRecognizer, let senderView = sender.view {
                let translate: CGPoint = sender.translation(in: senderView.superview)
                senderView.center = CGPoint(x: senderView.center.x + translate.x, y: senderView.center.y + translate.y)
                sender.setTranslation(.zero, in: senderView.superview)
                action(recognizer)
            }
        }
        return obj
    }

    /// 添加`UIScreenEdgePanGestureRecognizer`(屏幕边缘拖拽)
    /// - Parameters:
    ///   - target:监听对象
    ///   - action:事件处理
    ///   - edgs:边缘
    /// - Returns:`UIScreenEdgePanGestureRecognizer`
    @discardableResult
    func addScreenEdgePanGestureRecognizer(
        _ target: Any?,
        action: Selector?,
        for edgs: UIRectEdge
    ) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: target, action: action)
        obj.edges = edgs
        addCommonGestureRecognizer(obj)
        return obj
    }

    /// 添加`UIScreenEdgePanGestureRecognizer`(屏幕边缘拖拽)
    /// - Parameters:
    ///   - action:事件
    ///   - edgs:边缘
    /// - Returns:`UIScreenEdgePanGestureRecognizer`
    @discardableResult
    func addScreenEdgePanGestureRecognizer(
        action: @escaping Callbacks.GestureResult,
        for edgs: UIRectEdge
    ) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        obj.edges = edgs
        addCommonGestureRecognizer(obj)
        obj.addActionHandler { recognizer in
            action(recognizer)
        }
        return obj
    }

    /// 添加`UISwipeGestureRecognizer`(轻扫)
    /// - Parameters:
    ///   - target:事件对象
    ///   - action:事件处理
    ///   - direction:轻扫方向
    /// - Returns:`UISwipeGestureRecognizer`
    @discardableResult
    func addSwipeGestureRecognizer(
        _ target: Any?,
        action: Selector?,
        for direction: UISwipeGestureRecognizer.Direction
    ) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: target, action: action)
        obj.direction = direction
        addCommonGestureRecognizer(obj)
        return obj
    }

    /// 添加`UISwipeGestureRecognizer`(轻扫)
    /// - Parameters:
    ///   - action:事件处理
    ///   - direction:轻扫方向
    /// - Returns:`UISwipeGestureRecognizer`
    func addSwipeGestureRecognizer(
        _ action: @escaping Callbacks.GestureResult,
        for direction: UISwipeGestureRecognizer.Direction
    ) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: nil, action: nil)
        obj.direction = direction
        addCommonGestureRecognizer(obj)
        obj.addActionHandler { recognizer in
            action(recognizer)
        }
        return obj
    }

    /// 添加`UIPinchGestureRecognizer`(捏合)
    /// - Parameter action:事件处理
    /// - Returns:`UIPinchGestureRecognizer`
    func addPinchGestureRecognizer(_ action: @escaping Callbacks.GestureResult) -> UIPinchGestureRecognizer {
        let obj = UIPinchGestureRecognizer(target: nil, action: nil)
        addCommonGestureRecognizer(obj)
        obj.addActionHandler { recognizer in
            if let sender = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: sender.view!.superview)
                sender.view!.center = location
                sender.view!.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1.0
                action(recognizer)
            }
        }
        return obj
    }

    /// 添加`UIRotationGestureRecognizer`(旋转)
    /// - Parameter action:事件处理
    /// - Returns:`UIRotationGestureRecognizer`
    @discardableResult
    func addRotationGestureRecognizer(action: @escaping Callbacks.GestureResult) -> UIRotationGestureRecognizer {
        let obj = UIRotationGestureRecognizer(target: nil, action: nil)
        addCommonGestureRecognizer(obj)
        obj.addActionHandler { recognizer in
            if let sender = recognizer as? UIRotationGestureRecognizer {
                sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
                sender.rotation = 0.0
                action(recognizer)
            }
        }
        return obj
    }

    /// 通用添加手势方法
    private func addCommonGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(gestureRecognizer)
    }
}

// MARK: - 颜色渐变
public extension UIView {
    /// 设置线性渐变边框
    /// - Parameters:
    ///   - size:大小
    ///   - direction:渐变方向
    ///   - locations:位置
    ///   - colors:颜色数组
    ///   - lineWidth:线框
    ///   - roundingCorners:圆角方向
    ///   - cornerRadii:圆角大小
    func setupLinearGradientBorder(
        _ size: CGSize,
        direction: SBGradientDirection = .horizontal,
        locations: [CGFloat] = [0, 1],
        colors: [UIColor],
        lineWidth: CGFloat = 1.0,
        roundingCorners: UIRectCorner = .allCorners,
        cornerRadii: CGFloat = 0
    ) {
        let gradientLayer = colors.linearGradientLayer(size, direction: direction, locations: locations)

        let maskLayer = CAShapeLayer()
        maskLayer.lineWidth = lineWidth
        maskLayer.path = UIBezierPath(
            roundedRect: gradientLayer.bounds,
            byRoundingCorners: roundingCorners,
            cornerRadii: CGSize(width: cornerRadii, height: cornerRadii)
        ).cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor

        gradientLayer.mask = maskLayer

        // 添加到图层
        layer.addSublayer(gradientLayer)
    }

    /// 添加线性渐变背景图层
    /// - Parameters:
    ///   - size:渐变大小
    ///   - direction:渐变方向
    ///   - locations:颜色位置
    ///   - colors:渐变的颜色数组
    func setupLinearGradientBackgroundLayer(
        _ size: CGSize,
        direction: SBGradientDirection = .horizontal,
        locations: [CGFloat] = [0, 1],
        colors: [UIColor]
    ) {
        let layer = CAGradientLayer(
            CGRect(origin: .zero, size: size),
            direction: direction,
            colors: colors,
            locations: locations
        )
        self.layer.insertSublayer(layer, at: 0)
    }

    /// 添加线性渐变背景颜色
    /// - Parameters:
    ///   - size:渐变大小
    ///   - direction:渐变方向
    ///   - locations:颜色位置
    ///   - colors:渐变的颜色数组
    func setupLinearGradientBackgroundColor(
        _ size: CGSize,
        direction: SBGradientDirection = .horizontal,
        locations: [CGFloat] = [0, 1],
        colors: [UIColor]
    ) {
        let color = colors.linearGradientColor(
            size,
            direction: direction,
            locations: locations
        )
        backgroundColor = color
    }

    /// 线性渐变动画
    /// - Parameters:
    ///   - size:渐变大小
    ///   - direction:渐变方向
    ///   - startColors:开始颜色数组
    ///   - endColors:结束颜色数组
    ///   - locations:渐变位置
    ///   - duration:动画时长
    func linearGradientColorAnimation(
        _ size: CGSize,
        direction: SBGradientDirection = .horizontal,
        startColors: [UIColor],
        endColors: [UIColor],
        locations: [CGFloat],
        duration: CFTimeInterval = 1.0
    ) {
        let rect = CGRect(origin: .zero, size: size)
        let gradientLayer = CAGradientLayer(
            rect,
            direction: direction,
            colors: startColors,
            locations: locations,
            type: .axial
        )
        layer.insertSublayer(gradientLayer, at: 0)

        // 执行动画
        startLinearGradientColorAnimation(
            gradientLayer,
            startColors: startColors,
            endColors: endColors,
            duration: duration
        )
    }

    ///  开始线性渐变动画
    /// - Parameters:
    ///   - gradientLayer:要执行动画的图层
    ///   - startColors:开始颜色数组
    ///   - endColors:结束颜色数组
    ///   - duration:动画时长
    private func startLinearGradientColorAnimation(
        _ gradientLayer: CAGradientLayer,
        startColors: [UIColor],
        endColors: [UIColor],
        duration: CFTimeInterval = 1.0
    ) {
        let startColorArr = startColors.map {
            $0.cgColor
        }
        let endColorArr = endColors.map {
            $0.cgColor
        }

        // 添加渐变动画
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        // colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = duration
        colorChangeAnimation.fromValue = startColorArr
        colorChangeAnimation.toValue = endColorArr
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        // 动画结束后保持最终的效果
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
}

// MARK: - 角标(徽章)
public extension UIView {
    /// 添加角标
    /// - Parameter number:角标数字(0表示移除角标, ""空字符串表示 小红点无数字)
    func setupBadge(_ number: String) {
        var badgeLabel: UILabel? = viewWithTag(6202) as? UILabel
        if number == "0" {
            removeBadege()
            return
        }

        if badgeLabel == nil {
            badgeLabel = UILabel.defaultLabel
                .text(number)
                .textColor("#FFFFFF")
                .backgroundColor("#EE0565")
                .font(.system(.regular, size: 10))
                .textAlignment(.center)
                .tag(6202)
                .addTo(self)
        }

        badgeLabel?.text((number.int ?? 0) > 99 ? "99+" : number)
        badgeLabel?.translatesAutoresizingMaskIntoConstraints = false
        if number.isEmpty {
            badgeLabel?.cornerRadius(2.5).masksToBounds(true)
            let widthCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .width,
                multiplier: 1,
                constant: 5
            )

            let heightCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: 5
            )

            let centerXCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: 0
            )

            let centerYCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: 0
            )
            addConstraints([widthCons, heightCons, centerXCons, centerYCons])
        } else {
            badgeLabel?.cornerRadius(8).masksToBounds(true)

            var textWidth = (badgeLabel?.textSize().width ?? 0) + 10
            textWidth = max(textWidth, 16)

            let widthCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .width,
                multiplier: 1,
                constant: textWidth
            )

            let heightCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: 16
            )

            let centerXCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: 0
            )

            let centerYCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: 0
            )
            addConstraints([widthCons, heightCons, centerXCons, centerYCons])
        }
    }

    /// 移除角标
    func removeBadege() {
        DispatchQueue.sb.mainAsync {
            let badge = self.viewWithTag(6202)
            badge?.removeFromSuperview()
        }
    }
}

// MARK: - 水波纹动画
public extension UIView {
    /// 开启水波纹动画(动画层数根据颜色数组变化)
    /// - Parameters:
    ///   - colors:颜色数组
    ///   - scale:缩放
    ///   - duration:动画时间
    final func startWaterWaveAnimation(colors: [UIColor], scale: CGFloat, duration: TimeInterval) {
        if superview?.viewWithTag(3257) != nil {
            return
        }

        let animationView = UIView(frame: frame)
        animationView.tag = 3257
        animationView.layer.cornerRadius = layer.cornerRadius
        superview?.insertSubview(animationView, belowSubview: self)

        let delay = Double(duration) / Double(colors.count)
        for (index, color) in colors.enumerated() {
            let delay = delay * Double(index)
            setupAnimationView(animationView: animationView, color: color, scale: scale, delay: delay, duration: duration)
        }
    }

    private func setupAnimationView(animationView: UIView, color: UIColor, scale: CGFloat, delay: CFTimeInterval, duration: TimeInterval) {
        let waveView = UIView(frame: animationView.bounds)
        waveView.backgroundColor = color
        waveView.layer.cornerRadius = animationView.layer.cornerRadius
        waveView.layer.masksToBounds = true
        animationView.addSubview(waveView)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = duration
            opacityAnimation.repeatCount = MAXFLOAT
            waveView.layer.add(opacityAnimation, forKey: "opacityAnimation")

            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = scale
            scaleAnimation.duration = duration
            scaleAnimation.repeatCount = MAXFLOAT
            waveView.layer.add(scaleAnimation, forKey: "scaleAnimation")
        }
    }

    /// 停止水波纹动画
    final func stopWaterWaveAnimation() {
        if let view = superview?.viewWithTag(3257) {
            view.removeFromSuperview()
        }
    }
}

/*
 两部分组成:粒子发射引擎 和 粒子单元
 1、粒子发射引擎(CAEmitterLayer):负责粒子发射效果的宏观属性,例如粒子的发生速度、粒子的存活时间、粒子的发射位置等等
 CAEmitterLayer的属性:
 - emitterCells:CAEmitterCell对象的数组,用于把粒子投放到layer上
 - birthRate:粒子产生速度,默认1个每秒
 - lifetime:粒子纯在时间,默认1秒
 - emitterPosition:发射器在xy平面的中心位置
 - emitterZPosition:发射器在z平面的位置
 - preservesDepth:是否开启三维效果
 - velocity:粒子运动速度
 - scale:粒子的缩放比例
 - spin:自旋转速度
 - seed:用于初始化随机数产生的种子
 - emitterSize:发射器的尺寸
 - emitterDepth:发射器的深度
 - emitterShape:发射器的形状
 - point:点的形状,粒子从一个点发出
 - line:线的形状,粒子从一条线发出
 - rectangle:矩形形状,粒子从一个矩形中发
 - cuboid:立方体形状,会影响Z平面的效果
 - circle:粒子发射器引擎为球圆形形状,粒子会在圆形范围发射
 - sphere:粒子发射器引擎为球形形状
 - emitterMode:发射器发射模式
 - points 从发射器中发出
 - outline 从发射器边缘发出
 - surface 从发射器表面发出
 - volume 从发射器中点发出
 - renderMode:发射器渲染模式
 - unordered:粒子无序出现,多个粒子单元发射器的粒子将混合
 - oldestFirst:生命久的粒子会被渲染在最上层
 - oldestLast:生命短的粒子会被渲染在最上层
 - backToFront:粒子的渲染按照Z轴进行上下排序
 - additive:粒子将被混合

 2、粒子单元(CAEmitterCell):用来设置具体单位粒子的属性,例如粒子的运动速度、粒子的形变与颜色等等
 CAEmitterCell的属性:
 - name:粒子的名字
 - color:粒子的颜色
 - enabled:粒子是否渲染
 - contents:渲染粒子,是个CGImageRef的对象,即粒子要展示的图片
 - contentsRect:渲染范围
 - birthRate:粒子产生速度
 - lifetime:生命周期
 - lifetimeRange:生命周期增减范围
 - velocity:粒子运动速度
 - velocityRange:速度范围
 - spin:粒子旋转速度
 - spinrange:粒子旋转速度范围
 - scale:缩放比例
 - scaleRange:缩放比例范围
 - scaleSpeed:缩放比例速度
 - alphaRange::一个粒子的颜色alpha能改变的范围
 - alphaSpeed::粒子透明度在生命周期内的改变速度
 - redRange:一个粒子的颜色red能改变的范围
 - redSpeed:粒子red在生命周期内的改变速度
 - blueRange:一个粒子的颜色blue能改变的范围
 - blueSpeed:粒子blue在生命周期内的改变速度
 - greenRange:一个粒子的颜色green能改变的范围
 - greenSpeed:粒子green在生命周期内的改变速度
 - xAcceleration:粒子x方向的加速度分量
 - yAcceleration:粒子y方向的加速度分量
 - zAcceleration:粒子z方向的加速度分量
 - emissionRange:粒子发射角度范围
 - emissionLongitude:粒子在x-y平面的发射角度
 - emissionLatitude:发射的z轴方向的发射角度
 */
// MARK: - 粒子发射器
public class CMEmitterStyle: NSObject {
    /************* 粒子发射器 ********************/
    /// 开启三维效果
    public var preservesDepth: Bool = true
    /// 设置发射器位置
    public var emitterPosition: CGPoint = .init(x: UIScreen.main.bounds.width / 2.0, y: UIScreen.main.bounds.height - 30)
    /// 发射器的形状,默认 球型
    public var emitterShape: CAEmitterLayerEmitterShape = .sphere

    /************* 粒子单元 ********************/
    /// 缩放比例
    public var cellScale: CGFloat = 0.7
    /// 缩放比例范围
    public var cellScaleRange: CGFloat = 0.3
    /// 粒子存活的时间(指:粒子从创建出来展示在界面上到从界面上消失释放的整个过程)
    public var cellEmitterLifetime: Float = 3
    /// 生命周期增减范围
    public var cellLifetimeRange: Float = 3
    /// 设置例子每秒弹出的个数
    public var cellEmitterBirthRate: Float = 10
    /// 粒子的颜色
    public var cellColor: UIColor = .white
    /// 粒子旋转速度
    public var cellSpin: CGFloat = .init(Double.pi / 2)
    /// 粒子旋转速度范围
    public var cellSpinRange: CGFloat = .init(Double.pi / 4)
    /// 粒子运动速度
    public var cellVelocity: CGFloat = 150
    /// 速度范围
    public var cellVelocityRange: CGFloat = 100
    /// 设置粒子的方向
    public var cellEmissionLongitude: CGFloat = .init(-Double.pi / 2)
    /// 粒子发射角度范围
    public var cellEmissionRange: CGFloat = .init(Double.pi / 5)

    /// 粒子是否只发射一次
    public var cellFireOnce: Bool = false
}

// MARK: - 粒子发射器
public extension UIView {
    /// 启动 粒子发射器
    /// - Parameters:
    ///   - emitterImageNames:粒子单元图片名
    ///   - style:发射器和粒子的样式
    @discardableResult
    func startEmitter(emitterImageNames: [String], style: CMEmitterStyle = CMEmitterStyle()) -> CAEmitterLayer {
        // 创建发射器
        let emitter = CAEmitterLayer()
        emitter.backgroundColor = UIColor.brown.cgColor
        // 设置发射器位置
        emitter.emitterPosition = style.emitterPosition
        // 是否开启三维效果
        emitter.preservesDepth = style.preservesDepth
        // 发射器的形状
        // 创建例子,并且设置例子相关的属性
        let cells = createEmitterCell(emitterImageNames: emitterImageNames, style: style)
        // 将粒子设置到发射器中
        emitter.emitterCells = cells
        // 将发射器的Layer添加到父Layer中
        layer.addSublayer(emitter)

        DispatchQueue.sb.after(1) {
            guard style.cellFireOnce else { return }
            emitter.birthRate = 0
            DispatchQueue.sb.after(1) {
                self.stopEmitter()
            }
        }
        return emitter
    }

    ///  停止 粒子发射器
    func stopEmitter() {
        _ = layer.sublayers?.filter {
            $0.isKind(of: CAEmitterLayer.self)
        }.map {
            $0.removeFromSuperlayer()
        }
    }

    /// 创建例子,并且设置例子相关的属性
    /// - Parameters:
    ///   - emitterImageNames:粒子单元图片名
    ///   - style:发射器和粒子的样式
    /// - Returns:粒子数组
    private func createEmitterCell(emitterImageNames: [String], style: CMEmitterStyle) -> [CAEmitterCell] {
        // 粒子单元数组
        var cells: [CAEmitterCell] = []
        for emitterImageName in emitterImageNames {
            // 创建粒子,并且设置例子相关的属性
            // 创建粒子 cell
            let cell = CAEmitterCell()
            // 设置粒子速度(velocity-velocityRange 到 velocity+velocityRange)
            // 15.0 +- 200
            // 初始速度
            cell.velocity = style.cellVelocity
            // 速度范围
            cell.velocityRange = style.cellVelocityRange
            // x 轴上的加速度
            // cell.xAcceleration = 5.0
            // y 轴上的加速度
            // cell.yAcceleration = 30.0
            // 创建粒子的大小
            cell.scale = style.cellScale
            cell.scaleRange = style.cellScaleRange
            // 设置粒子的方向
            cell.emissionLongitude = style.cellEmissionLongitude
            // 周围发射角度
            cell.emissionRange = style.cellEmissionRange
            // 设置粒子旋转
            // 粒子旋转速度
            cell.spin = style.cellSpin
            // 粒子旋转速度范围
            cell.spinRange = style.cellSpinRange
            // 设置粒子存活的时间
            cell.lifetime = style.cellEmitterLifetime
            // 生命周期增减范围
            cell.lifetimeRange = style.cellLifetimeRange
            // 设置粒子每秒弹出的个数
            cell.birthRate = style.cellEmitterBirthRate
            // 设置粒子展示的图片
            cell.contents = UIImage(named: emitterImageName)?.cgImage
            // 设置粒子的颜色
            cell.color = style.cellColor.cgColor
            // 粒子透明度能改变的范围
            // cell.alphaRange = 0.3
            // 粒子透明度在生命周期内的改变速度
            // cell.alphaSpeed = 1
            // 添加粒子单元到数组
            cells.append(cell)
        }
        return cells
    }
}

// MARK: - 链式语法
public extension UIView {
    /// 创建默认`UIView`
    static var defaultView: UIView {
        let view = UIView()
        return view
    }

    /// 设置 tag 值
    /// - Parameter tag:值
    /// - Returns:`Self`
    @discardableResult
    func tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }

    /// 设置圆角
    /// - Parameter cornerRadius:圆角
    /// - Returns:`Self`
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        layer.cornerRadius = cornerRadius
        return self
    }

    /// 设置是否`masktoToBounds`
    /// - Parameter masksToBounds:是否设置
    /// - Returns:`Self`
    @discardableResult
    func masksToBounds(_ masksToBounds: Bool) -> Self {
        layer.masksToBounds = masksToBounds
        return self
    }

    /// 设置裁剪
    /// - Parameter clipsToBounds:是否裁剪超出部分
    /// - Returns:`Self`
    @discardableResult
    func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }

    /// 内容填充模式
    /// - Parameter mode:模式
    /// - Returns:返回图片的模式
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }

    /// 设置背景色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }

    /// 设置十六进制颜色
    /// - Parameter hex:十六进制颜色
    /// - Returns:`Self`
    @discardableResult
    func backgroundColor(_ hex: String) -> Self {
        backgroundColor = UIColor(hex: hex)
        return self
    }

    /// 被添加到某个视图上
    /// - Parameter superView:父视图
    /// - Returns:`Self`
    @discardableResult
    func addTo(_ superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }

    /// 设置是否允许交互
    /// - Parameter isUserInteractionEnabled:是否支持触摸
    /// - Returns:`Self`
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    /// 设置是否隐藏
    /// - Parameter isHidden:是否隐藏
    /// - Returns:`Self`
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置透明度
    /// - Parameter alpha:透明度
    /// - Returns:`Self`
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    /// 设置`tintColor`
    /// - Parameter tintColor:tintColor description
    /// - Returns:`Self`
    @discardableResult
    func tintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }

    /// 设置边框颜色
    /// - Parameters:
    ///   - color:边框颜色
    /// - Returns:`Self`
    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        layer.borderColor = color.cgColor
        return self
    }

    /// 设置边框颜色
    /// - Parameters:
    ///   - hex:十六进制颜色值
    /// - Returns:`Self`
    @discardableResult
    func borderColor(_ hex: String) -> Self {
        layer.borderColor = UIColor(hex: hex).cgColor
        return self
    }

    /// 设置边框宽度
    /// - Parameters:
    ///   - width:边框宽度
    /// - Returns:`Self`
    @discardableResult
    func borderWidth(_ width: CGFloat = 0.5) -> Self {
        layer.borderWidth = width
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize:是否开启光栅化
    /// - Returns:`Self`
    @discardableResult
    func shouldRasterize(_ rasterize: Bool) -> Self {
        layer.shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale:光栅化比例
    /// - Returns:`Self`
    @discardableResult
    func rasterizationScale(_ scale: CGFloat) -> Self {
        layer.rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        layer.shadowColor(color)
        return self
    }

    /// 设置阴影颜色
    /// - Parameter hex:十六进制颜色值
    /// - Returns:`Self`
    @discardableResult
    func shadowColor(_ hex: String) -> Self {
        layer.shadowColor(UIColor(hex: hex))
        return self
    }

    /// 设置阴影偏移
    /// - Parameter offset:偏移
    /// - Returns:`Self`
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        layer.shadowOffset = offset
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius:圆角
    /// - Returns:`Self`
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        layer.shadowRadius = radius
        return self
    }

    /// 设置不透明度
    /// - Parameter opacity:不透明度
    /// - Returns:`Self`
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        layer.shadowOpacity = opacity
        return self
    }

    /// 设置阴影路径
    /// - Parameter path:路径
    /// - Returns:`Self`
    @discardableResult
    func shadowPath(_ path: CGPath) -> Self {
        layer.shadowPath = path
        return self
    }

    /// 添加点击事件
    /// - Parameters:
    ///   - target:监听对象
    ///   - selector:方法
    /// - Returns:`Self`
    @discardableResult
    func addTapAction(_ target: Any, _ selector: Selector) -> Self {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
        return self
    }

    /// 离屏渲染 + 栅格化 - 异步绘制之后,会生成一张独立的图像,停止滚动之后,可以监听
    @discardableResult
    func rasterize() -> Self {
        layer.drawsAsynchronously = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        return self
    }
}

// MARK: - 链式语法(frame相关设置)
public extension UIView {
    /// 设置 frame
    /// - Parameter frame:frame
    /// - Returns:`Self`
    @discardableResult
    func rect(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    /// 设置 frame
    /// - Parameter frame:frame
    /// - Returns:`Self`
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    /// 控件的origin
    /// - Parameters:
    ///   - origin:坐标
    /// - Returns:`Self`
    @discardableResult
    func origin(_ origin: CGPoint) -> Self {
        var temp: CGRect = frame
        temp.origin = origin
        frame = temp
        return self
    }

    /// 控件的尺寸
    /// - Parameters:
    ///   - size:尺寸
    /// - Returns:`Self`
    @discardableResult
    func size(_ size: CGSize) -> Self {
        var temp: CGRect = frame
        temp.size = size
        frame = temp
        return self
    }

    /// 控件左边(`minX`)
    /// - Parameters:
    ///   - x:左侧距离
    /// - Returns:`Self`
    @discardableResult
    func x(_ x: CGFloat) -> Self {
        var temp = frame
        temp.origin.x = x
        frame = temp
        return self
    }

    /// 控件顶部(`minY`)
    /// - Parameters:
    ///   - y:顶部距离
    /// - Returns:`Self`
    @discardableResult
    func y(_ y: CGFloat) -> Self {
        var temp = frame
        temp.origin.y = y
        frame = temp
        return self
    }

    /// 控件的宽度
    /// - Parameters:
    ///   - width:宽度
    /// - Returns:`Self`
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        var temp: CGRect = frame
        temp.size.width = width
        frame = temp
        return self
    }

    /// 控件的高度
    /// - Parameters:
    ///   - width:宽度
    /// - Returns:`Self`
    @discardableResult
    func height(_ height: CGFloat) -> Self {
        var temp: CGRect = frame
        temp.size.height = height
        frame = temp
        return self
    }

    /// 控件顶部(`minY`)
    /// - Parameters:
    ///   - top:顶部距离
    /// - Returns:`Self`
    @discardableResult
    func top(_ top: CGFloat) -> Self {
        var temp = frame
        temp.origin.y = top
        frame = temp
        return self
    }

    /// 控件底部(`maxY`)
    /// - Parameters:
    ///   - bottom:底部距离
    /// - Returns:`Self`
    @discardableResult
    func bottom(_ bottom: CGFloat) -> Self {
        var temp = frame
        temp.origin.y = bottom - frame.size.height
        frame = temp
        return self
    }

    /// 控件左边(`minX`)
    /// - Parameters:
    ///   - left:左侧距离
    /// - Returns:`Self`
    @discardableResult
    func left(_ left: CGFloat) -> Self {
        var temp = frame
        temp.origin.x = left
        frame = temp
        return self
    }

    /// 控件右边(`maxX`)
    /// - Parameters:
    ///   - right:右侧距离
    /// - Returns:`Self`
    @discardableResult
    func right(_ right: CGFloat) -> Self {
        var temp = frame
        temp.origin.x = right - frame.size.width
        frame = temp
        return self
    }

    /// 控件中心点
    /// - Parameters:
    ///   - center:中心位置
    /// - Returns:`Self`
    @discardableResult
    func center(_ center: CGPoint) -> Self {
        self.center = center
        return self
    }

    /// 控件中心点X
    /// - Parameters:
    ///   - centerX:中心位置X
    /// - Returns:`Self`
    @discardableResult
    func centerX(_ centerX: CGFloat) -> Self {
        var temp: CGPoint = center
        temp.x = centerX
        center = temp
        return self
    }

    /// 控件中心点Y
    /// - Parameters:
    ///   - centerY:中心位置Y
    /// - Returns:`Self`
    @discardableResult
    func centerY(_ centerY: CGFloat) -> Self {
        var temp: CGPoint = center
        temp.y = centerY
        center = temp
        return self
    }
}
