import Foundation

public extension Comparable {
    var sb: SaberExt<Self> { SaberExt(self) }
}

// MARK: - 方法
public extension SaberExt where Base: Comparable {
    /// 判断数据是否在指定范围内
    /// - Parameter range: `x...y || x..<y`
    /// - Returns: 是否在范围内
    func isBetween(_ range: ClosedRange<Base>) -> Bool {
        return range ~= base
    }

    /// 限制数据在指定范围内
    /// - Parameter range: 值允许的范围
    /// - Returns: `>`返回`range.upperBound`, `<`返回`range.lowerBound`,`==`返回`self
    func clamped(to range: ClosedRange<Base>) -> Base {
        return max(range.lowerBound, min(base, range.upperBound))
    }
}
