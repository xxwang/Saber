import Foundation

extension Calendar: Saberable {}

// MARK: - 方法
public extension SaberExt where Base == Calendar {
    /// 指定`Date`月份的`天数`
    /// - Parameter date: 日期 (默认:`Date.nowDate`)
    /// - Returns: 当月天数
    func daysInMonth(for date: Date = .nowDate) -> Int {
        return base.range(of: .day, in: .month, for: date)!.count
    }
}
