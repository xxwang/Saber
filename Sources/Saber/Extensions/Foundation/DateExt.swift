import Foundation


private let calendar = Calendar.current
private let dateFormatter = DateFormatter()


// MARK: - 时间戳的类型枚举
public enum CMTimestampType: Int {
    /// 秒
    case second
    /// 毫秒
    case millisecond
}

// MARK: - 时间条的显示格式枚举
public enum CMTimeBarType {
    case normal
    case second
    case minute
    case hour
}

// MARK: - 日期名称格式枚举
public enum CMDayNameStyle {
    /// 日期名称的 3 个字母日期缩写
    case threeLetters
    /// 日期名称的 1 个字母日期缩写
    case oneLetter
    /// 完整的天名称
    case full
}

// MARK: - 月份名称格式枚举
public enum CMMonthNameStyle {
    /// 3 个字母月份的月份名称缩写
    case threeLetters
    /// 月份名称的 1 个字母月份缩写
    case oneLetter
    /// 完整的月份名称
    case full
}

// MARK: - 属性
public extension Date {
    /// `Calendar`
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier)
    }

        /// 当前年属性哪个`年代`
        ///
        ///     Date().era -> 1
    var era: Int {
        return calendar.component(.era, from: self)
    }

    #if !os(Linux)
        /// 本年中的第几个`季度`
        ///
        ///     Date().quarter -> 3
        var quarter: Int {
            let month = Double(calendar.component(.month, from: self))
            let numberOfMonths = Double(calendar.monthSymbols.count)
            let numberOfMonthsInQuarter = numberOfMonths / 4
            return Int(ceil(month / numberOfMonthsInQuarter))
        }
    #endif

    /// 本年中的第几`周`
    ///
    ///     Date().weekOfYear -> 2
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }

    /// 一个月的第几`周`
    ///
    ///     Date().weekOfMonth -> 3
    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }
    
        /// 本`周`中的第几`天`
        ///
        ///     Date().weekday -> 5
    var weekday: Int {
        return calendar.component(.weekday, from: self)
    }


    /// 日期中的`年份`
    ///
    ///     Date().year -> 2017
    ///     var someDate = Date()
    ///     someDate.year = 2000
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }

    /// 日期中的`月份`
    ///
    ///     Date().month -> 1
    ///     var someDate = Date()
    ///     someDate.month = 10
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }

    /// 日期中的`天`
    ///
    ///     Date().day -> 12
    ///     var someDate = Date()
    ///     someDate.day = 1
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }

    
    /// 日期中的`小时`
    ///
    ///     Date().hour -> 17 // 5 pm
    ///     var someDate = Date()
    ///     someDate.hour = 13
    var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentHour = calendar.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }

    /// 日期中的`分钟`
    ///
    ///     Date().minute -> 39
    ///     var someDate = Date()
    ///     someDate.minute = 10
    var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }

    /// 秒
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15
    var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }

    /// 纳秒
    ///
    ///     Date().nanosecond -> 981379985
    ///
    ///     var someDate = Date()
    ///     someDate.nanosecond = 981379985
    var nanosecond: Int {
        get {
            return calendar.component(.nanosecond, from: self)
        }
        set {
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(newValue) else { return }

            let currentNanoseconds = calendar.component(.nanosecond, from: self)
            let nanosecondsToAdd = newValue - currentNanoseconds

            if let date = calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self) {
                self = date
            }
        }
    }

    /// 毫秒
    ///
    ///     Date().millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.millisecond = 68
    var millisecond: Int {
        get {
            return calendar.component(.nanosecond, from: self) / 1_000_000
        }
        set {
            let nanoSeconds = newValue * 1_000_000
            #if targetEnvironment(macCatalyst)
                // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(nanoSeconds) else { return }

            if let date = calendar.date(bySetting: .nanosecond, value: nanoSeconds, of: self) {
                self = date
            }
        }
    }

    /// 获取当前时间戳／ms ,从1970年起算
    var timestamp: Int {
        return Int(timeIntervalSince1970 * 1000)
    }

    /// Unix时间戳 / s
    ///
    ///          Date().unixTimestamp -> 1484233862.826291
    var unixTimestamp: Double {
        return timeIntervalSince1970
    }

    /// 格林尼治时间戳 /s
    var timestampGMT: Int {
        let offset = TimeZone.current.secondsFromGMT(for: self)
        return Int(timeIntervalSince1970) - offset
    }

    /// 获取当前时区日期
    var currentZoneDate: Date {
        // 当前日期(系统)
        let date = Date()
        // 当前时区(系统)
        let zone = NSTimeZone.system
        // 以秒为单位返回当前日期与系统格林尼治日期的差
        let time = zone.secondsFromGMT(for: date)
        // 然后把差的日期加上,就是当前系统准确的日期
        let dateNow = date.addingTimeInterval(TimeInterval(time))

        return dateNow
    }

    /// 从日期获取 星期(中文)
    var weekdayStringFromDate: String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self)
        return weekdays[theComponents.weekday! - 1]
    }

    /// 从日期获取 月(英文)
    var monthAsString: String {
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }

    /// 日期字符串
    var string: String {
        return format()
    }

    /// 检查日期是否在将来
    ///
    ///     Date(timeInterval: 100, since: Date()).isInFuture -> true
    var isInFuture: Bool {
        return self > Date()
    }

    /// 检查日期是否过去
    ///
    ///     Date(timeInterval: -100, since: Date()).isInPast -> true
    var isInPast: Bool {
        return self < Date()
    }

    /// 检查日期是否在今天之内
    ///
    ///     Date().isInToday -> true
    var isInToday: Bool {
        return calendar.isDateInToday(self)
    }

    /// 检查日期是否在昨天之内
    ///
    ///     Date().isInYesterday -> false
    var isInYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }

    /// 检查日期是否在明天之内
    ///
    ///     Date().isInTomorrow -> false
    var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(self)
    }

    /// 检查日期是否在周末期间
    var isInWeekend: Bool {
        return calendar.isDateInWeekend(self)
    }

    /// 检查日期是否在工作日期间
    var isWorkday: Bool {
        return !calendar.isDateInWeekend(self)
    }

    /// 检查日期是否在本周内
    var isInCurrentWeek: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 检查日期是否在当前月份内
    var isInCurrentMonth: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    /// 检查日期是否在当年之内
    var isInCurrentYear: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    /// 当前日期是不是润年
    var isLeapYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }

    /// 将日期格式化为ISO8601标准的格式(yyyy-MM-dd'T'HH: mm: ss.SSS)
    ///
    ///     Date().iso8601String -> "2017-01-12T14: 51: 29.574Z"
    var iso8601String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH: mm: ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }

    /// 距离最近的可以被五分钟整除的时间
    ///
    ///     var date = Date() // "5: 54 PM"
    ///     date.minute = 32 // "5: 32 PM"
    ///     date.nearestFiveMinutes // "5: 30 PM"
    ///
    ///     date.minute = 44 // "5: 44 PM"
    ///     date.nearestFiveMinutes // "5: 45 PM"
    var nearestFiveMinutes: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self
        )
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 距离最近的可以被十分钟整除的时间
    ///
    ///     var date = Date() // "5: 57 PM"
    ///     date.minute = 34 // "5: 34 PM"
    ///     date.nearestTenMinutes // "5: 30 PM"
    ///
    ///     date.minute = 48 // "5: 48 PM"
    ///     date.nearestTenMinutes // "5: 50 PM"
    var nearestTenMinutes: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self
        )
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 距离最近的可以被十五分钟(一刻钟)整除的时间
    ///
    ///     var date = Date() // "5: 57 PM"
    ///     date.minute = 34 // "5: 34 PM"
    ///     date.nearestQuarterHour // "5: 30 PM"
    ///
    ///     date.minute = 40 // "5: 40 PM"
    ///     date.nearestQuarterHour // "5: 45 PM"
    var nearestQuarterHour: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self
        )
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 距离最近的可以被三十分钟(半小时)整除的时间
    ///
    ///     var date = Date() // "6: 07 PM"
    ///     date.minute = 41 // "6: 41 PM"
    ///     date.nearestHalfHour // "6: 30 PM"
    ///
    ///     date.minute = 51 // "6: 51 PM"
    ///     date.nearestHalfHour // "7: 00 PM"
    var nearestHalfHour: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self
        )
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// 距离最近的可以被六十分钟(一小时)整除的时间
    ///
    ///     var date = Date() // "6: 17 PM"
    ///     date.nearestHour // "6: 00 PM"
    ///
    ///     date.minute = 36 // "6: 36 PM"
    ///     date.nearestHour // "7: 00 PM"
    var nearestHour: Date {
        let min = calendar.component(.minute, from: self)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: self))!

        if min < 30 {
            return date
        }
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    /// 昨天的日期
    ///
    ///     let date = Date() // "Oct 3, 2018, 10: 57: 11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10: 57: 11"
    var yesterday: Date {
        return calendar.date(byAdding: .day, value: -1, to: self) ?? Date()
    }

    /// 明天的日期
    ///
    ///     let date = Date() // "Oct 3, 2018, 10: 57: 11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10: 57: 11"
    var tomorrow: Date {
        return calendar.date(byAdding: .day, value: 1, to: self) ?? Date()
    }
}

