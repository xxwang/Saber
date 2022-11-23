import Foundation

// MARK: - 扩展.sb
public extension Comparable {
    var sb: SaberEx<Self> { SaberEx(self) }
    static var sb: SaberEx<Self>.Type { SaberEx<Self>.self }
}

// MARK: - 方法
public extension SaberEx where Base: Comparable {
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
        return Swift.max(range.lowerBound, Swift.min(base, range.upperBound))
    }
}
