import Foundation

// MARK: - 属性
public extension Calendar {
    /// 当月天数
    var currentMonthDays: Int {
        let currentDate = Date()
        return numberOfDaysInMonth(for: currentDate)
    }
}

// MARK: - 方法
public extension Calendar {
    /// 返回指定`Date``当月`的`天数`
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     Calendar.current.numberOfDaysInMonth(for:date) -> 31
    /// - Parameter date:日期
    /// - Returns:当月的天数
    func numberOfDaysInMonth(for date: Date) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
}
