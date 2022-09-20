import Foundation

// MARK: - 方法
public extension Comparable {
    /// 判断数据是否在指定范围内
    /// - Parameter range: 范围 x...y || x..<y
    /// - Returns: 是否存在
    func isBetween(_ range: ClosedRange<Self>) -> Bool {
        return range ~= self
    }

    /// 限制数据在指定范围内
    /// - Parameter range: 限制值的范围
    /// - Returns: `>`返回`range.upperBound`, `<`返回`range.lowerBound`,`==`返回`self`
    func clamped(to range: ClosedRange<Self>) -> Self {
        return max(range.lowerBound, min(self, range.upperBound))
    }
}