// MARK: - 构造方法
public extension Date {
    /// 使用日历组件创建一个日期
    ///
    ///     let date = Date(year: 2010, month: 1, day: 12) // "Jan 12, 2010, 7: 45 PM"
    ///
    /// - Parameters:
    ///   - calendar: 日历(默认为当前)
    ///   - timeZone: 时区(默认为当前)
    ///   - era: 时代(默认为当前时代)
    ///   - year: 年份(默认为当前年份)
    ///   - month: 月份(默认为当前月份)
    ///   - day: 日(默认为今天)
    ///   - hour: 小时(默认为当前小时)
    ///   - minute: 分钟(默认为当前分钟)
    ///   - second: 秒(默认为当前秒)
    ///   - nanosecond: 纳秒(默认为当前纳秒)
    init?(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = NSTimeZone.default,
        era: Int? = Date().era,
        year: Int? = Date().year,
        month: Int? = Date().month,
        day: Int? = Date().day,
        hour: Int? = Date().hour,
        minute: Int? = Date().minute,
        second: Int? = Date().second,
        nanosecond: Int? = Date().nanosecond
    ) {
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.era = era
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond

        guard let date = calendar?.date(from: components) else { return nil }
        self = date
    }

    /// 根据ISO8601格式字符串创建日期对象
    ///
    ///     let date = Date(iso8601String: "2017-01-12T16: 48: 00.959Z") // "Jan 12, 2017, 7: 48 PM"
    ///
    /// - Parameter iso8601String: ISO8601格式字符串(yyyy-MM-dd'T'HH: mm: ss.SSSZ).
    init?(iso8601String: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH: mm: ss.SSSZ"
        guard let date = dateFormatter.date(from: iso8601String) else { return nil }
        self = date
    }

