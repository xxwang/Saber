import UIKit

public extension SaberEx where Base: UIPageControl {}

public extension UIPageControl {
    convenience init(frame: CGRect, count: Int, currentIndex: Int, currentColor: UIColor, otherColor: UIColor) {
        self.init(frame: frame)
        numberOfPages(count)
            .currentPage(currentIndex)
            .currentPageIndicatorTintColor(currentColor)
            .pageIndicatorTintColor(otherColor)
    }
}

public extension UIPageControl {
    /// 关联类型
    typealias Associatedtype = UIPageControl

    /// 创建默认`UIPageControl`
    @objc override class func `default`() -> Associatedtype {
        let pageControl = UIPageControl()
        return pageControl
    }
}

// MARK: - 链式语法
public extension UIPageControl {
    /// 设置当前选中指示器颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func currentPageIndicatorTintColor(_ color: UIColor) -> Self {
        currentPageIndicatorTintColor = color
        return self
    }

    /// 设置没有选中时的指示器颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func pageIndicatorTintColor(_ color: UIColor) -> Self {
        pageIndicatorTintColor = color
        return self
    }

    /// 只有一页的时候是否隐藏分页指示器
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func hidesForSinglePage(_ isHidden: Bool) -> Self {
        hidesForSinglePage = isHidden
        return self
    }

    /// 设置当前页码
    /// - Parameter current: 当前页码
    /// - Returns: `Self`
    @discardableResult
    func currentPage(_ current: Int) -> Self {
        currentPage = current
        return self
    }

    /// 设置总页数
    /// - Parameter count: 总页数
    /// - Returns: `Self`
    @discardableResult
    func numberOfPages(_ count: Int) -> Self {
        numberOfPages = count
        return self
    }
}
