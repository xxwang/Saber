import Foundation

// MARK: - 方法
public extension Range where Bound == String.Index {
    /// NSRange
    /// - Parameter string: 字符串
    /// - Returns: NSRange
    func nsRange(in string: String) -> NSRange {
        return NSRange(self, in: string)
    }
}
