import Foundation

// MARK: - 方法
public extension NSRange {
    /// `NSRange`转换成`Range`的方法
    /// - Parameter string:父字符串
    /// - Returns:`Range<String.Index>`
    func range(string: String) -> Range<String.Index>? {
        guard
            let from16 = string.utf16.index(string.utf16.startIndex, offsetBy: location, limitedBy: string.utf16.endIndex),
            let to16 = string.utf16.index(from16, offsetBy: length, limitedBy: string.utf16.endIndex),
            let from = String.Index(from16, within: string),
            let to = String.Index(to16, within: string)
        else { return nil }
        return from ..< to
    }
}
