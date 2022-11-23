import Foundation

// MARK: - 方法
public extension SaberEx where Base: SignedInteger {
    /// 取`绝对值`
    /// - Returns: `绝对值`结果
    func abs() -> Base {
        return Swift.abs(base)
    }
}
