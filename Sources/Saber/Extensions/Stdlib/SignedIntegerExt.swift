import Foundation

// MARK: - 属性
public extension SaberExt where Base: SignedInteger {
    /// 取绝对值
    var abs: Base {
        return Swift.abs(base)
    }
}
