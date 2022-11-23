import Foundation

// MARK: - 日期名称格式枚举
public enum SBDayNameStyle {
    /// 日期名称的 3 个字母日期缩写
    case threeLetters
    /// 日期名称的 1 个字母日期缩写
    case oneLetter
    /// 完整的天名称
    case full
}

// MARK: - 月份名称格式枚举
public enum SBMonthNameStyle {
    /// 3 个字母月份的月份名称缩写
    case threeLetters
    /// 月份名称的 1 个字母月份缩写
    case oneLetter
    /// 完整的月份名称
    case full
}

private let calendar = Calendar.current
private let dateFormatter = DateFormatter()

// extension Date: Saberable {}

// MARK: - 属性
public extension SaberEx where Base == Date {
    /// `Calendar`
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier)
    }
}

// MARK: - 属性
public extension Date {
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

    /// 日期中的`秒`
    ///
    ///     Date().second -> 55
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

    /// 日期中的`毫秒`
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

    /// 日期中的`纳秒`
    ///
    ///     Date().nanosecond -> 981379985
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
}

// MARK: - 构造方法
public extension Date {
    /// 使用`日历组件`创建一个`Date`
    ///
    ///     let date = Date(year:2010, month:1, day:12) // "Jan 12, 2010, 7:45 PM"
    /// - Parameters:
    ///   - calendar:日历(`默认为当前`)
    ///   - timeZone:时区(`默认为当前`)
    ///   - era:时代(`默认为当前时代`)
    ///   - year:年份(`默认为当前年份`)
    ///   - month:月份(`默认为当前月份`)
    ///   - day:日(`默认为今天`)
    ///   - hour:小时(`默认为当前小时`)
    ///   - minute:分钟(`默认为当前分钟`)
    ///   - second:秒(`默认为当前秒`)
    ///   - nanosecond:纳秒(`默认为当前纳秒`)
    init?(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = NSTimeZone.default,
        era: Int? = Date.sb.nowDate().sb.era(),
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

    /// 根据`ISO8601`格式的`日期字符串`创建`Date`
    ///
    ///     let date = Date(iso8601String:"2017-01-12T16:48:00.959Z") // "Jan 12, 2017, 7:48 PM"
    /// - Parameter iso8601String:`ISO8601`格式字符串`(yyyy-MM-dd'T'HH:mm:ss.SSSZ)`
    init?(iso8601String: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: iso8601String) else { return nil }
        self = date
    }

    /// 从`UNIX`时间戳创建`Date`
    ///
    ///     let date = Date(unixTimestamp:1484239783.922743) // "Jan 12, 2017, 7:49 PM"
    /// - Parameter unixTimestamp:`UNIX`时间戳.
    init(unix_timestamp: Double) {
        self.init(timeIntervalSince1970: unix_timestamp)
    }

    /// 使用`Int`字面量创建`Date`
    ///
    ///     let date = Date(integerLiteral:2017_12_25) // "2017-12-25 00:00:00 +0000"
    /// - Parameter value:`Int`值, 例如`20171225`或者`2017_12_25`
    init?(integerLiteral value: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        guard let date = formatter.date(from: String(value)) else { return nil }
        self = date
    }
}

// MARK: - 方法
public extension SaberEx where Base == Date {
    /// 日期字符串
    func toString() -> String {
        return format()
    }

    /// 时间差描述
    /// - Returns: `String`
    func timeExplain() -> String {
        // 获取当前的时间戳
        let currentTimeStamp = Date().timeIntervalSince1970
        // 服务器时间戳(如果是毫秒 要除以1000)
        let serverTimeStamp = base.timeIntervalSince1970

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
        dfmatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dfmatter.string(from: date)
    }