    /// 从 UNIX 时间戳创建新的日期对象
    ///
    ///     let date = Date(unixTimestamp: 1484239783.922743) // "Jan 12, 2017, 7: 49 PM"
    ///
    /// - Parameter unixTimestamp: UNIX 时间戳.
    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp)
    }

    /// 从 Int 字面量创建日期对象
    ///
    ///     let date = Date(integerLiteral: 2017_12_25) // "2017-12-25 00: 00: 00 +0000"
    /// - Parameter value: Int值, 例如 20171225或者2017_12_25 etc.
    init?(integerLiteral value: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        guard let date = formatter.date(from: String(value)) else { return nil }
        self = date
    }
}

// MARK: - 静态属性
public extension Date {
    /// 今天的日期
    static let todayDate: Date = .init()

    /// 昨天的日期
    static var yesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
    }

    /// 明天的日期
    static var tomorrowDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
    }

    /// 前天的日期
    static var theDayBeforYesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
    }

    /// 后天的日期
    static var theDayAfterYesterDayDate: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 2), to: Date())
    }

    /// 获取当前 秒级 时间戳 - 10 位
    static var secondStamp: String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }

    /// 获取当前 毫秒级 时间戳 - 13 位
    static var milliStamp: String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }

    /// 获取当前的时间`Date`
    static var nowDate: Date {
        return Date()
    }
}

// MARK: - 格式化
public extension Date {
    /// 返回指定时区格式字符串
    /// - Parameters:
    ///   - format: 时间格式
    ///   - isGMT: 是否是格林尼治时区
    /// - Returns: 转化后字符串
    func format(_ format: String = "yyyy-MM-dd HH: mm: ss", isGMT: Bool = false) -> String {
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = isGMT ? TimeZone(secondsFromGMT: 0) : TimeZone.autoupdatingCurrent // TimeZone.current
        return dateFormatter.string(from: self)
    }

