import Foundation

// MARK: - 方法
public extension Calendar {
    /// 返回指定`Date`当月的天数
    ///
    ///        let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///        Calendar.current.numberOfDaysInMonth(for: date) -> 31
    /// - Parameters date: 计算月天数的日期形式
    /// - Returns: Date当月的天数
    func numberOfDaysInMonth(for date: Date) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
}