    /// 取得与当前时间的间隔差
    /// - Returns:时间差
    func callTimeAfterNow() -> String {
        // 获取时间间隔
        let timeInterval = Date().timeIntervalSince(base)
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
        let secondFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: base))
        return base.addingTimeInterval(secondFromGMT)
    }

    /// 是否为  `同一年`  `同一月` `同一天`
    /// - Returns:`Bool`
    func isSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(base, inSameDayAs: date)
    }

    /// 日期的`加减`操作
    /// - Parameter day:天数变化
    /// - Returns:`date`
    func adding(day: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: day), to: base)
    }

    /// 是否为  `同一年`  `同一月` `同一天`
    /// - Parameter date: `date`
    /// - Returns: `Bool`
    func isSameYeaerMountDay(_ date: Date) -> Bool {
        let com = Calendar.current.dateComponents([.year, .month, .day], from: base)
        let comToday = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return (com.day == comToday.day
            && com.month == comToday.month
            && com.year == comToday.year)
    }

    /// 获取两个日期之间的数据
    /// - Parameters:
    ///   - date:对比的日期
    ///   - unit:对比的类型
    /// - Returns:两个日期之间的数据
    func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
        let calendar = Calendar.current
        let component = calendar.dateComponents(unit, from: date, to: base)
        return component
    }

    /// 获取两个日期之间的天数
    /// - Parameter date:对比的日期
    /// - Returns:两个日期之间的天数
    func numberOfDays(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.day]).day
    }

    /// 获取两个日期之间的小时
    /// - Parameter date:对比的日期
    /// - Returns:两个日期之间的小时
    func numberOfHours(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.hour]).hour
    }

    /// 获取两个日期之间的分钟
    /// - Parameter date:对比的日期
    /// - Returns:两个日期之间的分钟
    func numberOfMinutes(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.minute]).minute
    }

    /// 获取两个日期之间的秒数
    /// - Parameter date:对比的日期
    /// - Returns:两个日期之间的秒数
    func numberOfSeconds(from date: Date) -> Int? {
        return componentCompare(from: date, unit: [.second]).second
    }

    /// 添加指定日历组件的值到`Date`
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.adding(.minute, value:-10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.adding(.day, value:4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.adding(.month, value:2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.adding(.year, value:13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component:组件类型
    ///   - value:要添加到Date的组件的值
    /// - Returns:原始日期 + 添加的组件的值
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: base)!
    }

    /// 添加指定日历组件的值到`Date`
    ///
    ///     var date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     date.add(.minute, value:-10) // "Jan 12, 2017, 6:57 PM"
    ///     date.add(.day, value:4) // "Jan 16, 2017, 7:07 PM"
    ///     date.add(.month, value:2) // "Mar 12, 2017, 7:07 PM"
    ///     date.add(.year, value:13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component:组件类型
    ///   - value:要添加到`Date`的组件的值
    func add(_ component: Calendar.Component, value: Int) -> Date? {
        if let date = calendar.date(byAdding: component, value: value, to: base) {
            return date
        }
        return nil
    }

    /// 修改日期对象对应日历组件的值
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.changing(.minute, value:10) // "Jan 12, 2017, 7:10 PM"
    ///     let date3 = date.changing(.day, value:4) // "Jan 4, 2017, 7:07 PM"
    ///     let date4 = date.changing(.month, value:2) // "Feb 12, 2017, 7:07 PM"
    ///     let date5 = date.changing(.year, value:2000) // "Jan 12, 2000, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component:组件类型
    ///   - value:组件对应的新值
    /// - Returns:将指定组件更改为指定值后的原始日期
    func changing(_ component: Calendar.Component, value: Int) -> Date? {
        switch component {
        case .nanosecond:
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: base)!
            #endif
            guard allowedRange.contains(value) else { return nil }
            let currentNanoseconds = calendar.component(.nanosecond, from: base)
            let nanosecondsToAdd = value - currentNanoseconds
            return calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: base)

        case .second:
            let allowedRange = calendar.range(of: .second, in: .minute, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentSeconds = calendar.component(.second, from: base)
            let secondsToAdd = value - currentSeconds
            return calendar.date(byAdding: .second, value: secondsToAdd, to: base)

        case .minute:
            let allowedRange = calendar.range(of: .minute, in: .hour, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentMinutes = calendar.component(.minute, from: base)
            let minutesToAdd = value - currentMinutes
            return calendar.date(byAdding: .minute, value: minutesToAdd, to: base)

        case .hour:
            let allowedRange = calendar.range(of: .hour, in: .day, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentHour = calendar.component(.hour, from: base)
            let hoursToAdd = value - currentHour
            return calendar.date(byAdding: .hour, value: hoursToAdd, to: base)

        case .day:
            let allowedRange = calendar.range(of: .day, in: .month, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentDay = calendar.component(.day, from: base)
            let daysToAdd = value - currentDay
            return calendar.date(byAdding: .day, value: daysToAdd, to: base)

        case .month:
            let allowedRange = calendar.range(of: .month, in: .year, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentMonth = calendar.component(.month, from: base)
            let monthsToAdd = value - currentMonth
            return calendar.date(byAdding: .month, value: monthsToAdd, to: base)

        case .year:
            guard value > 0 else { return nil }
            let currentYear = calendar.component(.year, from: base)
            let yearsToAdd = value - currentYear
            return calendar.date(byAdding: .year, value: yearsToAdd, to: base)

        default:
            return calendar.date(bySetting: component, value: value, of: base)
        }
    }

    #if !os(Linux)
        /// 日历组件开头的数据
        ///
        ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
        ///     let date2 = date.beginning(of:.hour) // "Jan 12, 2017, 7:00 PM"
        ///     let date3 = date.beginning(of:.month) // "Jan 1, 2017, 12:00 AM"
        ///     let date4 = date.beginning(of:.year) // "Jan 1, 2017, 12:00 AM"
        ///
        /// - Parameter component:日历组件在开始时获取日期
        /// - Returns:日历组件开头的日期(如果适用)
        func beginning(of component: Calendar.Component) -> Date? {
            if component == .day {
                return calendar.startOfDay(for: base)
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
            return calendar.date(from: calendar.dateComponents(components, from: base))
        }
    #endif

    /// 日历组件末尾的日期
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.end(of:.day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.end(of:.month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.end(of:.year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component:日历组件,用于获取末尾的日期
    /// - Returns:日历组件末尾的日期(如果适用)
    func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = calendar.date(
                from: calendar.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: date
                ))!
            return date.sb.add(.second, value: -1)
        case .minute:
            var date = adding(.minute, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.sb.adding(.second, value: -1)
            return date

        case .hour:
            var date = adding(.hour, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.sb.adding(.second, value: -1)
            return date

        case .day:
            var date = adding(.day, value: 1)
            date = calendar.startOfDay(for: date)
            return date.sb.add(.second, value: -1)
        case .weekOfYear, .weekOfMonth:
            var date = base
            let beginningOfWeek = calendar.date(from:
                calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.sb.adding(.day, value: 7).sb.adding(.second, value: -1)
            return date

        case .month:
            var date = adding(.month, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month], from: date))!
            date = after.sb.adding(.second, value: -1)
            return date

        case .year:
            var date = adding(.year, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year], from: date))!
            date = after.sb.adding(.second, value: -1)
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
    /// - Parameter component:要检查的日历组件
    /// - Returns:如果日期在当前给定的日历组件中,则返回 `true`
    func isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: component)
    }

    /// 日期字符串
    ///
    ///     Date().dateString(ofStyle:.short) -> "1/12/17"
    ///     Date().dateString(ofStyle:.medium) -> "Jan 12, 2017"
    ///     Date().dateString(ofStyle:.long) -> "January 12, 2017"
    ///     Date().dateString(ofStyle:.full) -> "Thursday, January 12, 2017"
    ///
    /// - Parameter style:日期格式的样式(默认 `.medium`)
    /// - Returns:日期字符串
    func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: base)
    }

    /// 日期和时间字符串
    ///
    ///     Date().dateTimeString(ofStyle:.short) -> "1/12/17, 7:32 PM"
    ///     Date().dateTimeString(ofStyle:.medium) -> "Jan 12, 2017, 7:32:00 PM"
    ///     Date().dateTimeString(ofStyle:.long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
    ///     Date().dateTimeString(ofStyle:.full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
    ///
    /// - Parameter style:日期格式的样式(默认 `.medium`)
    /// - Returns:日期和时间字符串
    func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: base)
    }

    /// 从日期开始的时间字符串
    ///
    ///     Date().timeString(ofStyle:.short) -> "7:37 PM"
    ///     Date().timeString(ofStyle:.medium) -> "7:37:02 PM"
    ///     Date().timeString(ofStyle:.long) -> "7:37:02 PM GMT+3"
    ///     Date().timeString(ofStyle:.full) -> "7:37:02 PM GMT+03:00"
    ///
    /// - Parameter style:日期格式的样式(默认 `.medium`)
    /// - Returns:时间字符串
    func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: base)
    }

    /// 日期名称
    ///
    ///     Date().dayName(ofStyle:.oneLetter) -> "T"
    ///     Date().dayName(ofStyle:.threeLetters) -> "Thu"
    ///     Date().dayName(ofStyle:.full) -> "Thursday"
    ///
    /// - Parameter Style:日期名称的样式(默认 `DayNameStyle.full`)
    /// - Returns:日期名称字符串(例如:`W、Wed、Wednesday`)
    func dayName(ofStyle style: SBDayNameStyle = .full) -> String {
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
        return dateFormatter.string(from: base)
    }

    /// 从日期开始的月份名称
    ///
    ///     Date().monthName(ofStyle:.oneLetter) -> "J"
    ///     Date().monthName(ofStyle:.threeLetters) -> "Jan"
    ///     Date().monthName(ofStyle:.full) -> "January"
    ///
    /// - Parameter Style:月份名称的样式(默认 `MonthNameStyle.full`)
    /// - Returns:月份名称字符串(例如:`D、Dec、December`)
    func monthName(ofStyle style: SBMonthNameStyle = .full) -> String {
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
        return dateFormatter.string(from: base)
    }

    /// 获取两个日期之间的秒数
    ///
    /// - Parameter date:参与比较的日期
    /// - Returns:self 和给定日期之间的秒数
    func secondsSince(_ date: Date) -> Double {
        return base.timeIntervalSince(date)
    }

    /// 获取两个日期之间的分钟数
    ///
    /// - Parameter date:参与比较的日期
    /// - Returns:self 和给定日期之间的分钟数
    func minutesSince(_ date: Date) -> Double {
        return base.timeIntervalSince(date) / 60
    }

    /// 获取两个日期之间的小时数
    ///
    /// - Parameter date:参与比较的日期
    /// - Returns:self 和给定日期之间的小时数
    func hoursSince(_ date: Date) -> Double {
        return base.timeIntervalSince(date) / 3600
    }

    /// 获取两个日期之间的天数
    ///
    /// - Parameter date:参与比较的日期
    /// - Returns:self 和给定日期之间的天数
    func daysSince(_ date: Date) -> Double {
        return base.timeIntervalSince(date) / (3600 * 24)
    }

    /// 检查一个日期是否在另外两个日期之间
    /// - Parameters:
    ///   - startDate:开始日期
    ///   - endDate:结束日期
    ///   - includeBounds:如果应该包括开始和结束日期,则为 true(默认为 false)
    /// - Returns:如果日期在两个给定日期之间,则返回 true
    func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(base).rawValue * base.compare(endDate).rawValue >= 0
        }
        return startDate.compare(base).rawValue * base.compare(endDate).rawValue > 0
    }

    /// 检查指定日历组件的值是否包含在当前日期和指定日期之间
    ///
    /// - Parameters:
    ///   - value:要判断的值
    ///   - component:`Calendar.Component`(要比较的组件)
    ///   - date:结束日期
    /// - Returns:如果`value`在当前日期和指定日期的指定组件之中,则返回`true`
    func isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = calendar.dateComponents([component], from: base, to: date)
        let componentValue = components.value(for: component)!
        return Darwin.abs(Int32(componentValue)) <= value
    }

    /// 返回指定范围内的随机日期
    ///
    /// - Parameter range:创建随机日期的范围. `range` 不能为空(不包含结束日期)
    /// - Returns:`range` 范围内的随机日期
    static func random(in range: Range<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    /// 返回指定范围内的随机日期
    ///
    /// - Parameter range:创建随机日期的范围(包含结束日期)
    /// - Returns:`range` 范围内的随机日期
    static func random(in range: ClosedRange<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    /// 返回指定范围内的随机日期,使用给定的生成器作为随机源
    ///
    /// - Parameters:
    ///   - range:创建随机日期的范围. `range` 不能为空(不包含结束日期)
    ///   - generator:创建新随机日期时使用的随机数生成器
    /// - Returns:`range` 范围内的随机日期
    static func random<T>(
        in range: Range<Date>,
        using generator: inout T
    ) -> Date where T: RandomNumberGenerator {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }

    /// 返回指定范围内的随机日期,使用给定的生成器作为随机源
    ///
    /// - Parameters:
    ///   - range:创建随机日期的范围(包含结束日期)
    ///   - generator:创建新随机日期时使用的随机数生成器
    /// - Returns:`range` 范围内的随机日期
    static func random<T>(
        in range: ClosedRange<Date>,
        using generator: inout T
    ) -> Date
        where T: RandomNumberGenerator
    {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }
}

// MARK: - 便利方法
public extension SaberEx where Base == Date {
    /// 当前年属性哪个`年代`
    func era() -> Int {
        return calendar.component(.era, from: base)
    }

    #if !os(Linux)
        /// 本年中的第几个`季度`
        func quarter() -> Int {
            let month = Double(calendar.component(.month, from: base))
            let numberOfMonths = Double(calendar.monthSymbols.count)
            let numberOfMonthsInQuarter = numberOfMonths / 4
            return Int(Darwin.ceil(month / numberOfMonthsInQuarter))
        }
    #endif

    /// 本年中的第几`周`
    func weekOfYear() -> Int {
        return calendar.component(.weekOfYear, from: base)
    }

    /// 一个月的第几`周`
    func weekOfMonth() -> Int {
        return calendar.component(.weekOfMonth, from: base)
    }

    /// 本`周`中的第几`天`
    func weekday() -> Int {
        return calendar.component(.weekday, from: base)
    }

    /// 当前时间戳(单位`毫秒`)
    func timestamp() -> Int {
        return Int(base.timeIntervalSince1970 * 1000)
    }

    /// 当前时间戳(单位`秒`)
    func unix_timestamp() -> Double {
        return base.timeIntervalSince1970
    }

    /// 格林尼治时间戳(单位`秒`)
    func GMT_timestamp() -> Int {
        let offset = TimeZone.current.secondsFromGMT(for: base)
        return Int(base.timeIntervalSince1970) - offset
    }

    /// 当前`时区`的`日期`
    func currentZoneDate() -> Date {
        let date = Date()
        let zone = NSTimeZone.system
        let time = zone.secondsFromGMT(for: date)
        let dateNow = date.addingTimeInterval(TimeInterval(time))

        return dateNow
    }

    /// `self`是`星期几`(中文)
    func weekdayAsString() -> String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: base)
        return weekdays[theComponents.weekday! - 1]
    }

    /// `self`是`几月`(英文)
    func monthAsString() -> String {
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: base)
    }

    /// 日期`是否在将来`
    func isInFuture() -> Bool {
        return base > Date()
    }

    /// 日期`是否过去`
    func isInPast() -> Bool {
        return base < Date()
    }

    /// 日期是否在`今天之内`
    func isInToday() -> Bool {
        return calendar.isDateInToday(base)
    }

    /// 日期是否在`昨天之内`
    func isInYesterday() -> Bool {
        return calendar.isDateInYesterday(base)
    }

    /// 日期是否在`明天之内`
    func isInTomorrow() -> Bool {
        return calendar.isDateInTomorrow(base)
    }

    /// 日期是否在`周末期间`
    func isInWeekend() -> Bool {
        return calendar.isDateInWeekend(base)
    }

    /// 日期是否在`工作日期间`
    func isWorkday() -> Bool {
        return !calendar.isDateInWeekend(base)
    }

    /// 日期是否在`本周内`
    func isInCurrentWeek() -> Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 日期是否在`当前月份内`
    func isInCurrentMonth() -> Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .month)
    }

    /// 日期是否在`当年之内`
    func isInCurrentYear() -> Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .year)
    }

    /// 当前日期`是不是润年`
    func isLeapYear() -> Bool {
        let year = base.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }

    /// 将日期格式化为`ISO8601`标准的格式`(yyyy-MM-dd'T'HH:mm:ss.SSS)`
    ///
    ///     Date().iso8601String -> "2017-01-12T14:51:29.574Z"
    func iso8601String() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: base).appending("Z")
    }

    /// ` 距离最近`的可以被`五分钟整除`的`时间`
    ///
    ///     func date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.nearestFiveMinutes() // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.nearestFiveMinutes() // "5:45 PM"
    func nearestFiveMinutes() -> Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: base)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// `距离最近`的可以被`十分钟整除`的`时间`
    ///
    ///     func date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.nearestTenMinutes // "5:50 PM"
    func nearestTenMinutes() -> Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: base
        )
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// `距离最近`的可以被`十五分钟(一刻钟)`整除的`时间`
    ///
    ///     func date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.nearestQuarterHour // "5:45 PM"
    func nearestQuarterHour() -> Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: base
        )
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// `距离最近`的可以被`三十分钟(半小时)`整除的`时间`
    ///
    ///     func date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.nearestHalfHour // "7:00 PM"
    func nearestHalfHour() -> Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: base)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// `距离最近`的可以被`六十分钟(一小时)`整除的`时间`
    ///
    ///     func date = Date() // "6:17 PM"
    ///     date.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.nearestHour // "7:00 PM"
    func nearestHour() -> Date {
        let min = calendar.component(.minute, from: base)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: base))!

        if min < 30 {
            return date
        }
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    /// `昨天`的`日期`
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    func yesterday() -> Date {
        return calendar.date(byAdding: .day, value: -1, to: base) ?? Date()
    }

    /// `明天`的`日期`
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    func tomorrow() -> Date {
        return calendar.date(byAdding: .day, value: 1, to: base) ?? Date()
    }
}

