import UIKit

// MARK: - 属性
public extension SaberEx where Base: UIScrollView {
    /// 截取整个滚动视图的快照(截图)
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.contentSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = base.frame
        base.frame = CGRect(origin: base.frame.origin, size: base.contentSize)
        base.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        base.frame = previousFrame

        return image
    }

    /// 滚动视图的当前可见区域
    var visibleRect: CGRect {
        let contentWidth = base.contentSize.width - base.contentOffset.x
        let contentHeight = base.contentSize.height - base.contentOffset.y
        return CGRect(
            origin: base.contentOffset,
            size: CGSize(width: Swift.min(Swift.min(base.bounds.size.width, base.contentSize.width), contentWidth),
                         height: Swift.min(Swift.min(base.bounds.size.height, base.contentSize.height), contentHeight))
        )
    }
}

// MARK: - 方法
public extension SaberEx where Base: UIScrollView {
    /// 适配`UIScrollView`
    func adaption() {
        if #available(iOS 11.0, *) {
            // 取消滚动视图自动缩进
            self.base.contentInsetAdjustmentBehavior = .never
        }
    }

    /// 滚动至最顶部
    /// - Parameter animated:`true`以恒定速度过渡到新偏移的动画,`false`立即进行过渡
    func toTop(_ animated: Bool = true) {
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: -base.contentInset.top), animated: animated)
    }

    /// 滚动至最底部
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    func toBottom(_ animated: Bool = true) {
        base.setContentOffset(
            CGPoint(
                x: base.contentOffset.x,
                y: Swift.max(0, base.contentSize.height - base.bounds.height) + base.contentInset.bottom
            ),
            animated: animated
        )
    }

    /// 滚动至最左侧
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    func toLeft(_ animated: Bool = true) {
        base.setContentOffset(CGPoint(x: -base.contentInset.left, y: base.contentOffset.y), animated: animated)
    }

    /// 滚动至最右侧
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    func toRight(_ animated: Bool = true) {
        base.setContentOffset(
            CGPoint(
                x: Swift.max(0, base.contentSize.width - base.bounds.width) + base.contentInset.right,
                y: base.contentOffset.y
            ),
            animated: animated
        )
    }

    /// 在滚动视图中向上滚动一页
    /// 如果`isPaginEnabled`为`true`,则使用上一页位置
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    func scrollUp(_ animated: Bool = true) {
        let minY = -base.contentInset.top
        var y = Swift.max(minY, base.contentOffset.y - base.bounds.height)
        #if !os(tvOS)
            if base.isPagingEnabled, base.bounds.height != 0 {
                let page = Swift.max(0, ((y + base.contentInset.top) / base.bounds.height).rounded(.down))
                y = Swift.max(minY, page * base.bounds.height - base.contentInset.top)
            }
        #endif
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: y), animated: animated)
    }

    /// 在滚动视图中向下滚动一页
    /// 如果`isPaginEnabled`为`true`,则使用下一页位置
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    func scrollDown(_ animated: Bool = true) {
        let maxY = Swift.max(0, base.contentSize.height - base.bounds.height) + base.contentInset.bottom
        var y = Swift.min(maxY, base.contentOffset.y + base.bounds.height)
        #if !os(tvOS)
            if base.isPagingEnabled, base.bounds.height != 0 {
                let page = ((y + base.contentInset.top) / base.bounds.height).rounded(.down)
                y = Swift.min(maxY, page * base.bounds.height - base.contentInset.top)
            }
        #endif
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: y), animated: animated)
    }

    /// 在滚动视图中向左滚动一页
    /// 如果`isPaginEnabled`为`true`,则使用上一页位置
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    func scrollLeft(_ animated: Bool = true) {
        let minX = -base.contentInset.left
        var x = Swift.max(minX, base.contentOffset.x - base.bounds.width)
        #if !os(tvOS)
            if base.isPagingEnabled, base.bounds.width != 0 {
                let page = ((x + base.contentInset.left) / base.bounds.width).rounded(.down)
                x = Swift.max(minX, page * base.bounds.width - base.contentInset.left)
            }
        #endif
        base.setContentOffset(CGPoint(x: x, y: base.contentOffset.y), animated: animated)
    }

    /// 在滚动视图中向右滚动一页
    /// 如果`isPaginEnabled`为`true`,则使用下一页位置
    /// - Parameter animated:`true`以恒定速度设置过渡到新偏移的动画,`false`立即进行过渡
    func scrollRight(_ animated: Bool = true) {
        let maxX = Swift.max(0, base.contentSize.width - base.bounds.width) + base.contentInset.right
        var x = Swift.min(maxX, base.contentOffset.x + base.bounds.width)
        #if !os(tvOS)
            if base.isPagingEnabled, base.bounds.width != 0 {
                let page = ((x + base.contentInset.left) / base.bounds.width).rounded(.down)
                x = Swift.min(maxX, page * base.bounds.width - base.contentInset.left)
            }
        #endif
        base.setContentOffset(CGPoint(x: x, y: base.contentOffset.y), animated: animated)
    }

    /// 获取`ScrollView`快照`截图`
    /// - Parameter completion:完成回调
    func screenshot(_ completion: @escaping (_ image: UIImage?) -> Void) {
        // 放一个假的封面
        let snapshotView = base.snapshotView(afterScreenUpdates: true)
        snapshotView?.frame = CGRect(x: base.frame.minX, y: base.frame.minY, width: (snapshotView?.frame.width)!, height: (snapshotView?.frame.height)!)
        base.superview?.addSubview(snapshotView!)

        // 基的原点偏移
        let originOffset = base.contentOffset
        // 计算页数
        let page = floorf(Float(base.contentSize.height / base.bounds.height))
        // 打开位图上下文大小为截图的大小
        UIGraphicsBeginImageContextWithOptions(base.contentSize, false, UIScreen.main.scale)

        // 这个方法是一个绘图,里面可能有递归调用
        screenshot(index: 0, maxIndex: page.sb.toInt()) {
            let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // 设置原点偏移
            self.base.setContentOffset(originOffset, animated: false)
            // 移除封面
            snapshotView?.removeFromSuperview()
            // 获取 snapShotContentScroll 时的回调图像
            completion(screenShotImage)
        }
    }
}

