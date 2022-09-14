import UIKit

public extension UIPageControl {
    /// 创建`UIPageControl`
    /// - Parameters:
    ///   - frame: 坐标及大小
    ///   - count: 总页数
    ///   - currentIndex: 当前页码
    ///   - currentColor: 当前选中的颜色
    ///   - otherColor: 没有被选中的颜色
    /// - Returns: `UIPageControl`
    static func create(
        _ frame: CGRect = .zero,
        count: Int,
        currentIndex: Int = 0,
        currentColor: UIColor = .black,
        otherColor: UIColor = .lightGray
    ) -> UIPageControl {
        let control = UIPageControl(frame: frame)
        control.currentPageIndicatorTintColor = currentColor
        control.pageIndicatorTintColor = otherColor
        control.isUserInteractionEnabled = true
        control.hidesForSinglePage = true
        control.currentPage = currentIndex
        control.numberOfPages = count
        return control
    }
}