    /// 日期字符串
    ///
    ///     Date().string(withFormat: "dd/MM/yyyy") -> "1/12/17"
    ///     Date().string(withFormat: "HH: mm") -> "23: 50"
    ///     Date().string(withFormat: "dd/MM/yyyy HH: mm") -> "1/12/17 23: 50"
    ///
    /// - Parameter format: 日期格式(默认 "dd/MM/yyyy").
    /// - Returns: 日期字符串
    func string(withFormat format: String = "dd/MM/yyyy HH: mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .current
        return dateFormatter.string(from: self)
    }

    /// 根据本地时区转换
    private static func getNowDateFromatAnDate(_ anyDate: Date?) -> Date? {
        // 设置源日期时区
        let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
        // 或GMT
        // 设置转换后的目标日期时区
        let destinationTimeZone = NSTimeZone.local as NSTimeZone
        // 得到源日期与世界标准时间的偏移量
        var sourceGMTOffset: Int?
        if let aDate = anyDate {
            sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: aDate)
        }
        // 目标日期与本地时区的偏移量
        var destinationGMTOffset: Int?
        if let aDate = anyDate {
            destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: aDate)
        }
        // 得到时间偏移量的差值
        let interval = TimeInterval((destinationGMTOffset ?? 0) - (sourceGMTOffset ?? 0))
        // 转为现在时间
        var destinationDateNow: Date?
        if let aDate = anyDate {
            destinationDateNow = Date(timeInterval: interval, since: aDate)
        }
        return destinationDateNow
    }

    /// 带格式的时间转 时间戳,支持返回 13位 和 10位的时间戳,时间字符串和时间格式必须保持一致
    /// - Parameters:
    ///   - timeString: 时间字符串,如: 2020-10-26 16: 52: 41
    ///   - formatter: 时间格式,如: yyyy-MM-dd HH: mm: ss
    ///   - timestampType: 返回的时间戳类型,默认是秒 10 为的时间戳字符串
    /// - Returns: 返回转化后的时间戳
    static func dateStringAsTimestamp(timesString: String, formatter: String, timestampType: CMTimestampType = .second) -> String {
        guard let date = dateFormatter.date(from: timesString) else {
            #if DEBUG
                fatalError("时间有问题")
            #else
                return ""
            #endif
        }
        if timestampType == .second {
            return "\(Int(date.timeIntervalSince1970))"
        }
        return "\(Int(date.timeIntervalSince1970 * 1000))"
    }

    /// 带格式的时间转 Date
    /// - Parameters:
    ///   - timesString: 时间字符串
    ///   - formatter: 格式
    /// - Returns: 返回 Date
    static func formatterTimeStringToDate(timesString: String, formatter: String) -> Date {
        guard let date = dateFormatter.date(from: timesString) else {
            #if DEBUG
                fatalError("时间有问题")
            #else
                return Date()
            #endif
        }
        return date
    }

    /// 秒转换成播放时间条的格式
    /// - Parameters:
    ///   - secounds: 秒数
    ///   - type: 格式类型
    /// - Returns: 返回时间条
    static func formatPlayTime(seconds: Int, type: CMTimeBarType = .normal) -> String {
        if seconds <= 0 {
            return "00: 00"
        }
        // 秒
        let second = seconds % 60
        if type == .second {
            return String(format: "%02d", seconds)
        }
        // 分钟
        var minute = Int(seconds / 60)
        if type == .minute {
            return String(format: "%02d: %02d", minute, second)
        }
        // 小时
        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }
        if type == .hour {
            return String(format: "%02d: %02d: %02d", hour, minute, second)
        }
        // normal 类型
        if hour > 0 {
            return String(format: "%02d: %02d: %02d", hour, minute, second)
        }
        if minute > 0 {
            return String(format: "%02d: %02d", minute, second)
        }
        return String(format: "%02d", second)
    }
}

// MARK: - 时间戳
public extension Date {
    /// 时间戳转换为日期字符串
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - format: 格式
    /// - Returns: 对应时间的字符串
    static func timestampAsDateString(timestamp: String, format: String = "yyyy-MM-dd HH: mm: ss") -> String {
        // 时间戳转为Date
        let date = timestampAsDate(timestamp: timestamp)
        // 设置 dateFormat
        dateFormatter.dateFormat = format
        // 按照dateFormat把Date转化为String
        return dateFormatter.string(from: date)
    }