// MARK: - 时间戳
public extension SaberEx where Base == Date {
    /// 时间戳转换为日期字符串
    /// - Parameters:
    ///   - timestamp:时间戳
    ///   - format:格式
    /// - Returns:对应时间的字符串
    static func timestampAsDateString(timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        // 时间戳转为Date
        let date = timestampAsDate(timestamp: timestamp)
        // 设置 dateFormat
        dateFormatter.dateFormat = format
        // 按照dateFormat把Date转化为String
        return dateFormatter.string(from: date)
    }

    /// 时间戳转换为`Date`
    /// - Parameter timestamp:时间戳
    /// - Returns:返回 Date
    static func timestampAsDate(timestamp: String) -> Date {
        guard timestamp.count == 10 || timestamp.count == 13 else {
            #if DEBUG
                fatalError("时间戳位数不是 10 也不是 13")
            #else
                return Date()
            #endif
        }
        let timestampValue = timestamp.count == 10 ? timestamp.sb.toInt() : timestamp.sb.toInt() / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }

    /// `Date`转`时间戳`
    /// - Parameter isUnix:是否是`Unix`格式时间戳
    /// - Returns:时间戳
    func dateAsTimestamp(isUnix: Bool = true) -> String {
        // 10位数时间戳 和 13位数时间戳
        let interval = isUnix ? CLongLong(Int(base.timeIntervalSince1970)) : CLongLong(Darwin.round(base.timeIntervalSince1970 * 1000))
        return "\(interval)"
    }
}

