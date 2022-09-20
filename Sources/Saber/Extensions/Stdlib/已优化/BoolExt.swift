import Foundation

// MARK: - 属性
public extension Bool {
    /// Bool转Int
    var int: Int {
        return self ? 1 : 0
    }

    /// Bool转字符串
    var string: String {
        return self ? "true" : "false"
    }
}
