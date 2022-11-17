import UIKit

// MARK: - 构造方法
extension UILayoutPriority: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    /// 使用`浮点数`初始化`UILayoutPriority`
    /// - Parameter value: `浮点数`类型数据
    public init(floatLiteral value: Float) {
        self.init(rawValue: value)
    }

    /// 使用`整数`初始化`UILayoutPriority`
    /// - Parameter value: `整数`类型数据
    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }
}
