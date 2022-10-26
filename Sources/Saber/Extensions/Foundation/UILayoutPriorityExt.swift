import UIKit

// MARK: - 构造方法
extension UILayoutPriority: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    /// 使用浮点数初始化`UILayoutPriority`
    ///
    ///     constraint.priority = 0.5
    ///
    /// - Parameter value:浮点数
    public init(floatLiteral value: Float) {
        self.init(rawValue: value)
    }

    /// 使用整数初始化`UILayoutPriority`
    ///
    ///     constraint.priority = 5
    ///
    /// - Parameter value:整数
    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }
}