// MARK: - 私有方法
private extension SaberEx where Base: UIScrollView {
    /// 根据偏移量和页数绘制
    /// - Parameters:
    ///   - index:当前要绘制的页码索引
    ///   - maxIndex:最大页码索引
    ///   - callback:完成回调
    func screenshot(index: Int, maxIndex: Int, callback: @escaping () -> Void) {
        base.setContentOffset(
            CGPoint(
                x: 0,
                y: index.sb.toCGFloat() * base.frame.size.height
            ),
            animated: false
        )
        let splitFrame = CGRect(
            x: 0,
            y: index.sb.toCGFloat() * base.frame.size.height,
            width: base.bounds.width,
            height: base.bounds.height
        )

        DispatchQueue.sb.delay_main_task(0.3) {
            self.base.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            if index < maxIndex {
                self.screenshot(index: index + 1, maxIndex: maxIndex, callback: callback)
            } else {
                callback()
            }
        }
    }
}

// MARK: - 链式语法
public extension UIScrollView {
    /// 创建默认`UIScrollView`
    static var defaultScrollView: UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }

    /// 设置偏移量
    /// - Parameter offset:偏移量
    /// - Returns:`Self`
    @discardableResult
    func contentOffset(_ offset: CGPoint) -> Self {
        contentOffset = offset
        return self
    }

    /// 设置偏移量 `x:CGFloat, y:CGFloat`
    /// - Parameters:
    ///   - x:x 偏移量
    ///   - y:y 偏移量
    /// - Returns:`Self`
    @discardableResult
    func contentOffset(x: CGFloat, y: CGFloat) -> Self {
        contentOffset = CGPoint(x: x, y: y)
        return self
    }

    /// 设置滑动区域大小`CGSize`
    /// - Parameter size:滑动区域大小
    /// - Returns:`Self`
    @discardableResult
    func contentSize(_ size: CGSize) -> Self {
        contentSize = size
        return self
    }

    /// 设置滑动区域大小`(width:CGFloat, height:CGFloat),默认是CGSize.Zero`
    /// - Parameters:
    ///   - width:`width`代表`X`方向滑动区域大小
    ///   - height:`height`代表`Y`向滑动区域大小
    /// - Returns:`Self`
    @discardableResult
    func contentSize(width: CGFloat, height: CGFloat) -> Self {
        contentSize = CGSize(width: width, height: height)
        return self
    }

    /// 设置偏移量
    /// - Parameters:
    ///   - horizontal:水平方向的偏移量
    ///   - vertical:垂直方向的偏移量
    ///   - animated:是否有动画
    /// - Returns:`Self`
    @discardableResult
    func setContentOffset(_ horizontal: CGFloat, _ vertical: CGFloat, animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: horizontal, y: vertical), animated: animated)
        return self
    }

    /// 设置 水平方向(x) 偏移量
    /// - Parameters:
    ///   - horizontal:水平方向(x) 偏移量
    ///   - animated:是否有动画
    /// - Returns:`Self`
    @discardableResult
    func setContentOffsetX(_ horizontal: CGFloat, animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: horizontal, y: contentOffset.y), animated: animated)
        return self
    }

    /// 设置 垂直方向(y) 偏移量
    /// - Parameters:
    ///   - vertical:垂直方向(y) 偏移量
    ///   - animated:是否有动画
    /// - Returns:`Self`
    @discardableResult
    func setContentOffsetY(_ vertical: CGFloat, animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: contentOffset.x, y: vertical), animated: animated)
        return self
    }

    /// 边缘插入内容以外的可滑动区域,默认是`UIEdgeInsetsZero`(提示:必须设置`contentSize`后才有效)
    /// - Parameters:
    ///   - top:   代表 顶部 可滑动区域
    ///   - left:  代表 左边 可滑动区域
    ///   - bottom:代表 底部 可滑动区域
    ///   - right: 代表 右边 可滑动区域
    /// - Returns:`Self`
    @discardableResult
    func contentInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    /// 设置边缘插入内容以外的可滑动区域(`UIEdgeInsets`),默认是`UIEdgeInsetsZero`(提示:必须设置`contentSize`后才有效)
    /// - Parameter inset:`UIEdgeInsets`
    /// - Returns:`Self`
    @discardableResult
    func contentInset(_ inset: UIEdgeInsets) -> Self {
        contentInset = inset
        return self
    }

    /// 设置代理
    /// - Parameter delegate:代理
    /// - Returns:`Self`
    @discardableResult
    func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    ///  设置弹性效果,默认是`true`, 如果设置成`false`,则当你滑动到边缘时将不具有弹性效果
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func bounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }

    /// 竖直方向总是可以弹性滑动,默认是 `false`
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func alwaysBounceVertical(_ bounces: Bool) -> Self {
        alwaysBounceVertical = bounces
        return self
    }

    /// 水平方向 总是可以弹性滑动,默认是 `false`
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func alwaysBounceHorizontal(_ bounces: Bool) -> Self {
        alwaysBounceHorizontal = bounces
        return self
    }

    /// 设置是否可分页,默认是`false`, 如果设置成`true`, 则可分页
    /// - Parameter enabled:是否可分页
    /// - Returns:`Self`
    @discardableResult
    func isPagingEnabled(_ enabled: Bool) -> Self {
        isPagingEnabled = enabled
        return self
    }

    /// 是否显示 水平 方向滑动条,默认是`true`, 如果设置为`false`,当滑动的时候则不会显示水平滑动条
    /// - Parameter enabled:是否显示水平方向滑动条
    /// - Returns:`Self`
    @discardableResult
    func showsHorizontalScrollIndicator(_ enabled: Bool) -> Self {
        showsHorizontalScrollIndicator = enabled
        return self
    }

    /// 是否显示 垂直 方向滑动条,默认是`true`, 如果设置为`false`,当滑动的时候则不会显示水平滑动条
    /// - Parameter enabled:是否显示垂直方向滑动条
    /// - Returns:`Self`
    @discardableResult
    func showsVerticalScrollIndicator(_ enabled: Bool) -> Self {
        showsVerticalScrollIndicator = enabled
        return self
    }

    /// 设置滑动条的边缘插入,即是距离上、左、下、右的距离,比如:top(20) 当向下滑动时,滑动条距离顶部的距离总是 20
    /// - Parameter inset:`UIEdgeInset`
    /// - Returns:`Self`
    @discardableResult
    func scrollIndicatorInsets(_ inset: UIEdgeInsets) -> Self {
        scrollIndicatorInsets = inset
        return self
    }

    /// 是否可滑动,默认是true, 如果默认为`false`, 则无法滑动
    /// - Parameter enabled:是否可滑动
    /// - Returns:`Self`
    @discardableResult
    func isScrollEnabled(_ enabled: Bool) -> Self {
        isScrollEnabled = enabled
        return self
    }

    /// 设置滑动条颜色,默认是灰白色
    /// - Parameter indicatorStyle:滑动条颜色
    /// - Returns:`Self`
    @discardableResult
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        indicatorStyle = style
        return self
    }

    /// 设置减速率,`CGFloat`类型,当你滑动松开手指后的减速速率, 但是尽管`decelerationRate`是一个`CGFloat`类型,但是目前系统只支持以下两种速率设置选择:`fast` 和 `normal`
    /// - Parameter rate:减速率
    /// - Returns:`Self`
    @discardableResult
    func decelerationRate(_ rate: UIScrollView.DecelerationRate) -> Self {
        decelerationRate = rate
        return self
    }

    /// 锁住水平或竖直方向的滑动, 默认为`false`,如果设置为TRUE,那么在推拖拽`UIScrollView`的时候,会锁住水平或竖直方向的滑动
    /// - Parameter enabled:是否锁住
    /// - Returns:`Self`
    @discardableResult
    func isDirectionalLockEnabled(_ enabled: Bool) -> Self {
        isDirectionalLockEnabled = enabled
        return self
    }
}