// MARK: - 静态方法
public extension SaberEx where Base == Date {
    /// `今天`的`日期`
    /// - Returns: `Date`
    static func todayDate() -> Date {
        return Date()
    }

    /// `昨天`的`日期`
    /// - Returns: `Date?`
    static func yesterDayDate() -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
    }

    /// `明天`的`日期`
    /// - Returns: `Date?`
    static func tomorrowDate() -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
    }

    /// `前天`的`日期`
    /// - Returns: `Date?`
    static func theDayBeforYesterDayDate() -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
    }

    /// `后天`的`日期`
    /// - Returns: `Date?`
    static func theDayAfterYesterDayDate() -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 2), to: Date())
    }

    /// 获取当前时间戳`秒`(`10位`)
    /// - Returns: `String`
    static func secondStamp() -> String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }

    /// 获取当前时间戳`毫秒`(`13位`)
    /// - Returns: `String`
    static func milliStamp() -> String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(Darwin.round(timeInterval * 1000))
        return "\(millisecond)"
    }

    /// 获取`当前`的`Date`
    /// - Returns: `Date`
    static func nowDate() -> Date {
        if #available(iOS 15, *) {
            return Date.now
        } else {
            return Date()
        }
    }

    /// 获取`某一年某一月`的`天数`
    /// - Parameters:
    ///   - year:年份
    ///   - month:月份
    /// - Returns:天数
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
            fatalError("非法的月份:\(month)")
        }
    }

    /// 获取当前日期`月份`的`天数`
    /// - Returns:当前日期`月份`的`天数`
    static func currentMonthDays() -> Int {
        let date = nowDate()
        return daysCount(year: date.year, month: date.month)
    }
}

