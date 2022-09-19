import Foundation

// MARK: - 属性
public extension SaberExt where Base: SignedInteger {
    /// `byte(字节)`转换存储单位
    /// - Returns: 转换后的文件大小
    var storeUnit: String {
        var value = self.base.sb.doubleValue
        var index = 0
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while value > 1024 {
            value /= 1024
            index += 1
        }
        return String(format: "%4.2f %@", value, units[index])
    }
}

// MARK: - 日期/时间
public extension SaberExt where Base: SignedInteger {
    /// Int时间戳转日期对象
    /// - Parameter isUnix: 是否是Unix时间戳格式(默认true)
    /// - Returns: Date
    func date(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.base.sb.doubleValue / (isUnix ? 1.0 : 1000.0)))
    }

    /// Int时间戳转日期字符串
    /// - Parameters:
    ///   - dateFormat: 日期格式化样式
    ///   - isUnix: 是否是Unix时间戳格式(默认true)
    /// - Returns: 表示日期的字符串
    func dateString(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss", isUnix: Bool = true) -> String {
        // 如果时间戳为毫秒需要除以
        var serverTimeStamp = TimeInterval(self.base)
        if !isUnix {
            serverTimeStamp /= 1000.0
        }
        let date = Date(timeIntervalSince1970: serverTimeStamp)

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

        return formatter.string(from: date)
    }

    /// Int时间戳转表示日期的字符串(刚刚/x分钟前)
    /// - Parameter isUnix: 是否是Unix时间戳格式(默认true)
    /// - Returns: 表示日期的字符串
    func timeline(isUnix: Bool = true) -> String {
        // 获取当前的时间戳
        let currentTimeStamp = Date().timeIntervalSince1970
        // 服务器时间戳(如果是毫秒 要除以1000)
        var serverTimeStamp = TimeInterval(self.base)
        if !isUnix {
            serverTimeStamp /= 1000.0
        }
        // 时间差
        let reduceTime: TimeInterval = currentTimeStamp - serverTimeStamp

        if reduceTime < 60 {
            return "刚刚"
        }

        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }

        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }

        let days = Int(reduceTime / 3600 / 24)
        if days < 30 {
            return "\(days)天前"
        }

        let date = Date(timeIntervalSince1970: serverTimeStamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return formatter.string(from: date)
    }
}

// MARK: - 运算符
precedencegroup PowerPrecedence {
    higherThan: MultiplicationPrecedence
}

infix operator **: PowerPrecedence
/// 指数
///
/// - Parameters:
///   - lhs: 底数
///   - rhs: 指数
/// - Returns: Double (示例: 2 ** 3 = 8)
public func ** (lhs: Int, rhs: Int) -> Double {
    return pow(Double(lhs), Double(rhs))
}