    /// 时间戳转换为`Date`
    /// - Parameter timestamp: 时间戳
    /// - Returns: 返回 Date
    static func timestampAsDate(timestamp: String) -> Date {
        guard timestamp.count == 10 || timestamp.count == 13 else {
            #if DEBUG
                fatalError("时间戳位数不是 10 也不是 13")
            #else
                return Date()
            #endif
        }
        let timestampInt = timestamp.int ?? 0
        let timestampValue = timestamp.count == 10 ? timestampInt : timestampInt / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }

    /// `Date`转`时间戳`
    /// - Parameter timestampType: 返回的时间戳类型,默认是秒 10 为的时间戳字符串
    /// - Returns: 时间戳
    func dateAsTimestamp(timestampType: CMTimestampType = .second) -> String {
        // 10位数时间戳 和 13位数时间戳
        let interval = timestampType == .second ? CLongLong(Int(timeIntervalSince1970)) : CLongLong(round(timeIntervalSince1970 * 1000))
        return "\(interval)"
    }
}

// MARK: - 方法
public extension Date {
    /// 时间差描述
    var timeExplain: String {
        // 获取当前的时间戳
        let currentTimeStamp = Date().timeIntervalSince1970
        // 服务器时间戳(如果是毫秒 要除以1000)
        let serverTimeStamp = timeIntervalSince1970

        // 时间差
        let reduceTime: TimeInterval = Swift.abs(currentTimeStamp - serverTimeStamp)
        // 后缀
        let suffix = (currentTimeStamp - serverTimeStamp) > 0 ? "前" : "后"

        if reduceTime < 60 {
            return (currentTimeStamp - serverTimeStamp) > 0 ? "刚刚" : "马上"
        }

        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟\(suffix)"
        }

        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时\(suffix)"
        }

        let days = Int(reduceTime / 3600 / 24)
        if days < 30 {
            return "\(days)天\(suffix)"
        }

        let date = Date(timeIntervalSince1970: serverTimeStamp)
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy年MM月dd日 HH: mm: ss"
        return dfmatter.string(from: date)
    }

    /// 取得与当前时间的间隔差
    /// - Returns: 时间差
    func callTimeAfterNow() -> String {
        // 获取时间间隔
        let timeInterval = Date().timeIntervalSince(self)
        // 后缀
        let suffix = timeInterval > 0 ? "前" : "后"

        let interval = fabs(timeInterval) // 秒数
        let minute = interval / 60 // 分钟
        let hour = interval / 3600 // 小时
        let day = interval / 86400 // 天
        let month = interval / 2_592_000 // 月
        let year = interval / 31_104_000 // 年

        var time: String!
        if minute < 1 {
            time = interval > 0 ? "刚刚" : "马上"
        } else if hour < 1 {
            let s = NSNumber(value: minute as Double).intValue
            time = "\(s)分钟\(suffix)"
        } else if day < 1 {
            let s = NSNumber(value: hour as Double).intValue
            time = "\(s)小时\(suffix)"
        } else if month < 1 {
            let s = NSNumber(value: day as Double).intValue
            time = "\(s)天\(suffix)"
        } else if year < 1 {
            let s = NSNumber(value: month as Double).intValue
            time = "\(s)个月\(suffix)"
        } else {
            let s = NSNumber(value: year as Double).intValue
            time = "\(s)年\(suffix)"
        }
        return time
    }

    /// 转成当前时区的日期
    func dateFromGMT() -> Date {
        let secondFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return addingTimeInterval(secondFromGMT)
    }

    /// 是否为  同一年  同一月 同一天
    /// - Returns: bool
    func isSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }

    /// 日期的加减操作
    /// - Parameter day: 天数变化
    /// - Returns: date
    func adding(day: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: day), to: self)
    }

    /// - Parameter date: date
    /// - Returns: 返回bool
    func isSameYeaerMountDay(_ date: Date) -> Bool {
        let com = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let comToday = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return (com.day == comToday.day
            && com.month == comToday.month
            && com.year == comToday.year)
    }

    /// 获取两个日期之间的数据
    /// - Parameters:
    ///   - date: 对比的日期
    ///   - unit: 对比的类型
    /// - Returns: 两个日期之间的数据
    func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
        let calendar = Calendar.current
        let component = calendar.dateComponents(unit, from: date, to: self)
        return component
    }

    /// 获取两个日期之间的天数
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的天数
    func numberOfDays(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.day]).day
    }

    /// 获取两个日期之间的小时
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的小时
    func numberOfHours(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.hour]).hour
    }

    /// 获取两个日期之间的分钟
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的分钟
    func numberOfMinutes(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.minute]).minute
    }

    /// 获取两个日期之间的秒数
    /// - Parameter date: 对比的日期
    /// - Returns: 两个日期之间的秒数
    func numberOfSeconds(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.second]).second
    }

    /// 添加指定日历组件的值到Date
    ///
    ///     let date = Date() // "Jan 12, 2017, 7: 07 PM"
    ///     let date2 = date.adding(.minute, value: -10) // "Jan 12, 2017, 6: 57 PM"
    ///     let date3 = date.adding(.day, value: 4) // "Jan 16, 2017, 7: 07 PM"
    ///     let date4 = date.adding(.month, value: 2) // "Mar 12, 2017, 7: 07 PM"
    ///     let date5 = date.adding(.year, value: 13) // "Jan 12, 2030, 7: 07 PM"
    ///
    /// - Parameters:
    ///   - component: 组件类型
    ///   - value: 要添加到Date的组件的值
    /// - Returns: 原始日期 + 添加的组件的值
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }

    /// 添加指定日历组件的值到Date
    ///
    ///     var date = Date() // "Jan 12, 2017, 7: 07 PM"
    ///     date.add(.minute, value: -10) // "Jan 12, 2017, 6: 57 PM"
    ///     date.add(.day, value: 4) // "Jan 16, 2017, 7: 07 PM"
    ///     date.add(.month, value: 2) // "Mar 12, 2017, 7: 07 PM"
    ///     date.add(.year, value: 13) // "Jan 12, 2030, 7: 07 PM"
    ///
    /// - Parameters:
    ///   - component: 组件类型
    ///   - value: 要添加到Date的组件的值
    mutating func add(_ component: Calendar.Component, value: Int) {
        if let date = calendar.date(byAdding: component, value: value, to: self) {
            self = date
        }
    }

    /// 修改日期对象对应日历组件的值
    ///
    ///     let date = Date() // "Jan 12, 2017, 7: 07 PM"
    ///     let date2 = date.changing(.minute, value: 10) // "Jan 12, 2017, 7: 10 PM"
    ///     let date3 = date.changing(.day, value: 4) // "Jan 4, 2017, 7: 07 PM"
    ///     let date4 = date.changing(.month, value: 2) // "Feb 12, 2017, 7: 07 PM"
    ///     let date5 = date.changing(.year, value: 2000) // "Jan 12, 2000, 7: 07 PM"
    ///
    /// - Parameters:
    ///   - component: 组件类型
    ///   - value: 组件对应的新值
    /// - Returns: 将指定组件更改为指定值后的原始日期
    func changing(_ component: Calendar.Component, value: Int) -> Date? {
        switch component {
        case .nanosecond:
            #if targetEnvironment(macCatalyst)
                // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(value) else { return nil }
            let currentNanoseconds = calendar.component(.nanosecond, from: self)
            let nanosecondsToAdd = value - currentNanoseconds
            return calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self)

        case .second:
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = value - currentSeconds
            return calendar.date(byAdding: .second, value: secondsToAdd, to: self)

        case .minute:
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = value - currentMinutes
            return calendar.date(byAdding: .minute, value: minutesToAdd, to: self)

        case .hour:
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentHour = calendar.component(.hour, from: self)
            let hoursToAdd = value - currentHour
            return calendar.date(byAdding: .hour, value: hoursToAdd, to: self)

        case .day:
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = value - currentDay
            return calendar.date(byAdding: .day, value: daysToAdd, to: self)

        case .month:
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = value - currentMonth
            return calendar.date(byAdding: .month, value: monthsToAdd, to: self)

        case .year:
            guard value > 0 else { return nil }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = value - currentYear
            return calendar.date(byAdding: .year, value: yearsToAdd, to: self)

        default:
            return calendar.date(bySetting: component, value: value, of: self)
        }
    }

    #if !os(Linux)
        /// 日历组件开头的数据
        ///
        ///     let date = Date() // "Jan 12, 2017, 7: 14 PM"
        ///     let date2 = date.beginning(of: .hour) // "Jan 12, 2017, 7: 00 PM"
        ///     let date3 = date.beginning(of: .month) // "Jan 1, 2017, 12: 00 AM"
        ///     let date4 = date.beginning(of: .year) // "Jan 1, 2017, 12: 00 AM"
        ///
        /// - Parameter component: 日历组件在开始时获取日期
        /// - Returns: 日历组件开头的日期(如果适用)
        func beginning(of component: Calendar.Component) -> Date? {
            if component == .day {
                return calendar.startOfDay(for: self)
            }

            var components: Set<Calendar.Component> {
                switch component {
                case .second:
                    return [.year, .month, .day, .hour, .minute, .second]

                case .minute:
                    return [.year, .month, .day, .hour, .minute]

                case .hour:
                    return [.year, .month, .day, .hour]

                case .weekOfYear, .weekOfMonth:
                    return [.yearForWeekOfYear, .weekOfYear]

                case .month:
                    return [.year, .month]

                case .year:
                    return [.year]

                default:
                    return []
                }
            }

            guard !components.isEmpty else { return nil }
            return calendar.date(from: calendar.dateComponents(components, from: self))
        }
    #endif

    /// 日历组件末尾的日期
    ///
    ///     let date = Date() // "Jan 12, 2017, 7: 27 PM"
    ///     let date2 = date.end(of: .day) // "Jan 12, 2017, 11: 59 PM"
    ///     let date3 = date.end(of: .month) // "Jan 31, 2017, 11: 59 PM"
    ///     let date4 = date.end(of: .year) // "Dec 31, 2017, 11: 59 PM"
    ///
    /// - Parameter component: 日历组件,用于获取末尾的日期
    /// - Returns: 日历组件末尾的日期(如果适用)
    func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            date.add(.second, value: -1)
            return date

        case .minute:
            var date = adding(.minute, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .hour:
            var date = adding(.hour, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .day:
            var date = adding(.day, value: 1)
            date = calendar.startOfDay(for: date)
            date.add(.second, value: -1)
            return date

        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = calendar.date(from:
                calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date

        case .month:
            var date = adding(.month, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .year:
            var date = adding(.year, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year], from: date))!
            date = after.adding(.second, value: -1)
            return date

        default:
            return nil
        }
    }

    /// 检查日期是否在当前给定的日历组件中
    ///
    ///     Date().isInCurrent(.day) -> true
    ///     Date().isInCurrent(.year) -> true
    ///
    /// - Parameter component: 要检查的日历组件
    /// - Returns: 如果日期在当前给定的日历组件中,则返回 true
    func isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }

    /// 日期字符串
    ///
    ///     Date().dateString(ofStyle: .short) -> "1/12/17"
    ///     Date().dateString(ofStyle: .medium) -> "Jan 12, 2017"
    ///     Date().dateString(ofStyle: .long) -> "January 12, 2017"
    ///     Date().dateString(ofStyle: .full) -> "Thursday, January 12, 2017"
    ///
    /// - Parameter style: 日期格式的样式(默认 .medium).
    /// - Returns: 日期字符串
    func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    /// 日期和时间字符串
    ///
    ///     Date().dateTimeString(ofStyle: .short) -> "1/12/17, 7: 32 PM"
    ///     Date().dateTimeString(ofStyle: .medium) -> "Jan 12, 2017, 7: 32: 00 PM"
    ///     Date().dateTimeString(ofStyle: .long) -> "January 12, 2017 at 7: 32: 00 PM GMT+3"
    ///     Date().dateTimeString(ofStyle: .full) -> "Thursday, January 12, 2017 at 7: 32: 00 PM GMT+03: 00"
    ///
    /// - Parameter style: 日期格式的样式(默认 .medium).
    /// - Returns: 日期和时间字符串
    func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    /// 从日期开始的时间字符串
    ///
    ///     Date().timeString(ofStyle: .short) -> "7: 37 PM"
    ///     Date().timeString(ofStyle: .medium) -> "7: 37: 02 PM"
    ///     Date().timeString(ofStyle: .long) -> "7: 37: 02 PM GMT+3"
    ///     Date().timeString(ofStyle: .full) -> "7: 37: 02 PM GMT+03: 00"
    ///
    /// - Parameter style: 日期格式的样式(默认 .medium).
    /// - Returns: 时间字符串
    func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }

    /// 日期名称
    ///
    ///     Date().dayName(ofStyle: .oneLetter) -> "T"
    ///     Date().dayName(ofStyle: .threeLetters) -> "Thu"
    ///     Date().dayName(ofStyle: .full) -> "Thursday"
    ///
    /// - Parameter Style: 日期名称的样式(默认 DayNameStyle.full)
    /// - Returns: 日期名称字符串(例如: W、Wed、Wednesday)
    func dayName(ofStyle style: CMDayNameStyle = .full) -> String {
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "EEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    /// 从日期开始的月份名称
    ///
    ///     Date().monthName(ofStyle: .oneLetter) -> "J"
    ///     Date().monthName(ofStyle: .threeLetters) -> "Jan"
    ///     Date().monthName(ofStyle: .full) -> "January"
    ///
    /// - Parameter Style: 月份名称的样式(默认 MonthNameStyle.full)
    /// - Returns: 月份名称字符串(例如: D、Dec、December)
    func monthName(ofStyle style: CMMonthNameStyle = .full) -> String {
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "MMMMM"
            case .threeLetters:
                return "MMM"
            case .full:
                return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    /// 获取两个日期之间的秒数
    ///
    /// - Parameter date: 参与比较的日期
    /// - Returns: self 和给定日期之间的秒数
    func secondsSince(_ date: Date) -> Double {
        return timeIntervalSince(date)
    }

    /// 获取两个日期之间的分钟数
    ///
    /// - Parameter date: 参与比较的日期
    /// - Returns: self 和给定日期之间的分钟数
    func minutesSince(_ date: Date) -> Double {
        return timeIntervalSince(date) / 60
    }

    /// 获取两个日期之间的小时数
    ///
    /// - Parameter date: 参与比较的日期
    /// - Returns: self 和给定日期之间的小时数
    func hoursSince(_ date: Date) -> Double {
        return timeIntervalSince(date) / 3600
    }

    /// 获取两个日期之间的天数
    ///
    /// - Parameter date: 参与比较的日期
    /// - Returns: self 和给定日期之间的天数
    func daysSince(_ date: Date) -> Double {
        return timeIntervalSince(date) / (3600 * 24)
    }

    /// 检查一个日期是否在另外两个日期之间
    /// - Parameters:
    ///   - startDate: 开始日期
    ///   - endDate: 结束日期
    ///   - includeBounds: 如果应该包括开始和结束日期,则为 true(默认为 false)
    /// - Returns: 如果日期在两个给定日期之间,则返回 true
    func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * compare(endDate).rawValue >= 0
        }
        return startDate.compare(self).rawValue * compare(endDate).rawValue > 0
    }

    /// 检查指定日历组件的值是否包含在当前日期和指定日期之间
    ///
    /// - Parameters:
    ///   - value: 要判断的值
    ///   - component: Calendar.Component(要比较的组件)
    ///   - date: 结束日期
    /// - Returns: 如果value在当前日期和指定日期的指定组件之中,则返回true
    func isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = calendar.dateComponents([component], from: self, to: date)
        let componentValue = components.value(for: component)!
        return abs(componentValue) <= value
    }

    /// 返回指定范围内的随机日期
    ///
    /// - Parameter range: 创建随机日期的范围. `range` 不能为空(不包含结束日期)
    /// - Returns: `range` 范围内的随机日期
    static func random(in range: Range<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    /// 返回指定范围内的随机日期
    ///
    /// - Parameter range: 创建随机日期的范围(包含结束日期)
    /// - Returns: `range` 范围内的随机日期
    static func random(in range: ClosedRange<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    /// 返回指定范围内的随机日期,使用给定的生成器作为随机源
    ///
    /// - Parameters:
    ///   - range: 创建随机日期的范围. `range` 不能为空(不包含结束日期)
    ///   - generator: 创建新随机日期时使用的随机数生成器
    /// - Returns: `range` 范围内的随机日期
    static func random<T>(in range: Range<Date>, using generator: inout T) -> Date where T: RandomNumberGenerator {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }

    /// 返回指定范围内的随机日期,使用给定的生成器作为随机源
    ///
    /// - Parameters:
    ///   - range: 创建随机日期的范围(包含结束日期)
    ///   - generator: 创建新随机日期时使用的随机数生成器
    /// - Returns: `range` 范围内的随机日期
    static func random<T>(in range: ClosedRange<Date>, using generator: inout T) -> Date
        where T: RandomNumberGenerator
    {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }
}

// MARK: - 静态方法
public extension Date {
    /// 获取某一年某一月的天数
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份
    /// - Returns: 返回天数
    static func daysCount(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            fatalError("非法的月份: \(month)")
        }
    }

    /// 获取当前月的天数
    /// - Returns: 返回天数
    static func currentMonthDays() -> Int {
        return daysCount(year: nowDate.year, month: nowDate.month)
    }
}
