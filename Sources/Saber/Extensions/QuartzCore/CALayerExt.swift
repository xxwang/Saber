import QuartzCore
import UIKit

// MARK: - 属性
public extension CALayer {
    /// 图层转图片(需要图层已经有`size`)
    var image: UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 图层转颜色(`UIColor`)
    var uiColor: UIColor? {
        if let image = image {
            return UIColor(patternImage: image)
        }
        return nil
    }
}

// MARK: - CABasicAnimation动画
public extension CALayer {
    /// BasicAnimation 移动到指定`CGPoint`
    /// 实际为移动CALyer的`position`, `position`默认为图层的中心点位置
    /// - Parameters:
    ///   - endPoint:要移动到的`Point`
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationMovePoint(
        to endPoint: CGPoint,
        duration: TimeInterval,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseBasicAnimation(
            keyPath: "position",
            startValue: position,
            endValue: endPoint,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// BasicAnimation X值移动动画
    /// - Parameters:
    ///   - moveValue:移动到的X值
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationMoveX(
        moveValue: Any?,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseBasicAnimation(
            keyPath: "transform.translation.x",
            startValue: position,
            endValue: moveValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// BasicAnimation Y值移动动画
    /// - Parameters:
    ///   - moveValue:移动到的Y值
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationMoveY(
        moveValue: Any?,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseBasicAnimation(
            keyPath: "transform.translation.y",
            startValue: position,
            endValue: moveValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// BasicAnimation圆角动画
    /// - Parameters:
    ///   - cornerRadius:圆角大小
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationCornerRadius(
        cornerRadius: Any?,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseBasicAnimation(
            keyPath: "cornerRadius",
            startValue: position,
            endValue: cornerRadius,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// BasicAnimation缩放动画
    /// - Parameters:
    ///   - scaleValue:缩放值
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationScale(
        scaleValue: Any?,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = true,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseBasicAnimation(
            keyPath: "transform.scale",
            startValue: 1,
            endValue: scaleValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// BasicAnimation旋转动画
    /// - Parameters:
    ///   - rotation:旋转的角度
    ///   - duration:动画持续时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func animationRotation(
        rotation: Any?,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = true,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseBasicAnimation(
            keyPath: "transform.rotation",
            startValue: nil,
            endValue: rotation,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `CABasicAnimation`基础动画
    /// - Parameters:
    ///   - keyPath:动画的类型
    ///   - startValue:开始值
    ///   - endValue:结束值
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:重复动画次数
    ///   - removedOnCompletion:在动画完成后是否移除动画
    ///   - option:动画节奏控制
    func baseBasicAnimation(
        keyPath: String,
        startValue: Any?,
        endValue: Any?,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        let basicAnimation = CABasicAnimation()
        // 几秒后执行
        basicAnimation.beginTime = CACurrentMediaTime() + delay
        // 动画的类型
        basicAnimation.keyPath = keyPath
        // 起始的值
        if let weakStartValue = startValue {
            basicAnimation.fromValue = weakStartValue
        }
        // 结束的值
        basicAnimation.toValue = endValue
        // 重复的次数
        basicAnimation.repeatCount = repeatCount
        // 动画持续的时间
        basicAnimation.duration = duration
        // 动画完成之后是否移除动画
        basicAnimation.isRemovedOnCompletion = removedOnCompletion
        // 图层保持动画执行后的状态,前提是fillMode设置为kCAFillModeForwards
        basicAnimation.fillMode = .forwards
        // 运动的时间函数
        basicAnimation.timingFunction = CAMediaTimingFunction(name: option)

        // 添加动画到图层
        add(basicAnimation, forKey: nil)
    }
}

// MARK: - CAKeyframeAnimation动画
public extension CALayer {
    /// `position`动画(移动是以视图的`锚点`移动的, 默认是视图的`中心点`)
    /// - Parameters:
    ///   - values:位置数组(CGPoint)
    ///   - keyTimes:位置对应的时间点数组
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除动画
    ///   - option:动画选项
    func addKeyframeAnimationPosition(
        values: [Any],
        keyTimes: [NSNumber]?,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseKeyframeAnimation(
            keyPath: "position",
            values: values,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// 抖动动画(根据传入的弧度)
    /// - Parameters:
    ///   - values:弧度数组
    ///   - keyTimes:每帧的时间点
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除
    ///   - option:动画选项
    func addKeyframeAnimationRotation(
        values: [Any] = [
            -5.cgFloat.angle2radian(),
            5.cgFloat.angle2radian(),
            -5.cgFloat.angle2radian(),
        ],
        keyTimes: [NSNumber]?,
        duration: TimeInterval = 1.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        cc removedOnCompletion: Bool = true,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseKeyframeAnimation(
            keyPath: "transform.rotation",
            values: values,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `CGPath`移动动画
    /// - Parameters:
    ///   - path:动画路径
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:是否在动画完成后移除动画
    ///   - option:动画控制选项
    func addKeyframeAnimationPositionBezierPath(
        path: CGPath? = nil,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseKeyframeAnimation(
            keyPath: "position",
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: path,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `CAKeyframeAnimation`基础动画
    /// - Parameters:
    ///   - keyPath:动画的类型(旋转/缩放/移动/...)
    ///   - values:对应动画类型的值数组(每个时间点的值)
    ///   - keyTimes:对应值数组的时间数组
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复的次数
    ///   - path:动画路径
    ///   - removedOnCompletion:是否在动画完成之后移除动画
    ///   - option:动画节奏控制选项
    func baseKeyframeAnimation(
        keyPath: String,
        values: [Any]? = nil,
        keyTimes: [NSNumber]? = nil,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        path: CGPath? = nil,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        let keyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)
        // 动画持续时长
        keyframeAnimation.duration = duration
        // 动画开始时间
        keyframeAnimation.beginTime = CACurrentMediaTime() + delay
        // 在动画完成时是否移除动画
        keyframeAnimation.isRemovedOnCompletion = removedOnCompletion
        // 填充模式
        keyframeAnimation.fillMode = .forwards
        // 动画次数
        keyframeAnimation.repeatCount = repeatCount
        // 旋转模式
        keyframeAnimation.rotationMode = .rotateAuto
        // 运动的时间函数
        keyframeAnimation.timingFunction = CAMediaTimingFunction(name: option)

        // 每帧的值
        if let values = values {
            keyframeAnimation.values = values
        }

        // 每帧的时间点
        if let keyTimes = keyTimes {
            keyframeAnimation.keyTimes = keyTimes
        }

        // 动画路径
        if let path = path {
            keyframeAnimation.path = path
            // 计算模式
            keyframeAnimation.calculationMode = .cubicPaced
        }

        // 添加到图层上
        add(keyframeAnimation, forKey: nil)
    }
}

// MARK: - CATransition 动画
/*
 转场动画,
 比UIVIew转场动画具有更多的动画效果,
 原生默认Push视图的效果就是通过CATransition的kCATransitionPush类型来实现

 type:过渡动画的类型
 fade:渐变
 moveIn:覆盖
 push:推出
 reveal:揭开

 私有动画类型的值有:
 "cube"
 "suckEffect"
 "oglFlip"
 "rippleEffect"
 "pageCurl"
 "pageUnCurl"
 ...

 subtype:过渡动画的方向
 fromRight:从右边
 fromLeft:从左边
 fromTop:从顶部
 fromBottom:从底部
 */
public extension CALayer {
    /// 过渡动画
    /// - Parameters:
    ///   - type:过渡动画的类型
    ///   - subtype:过渡动画的方向
    ///   - duration:动画的时间
    ///   - delay:延时
    func addTransition(
        type: CATransitionType,
        subtype: CATransitionSubtype?,
        duration: CFTimeInterval = 2.0,
        delay: TimeInterval = 0
    ) {
        let transition = CATransition()
        // 执行时间
        transition.beginTime = CACurrentMediaTime() + delay
        // 过渡动画类型
        transition.type = type
        // 动画方向
        transition.subtype = subtype
        // 动画时长
        transition.duration = duration

        // 添加动画
        add(transition, forKey: nil)
    }
}

// MARK: - CASpringAnimation 弹簧动画
/*
 CASpringAnimation是 iOS9 新加入动画类型,是CABasicAnimation的子类,用于实现弹簧动画
 CASpringAnimation和UIView的SpringAnimation对比:
 1.CASpringAnimation 可以设置更多影响弹簧动画效果的属性,可以实现更复杂的弹簧动画效果,且可以和其他动画组合.
 2.UIView的SpringAnimation实际上就是通过CASpringAnimation来实现.
 */

public extension CALayer {
    /// `CASpringAnimation`Bounds 动画
    /// - Parameters:
    ///   - toValue:动画目标值(CGRect)
    ///   - delay:延时
    ///   - mass:质量(影响弹簧的惯性,质量越大,弹簧惯性越大,运动的幅度越大)
    ///   - stiffness:刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
    ///   - damping:阻尼系数(阻尼系数越大,弹簧的停止越快)
    ///   - initialVelocity:始速率(弹簧动画的初始速度大小,弹簧运动的初始方向与初始速率的正负一致,若初始速率为0,表示忽略该属性)
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除动画
    ///   - option:动画控制选项
    func addSpringAnimationBounds(
        toValue: Any?,
        delay: TimeInterval = 0,
        mass: CGFloat = 10.0,
        stiffness: CGFloat = 5000,
        damping: CGFloat = 100.0,
        initialVelocity: CGFloat = 5,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        baseSpringAnimation(
            path: "bounds",
            toValue: toValue,
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    /// `CASpringAnimation`动画
    /// - Parameters:
    ///   - path:动画类型
    ///   - toValue:动画目标值
    ///   - delay:延时
    ///   - mass:质量(影响弹簧的惯性,质量越大,弹簧惯性越大,运动的幅度越大)
    ///   - stiffness:刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
    ///   - damping:阻尼系数(阻尼系数越大,弹簧的停止越快)
    ///   - initialVelocity:始速率(弹簧动画的初始速度大小,弹簧运动的初始方向与初始速率的正负一致,若初始速率为0,表示忽略该属性)
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除动画
    ///   - option:动画控制选项
    func baseSpringAnimation(
        path: String?,
        toValue: Any? = nil,
        delay: TimeInterval = 0,
        mass: CGFloat = 10.0,
        stiffness: CGFloat = 5000,
        damping: CGFloat = 100.0,
        initialVelocity: CGFloat = 5,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        let springAnimation = CASpringAnimation(keyPath: path)
        // 动画执行时间
        springAnimation.beginTime = CACurrentMediaTime() + delay
        // 质量,影响图层运动时的弹簧惯性,质量越大,弹簧拉伸和压缩的幅度越大
        springAnimation.mass = mass
        // 刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
        springAnimation.stiffness = stiffness
        // 阻尼系数,阻止弹簧伸缩的系数,阻尼系数越大,停止越快
        springAnimation.damping = damping
        // 初始速率,动画视图的初始速度大小;速率为正数时,速度方向与运动方向一致,速率为负数时,速度方向与运动方向相反
        springAnimation.initialVelocity = initialVelocity
        // settlingDuration:结算时间(根据动画参数估算弹簧开始运动到停止的时间,动画设置的时间最好根据此时间来设置)
        springAnimation.duration = springAnimation.settlingDuration
        // 目标值
        springAnimation.toValue = toValue
        // 完成后是否移除动画
        springAnimation.isRemovedOnCompletion = removedOnCompletion
        // 填充模式
        springAnimation.fillMode = CAMediaTimingFillMode.forwards
        // 运动的时间函数
        springAnimation.timingFunction = CAMediaTimingFunction(name: option)

        // 添加动画到图层
        add(springAnimation, forKey: nil)
    }
}

// MARK: - CAAnimationGroup动画组
/*
 使用Group可以将多个动画合并一起加入到层中
 Group中所有动画并发执行
 可以方便地实现需要多种类型动画的场景
 */
public extension CALayer {
    /// `CAAnimationGroup`动画
    /// - Parameters:
    ///   - animations:要执行的`CAAnimation`动画数组
    ///   - duration:动画时长
    ///   - delay:延时
    ///   - repeatCount:动画重复次数
    ///   - removedOnCompletion:动画完成是否移除动画
    ///   - option:动画控制选项
    func baseAnimationGroup(
        animations: [CAAnimation]? = nil,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default
    ) {
        let animationGroup = CAAnimationGroup()
        // 几秒后执行
        animationGroup.beginTime = CACurrentMediaTime() + delay
        // 要执行的动画数组(CAAnimation)
        animationGroup.animations = animations
        // 动画时长
        animationGroup.duration = duration
        // 填充模式
        animationGroup.fillMode = .forwards
        // 动画完成是否移除动画
        animationGroup.isRemovedOnCompletion = removedOnCompletion
        // 运动的时间函数
        animationGroup.timingFunction = CAMediaTimingFunction(name: option)

        // 添加动画组到图层
        add(animationGroup, forKey: nil)
    }
}

// MARK: - 链式语法
public extension CALayer {
    /// 创建默认`CALayer`
    static var defaultLayer: CALayer {
        let layer = CALayer()
        return layer
    }

    /// 设置背景色
    /// - Parameter color:背景色
    /// - Returns:`Self`
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color.cgColor
        return self
    }

    /// 设置背景色 (十六进制字符串)
    /// - Parameter hex:背景色 (十六进制字符串)
    /// - Returns:`Self`
    @discardableResult
    func backgroundColor(_ hex: String) -> Self {
        backgroundColor = UIColor(hex: hex).cgColor
        return self
    }

    /// 设置frame
    /// - Parameter frame:frame
    /// - Returns:`Self`
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    /// 添加到父视图
    /// - Parameter superView:父视图(UIView)
    /// - Returns:`Self`
    @discardableResult
    func add(to superView: UIView) -> Self {
        superView.layer.addSublayer(self)
        return self
    }

    /// 添加到父视图(CALayer)
    /// - Parameter superLayer:父视图(CALayer)
    /// - Returns:`Self`
    @discardableResult
    func add(to superLayer: CALayer) -> Self {
        superLayer.addSublayer(self)
        return self
    }

    /// 是否隐藏
    /// - Parameter isHidden:是否隐藏
    /// - Returns:`Self`
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置边框宽度
    /// - Parameter width:边框宽度
    /// - Returns:`Self`
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        borderWidth = width
        return self
    }

    /// 设置边框颜色
    /// - Parameter color:边框颜色
    /// - Returns:`Self`
    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        borderColor = color.cgColor
        return self
    }

    /// 设置边框颜色(十六进制颜色值)
    /// - Parameter hex:边框颜色
    /// - Returns:`Self`
    @discardableResult
    func borderColor(_ hex: String) -> Self {
        borderColor = UIColor(hex: hex).cgColor
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize:是否开启光栅化
    /// - Returns:`Self`
    @discardableResult
    func shouldRasterize(_ rasterize: Bool) -> Self {
        shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale:光栅化比例
    /// - Returns:`Self`
    @discardableResult
    func rasterizationScale(_ scale: CGFloat) -> Self {
        rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color:阴影颜色
    /// - Returns:`Self`
    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        shadowColor = color.cgColor
        return self
    }

    /// 设置阴影颜色(十六进制颜色值)
    /// - Parameter hex:阴影颜色
    /// - Returns:`Self`
    @discardableResult
    func shadowColor(_ hex: String) -> Self {
        shadowColor = UIColor(hex: hex).cgColor
        return self
    }

    /// 设置阴影的透明度,取值范围:0~1
    /// - Parameter opacity:阴影的透明度
    /// - Returns:`Self`
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        shadowOpacity = opacity
        return self
    }

    /// 设置阴影的偏移量
    /// - Parameter offset:偏移量
    /// - Returns:`Self`
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        shadowOffset = offset
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius:圆角大小
    /// - Returns:`Self`
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        shadowRadius = radius
        return self
    }

    /// 高性能添加阴影 Shadow Path
    /// 提示:当用bounds设置path时,看起来的效果与只设置了shadowOpacity一样,但是添加了shadowPath后消除了离屏渲染问题
    /// - Parameter path:阴影Path
    /// - Returns:`Self`
    @discardableResult
    func shadowPath(_ path: CGPath) -> Self {
        shadowPath = path
        return self
    }

    /// 设置裁剪
    /// - Parameter masksToBounds:是否裁剪
    /// - Returns:`Self`
    @discardableResult
    func masksToBounds(_ masksToBounds: Bool = true) -> Self {
        self.masksToBounds = masksToBounds
        return self
    }

    /// 设置圆角
    /// - Parameter cornerRadius:圆角
    /// - Returns:`Self`
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }

    /// 设置圆角(可设置部分角)
    /// ⚠️ frame 大小必须已确定
    /// - Parameters:
    ///   - radius:圆角半径
    ///   - corners:需要实现为圆角的角,可传入多个[], 默认所有圆角
    /// - Returns:`Self`
    @discardableResult
    func corner(
        _ radius: CGFloat,
        corners: UIRectCorner = .allCorners
    ) -> Self {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        mask = maskLayer

        return self
    }
}
