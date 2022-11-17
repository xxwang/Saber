import Foundation

extension Range<String.Index>: Saberable {}

// MARK: - Range<String.Index>
public extension SaberExt where Base == Range<String.Index> {
    /// `Range<String.Index>`转`NSRange`
    /// - Parameter string:字符串
    /// - Returns:`NSRange`
    func toNSRange(in string: String) -> NSRange {
        return NSRange(base, in: string)
    }
}