// MARK: - 格式化
public extension SaberEx where Base == Date {
    /// 获取`指定时区``指定格式`的`日期字符串`
    /// - Parameters:
    ///   - format:时间格式
    ///   - isGMT:是否是`格林尼治时区`
    /// - Returns:日期字符串
    func format(_ format: String = "yyyy-MM-dd HH:mm:ss", isGMT: Bool = false) -> String {
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = isGMT ? TimeZone(secondsFromGMT: 0) : TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: base)
    }

    /// 日期字符串
    ///
    ///     Date().string(withFormat:"dd/MM/yyyy") -> "1/12/17"
    ///     Date().string(withFormat:"HH:mm") -> "23:50"
    ///     Date().string(withFormat:"dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
    /// - Parameter format:日期格式(默认 `dd/MM/yyyy`).
    /// - Returns:日期字符串
    func string(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .current
        return dateFormatter.string(from: base)
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

    /// 带格式的时间转 时间戳,支持返回 `13位` 和 `10位`的时间戳,时间字符串和时间格式必须保持一致
    /// - Parameters:
    ///   - timeString:时间字符串,如:`2020-10-26 16:52:41`
    ///   - formatter:时间格式,如:`yyyy-MM-dd HH:mm:ss`
    ///   - isUnix: 是否是`Unix`时间戳
    /// - Returns:时间戳字符串
    static func dateStringAsTimestamp(timesString: String, formatter: String, isUnix: Bool = true) -> String {
        guard let date = dateFormatter.date(from: timesString) else {
            #if DEBUG
                fatalError("时间有问题")
            #else
                return ""
            #endif
        }
        if isUnix {
            return "\(Int(date.timeIntervalSince1970))"
        }
        return "\(Int(date.timeIntervalSince1970 * 1000))"
    }

    /// 带格式的时间转 `Date`
    /// - Parameters:
    ///   - timesString:时间字符串
    ///   - formatter:格式
    /// - Returns:返回 Date
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
    ///   - secounds:秒数
    ///   - type:格式类型`nil`为默认类型
    /// - Returns:返回时间条
    static func formatPlayTime(seconds: Int, type: Calendar.Component? = nil) -> String {
        if seconds <= 0 {
            return "00:00"
        }

        // 秒
        let second = seconds % 60
        if type == .second {
            return String(format: "%02d", seconds)
        }
        // 分钟
        var minute = Int(seconds / 60)
        if type == .minute {
            return String(format: "%02d:%02d", minute, second)
        }
        // 小时
        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }
        if type == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        // normal 类型
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        if minute > 0 {
            return String(format: "%02d:%02d", minute, second)
        }
        return String(format: "%02d", second)
    }
}
