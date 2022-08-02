import Foundation

// MARK: - 属性
public extension Bool {
    /// Int
    var int: Int {
        return self ? 1 : 0
    }

    /// String
    var string: String {
        return self ? "true" : "false"
    }
}
