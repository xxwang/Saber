import Foundation

extension Calendar: Saberable {}

// MARK: - 属性
public extension SaberExt where Base == Calendar {
    /// 当月天数
    var daysInMonth: Int {
        return self.daysInMonth(for: Date.nowDate)
    }
}

// MARK: - 方法
public extension SaberExt where Base == Calendar {
    /// 指定`Date``当月`的`天数`
    /// - Parameter date: 日期
    /// - Returns: 当月天数
    func daysInMonth(for date: Date) -> Int {
        return base.range(of: .day, in: .month, for: date)!.count
    }
}
