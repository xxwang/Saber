import UIKit

// MARK: - 属性
public extension UIEdgeInsets {
    /// 返回水平方向`edges`
    var horizontal: CGFloat {
        return left + right
    }

    /// 返回垂直方向`edges`
    var vertical: CGFloat {
        return top + bottom
    }
}

// MARK: - 构造方法
public extension UIEdgeInsets {
    /// 创建4个方向相等的`UIEdgeInsets`
    /// - Parameter inset:用于四个方向的值
    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    /// 创建一个水平方向与垂直方向平分的`UIEdgeInsets`
    /// - Parameters:
    ///   - horizontal:水平方向大小
    ///   - vertical:垂直方向大小
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical / 2, left: horizontal / 2, bottom: vertical / 2, right: horizontal / 2)
    }
}

// MARK: - 方法
public extension UIEdgeInsets {
    /// 基于当前值和顶部偏移创建`UIEdgeInsets`
    ///
    /// - Parameters:
    ///   - top:顶部偏移值
    /// - Returns:偏移之后的`UIEdgeInsets`
    func insetBy(top: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top + top, left: left, bottom: bottom, right: right)
    }

    /// 基于当前值和左侧偏移创建`UIEdgeInsets`
    ///
    /// - Parameters:
    ///   - left:左侧偏移值
    /// - Returns:偏移之后的`UIEdgeInsets`
    func insetBy(left: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: self.left + left, bottom: bottom, right: right)
    }

    /// 基于当前值和底部偏移创建`UIEdgeInsets`
    ///
    /// - Parameters:
    ///   - bottom:底部偏移值
    /// - Returns:偏移之后的`UIEdgeInsets`
    func insetBy(bottom: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: self.bottom + bottom, right: right)
    }

    /// 基于当前值和右侧偏移创建`UIEdgeInsets`
    ///
    /// - Parameters:
    ///   - right:右侧偏移值
    /// - Returns:偏移之后的`UIEdgeInsets`
    func insetBy(right: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: self.right + right)
    }

    /// 基于当前值和水平值等分并应用于右偏移和左偏移,创建`UIEdgeInsets`
    ///
    /// - Parameters:
    ///   - horizontal:要应用于左侧和右侧的偏移
    /// - Returns:偏移之后的`UIEdgeInsets`
    func insetBy(horizontal: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left + horizontal / 2, bottom: bottom, right: right + horizontal / 2)
    }

    /// 基于当前值和垂直值等分并应用于顶部和底部,创建`UIEdgeInsets`
    ///
    /// - Parameters:
    ///   - vertical:要应用于顶部和底部的偏移
    /// - Returns:偏移之后的`UIEdgeInsets`
    func insetBy(vertical: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top + vertical / 2, left: left, bottom: bottom + vertical / 2, right: right)
    }
}

// MARK: - 运算符
public extension UIEdgeInsets {
    /// 比较两个`UIEdgeInsets`是否相等
    /// - Returns:是否相等
    static func == (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Bool {
        return lhs.top == rhs.top &&
            lhs.left == rhs.left &&
            lhs.bottom == rhs.bottom &&
            lhs.right == rhs.right
    }

    /// 根据两个`UIEdgeInsets`的和来创建一个新的`UIEdgeInsets`
    ///
    /// - Parameters:
    ///   - lhs:左侧`UIEdgeInsets`
    ///   - rhs:右侧`UIEdgeInsets`
    /// - Returns:新的`UIEdgeInsets`
    static func + (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top,
                            left: lhs.left + rhs.left,
                            bottom: lhs.bottom + rhs.bottom,
                            right: lhs.right + rhs.right)
    }

    /// 把右侧的`UIEdgeInsets`添加到左侧的`UIEdgeInsets`
    ///
    /// - Parameters:
    ///   - lhs:左侧`UIEdgeInsets`
    ///   - rhs:右侧`UIEdgeInsets`
    static func += (_ lhs: inout UIEdgeInsets, _ rhs: UIEdgeInsets) {
        lhs.top += rhs.top
        lhs.left += rhs.left
        lhs.bottom += rhs.bottom
        lhs.right += rhs.right
    }
}
