import Foundation

// MARK: - 属性
public extension Bool {
    /// `Bool`转`Int`
    var int: Int {
        return self ? 1 : 0
    }

    /// `Bool`转`String`
    var string: String {
        return self ? "true" : "false"
    }
}
