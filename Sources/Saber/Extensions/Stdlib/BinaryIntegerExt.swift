import CoreGraphics
import Foundation

// MARK: - 属性
public extension BinaryInteger {
    /// 转`Int`
    var int: Int {
        return Int(self)
    }

    /// 转`UInt`
    var uInt: UInt {
        return UInt(self)
    }

    /// 转`Int64`
    var int64: Int64 {
        return Int64(self)
    }

    /// 转`Int64`
    var uInt64: UInt64 {
        return UInt64(self)
    }

    /// 转`Float`
    var float: Float {
        return Float(self)
    }

    /// 转`Double`
    var double: Double {
        return Double(self)
    }

    /// 转`CGFloat`
    var cgFloat: CGFloat {
        return CGFloat(self)
    }

    /// 转`NSNumber`
    var nsNumber: NSNumber {
        guard let n = self as? Int else {
            return NSNumber(value: 0)
        }
        return NSNumber(value: n)
    }

    /// 转`NSDecimalNumber`
    var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: double)
    }

    /// 转`Decimal`
    var decimal: Decimal {
        return decimalNumber.decimalValue
    }

    /// 转`Character`
    var character: Character? {
        guard let n = self as? Int,
              let scalar = UnicodeScalar(n)
        else {
            return nil
        }
        return Character(scalar)
    }

    /// 转`String`
    var string: String {
        return String(self)
    }

    /// 生成`(width, height)`相同的`CGSize`
    var size: CGSize {
        guard let n = self as? Int else {
            return .zero
        }
        return CGSize(width: n, height: n)
    }

    /// 生成`(x,y)`相同的`CGPoint`
    var point: CGPoint {
        guard let n = self as? Int else {
            return .zero
        }
        return CGPoint(x: n, y: n)
    }

    /// 生成`0-self`之间的`CountableRange<Int>`
    var range: CountableRange<Int> {
        let n = self as! Int
        return 0 ..< n
    }

    /// 转字节数组(`UInt8`数组)
    ///
    ///     var number = Int16(-128)
    ///     print(number.bytes)
    ///     // prints "[255, 128]"
    ///
    var bytes: [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0 ..< MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }

    /// 数字转罗马数字
    var romanNumeral: String? {
        guard self > 0 else {
            return nil
        }
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = int

        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            for _ in 0 ..< div {
                romanValue.append(romanChar)
            }
            startingValue -= arabicValue * div
        }
        return romanValue
    }

    /// `byte(字节)`转换存储单位
    /// - Returns: 转换后的文件大小
    var storeUnit: String {
        var value = double
        var index = 0
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while value > 1024 {
            value /= 1024
            index += 1
        }
        return String(format: "%4.2f %@", value, units[index])
    }

    /// 是否是奇数
    var isOdd: Bool {
        return self % 2 != 0
    }

    /// 是否是偶数
    var isEven: Bool {
        return self % 2 == 0
    }

    /// 是否是正数
    var isPositive: Bool {
        return self > 0
    }

    /// 是否是负数
    var isNegative: Bool {
        return self < 0
    }

    /// 当前数值是否是素数
    var isPrime: Bool {
        if self == 2 { return true }
        guard self > 1, self % 2 != 0 else { return false }
        let basic = Int(sqrt(Double(self)))
        for int in Swift.stride(from: 3, through: basic, by: 2) where Int(self) % int == 0 {
            return false
        }
        return true
    }
}

// MARK: - 方法
public extension BinaryInteger {
    /// 角度转弧度
    func angle2radian() -> Double {
        return double * .pi / 180.0
    }

    /// 弧度转角度
    func radian2angle() -> Double {
        return double * 180.0 / .pi
    }
}

// MARK: - 日期/时间
public extension BinaryInteger {
    /// `Int`时间戳转日期对象
    /// - Parameter isUnix: 是否是`Unix`时间戳格式(默认`true`)
    /// - Returns: Date
    func date(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(double / (isUnix ? 1.0 : 1000.0)))
    }

    /// `Int`时间戳转日期字符串
    /// - Parameters:
    ///   - dateFormat: 日期格式化样式
    ///   - isUnix: 是否是`Unix`时间戳格式(默认`true`)
    /// - Returns: 表示日期的字符串
    func dateString(_ dateFormat: String = "yyyy-MM-dd HH: mm: ss", isUnix: Bool = true) -> String {
        // 如果时间戳为毫秒需要除以
        var serverTimeStamp = TimeInterval(self)
        if !isUnix {
            serverTimeStamp /= 1000.0
        }
        let date = Date(timeIntervalSince1970: serverTimeStamp)

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

        return formatter.string(from: date)
    }

    /// 时间戳与当前时间的时间差
    /// - Parameter format: 格式化样式`yyyy-MM-dd HH: mm: ss`
    /// - Returns: 日期字符串
    func delta(_ format: String = "yyyy-MM-dd HH: mm: ss") -> String {
        let date = Date(timeInterval: double, since: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// 时间戳格式化为指定日期字符串
    /// - Parameters format: 格式化 `yyyy-MM-dd HH: mm: ss`
    /// - Returns: 日期字符串
    func format(_ format: String = "yyyy-MM-dd HH: mm: ss") -> String {
        let time = double - 3600 * 8
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    /// `Int`时间戳转表示日期的字符串(`刚刚/x分钟前`)
    /// - Parameter isUnix: 是否是`Unix`时间戳格式(默认`true`)
    /// - Returns: 表示日期的字符串
    func timeline(isUnix: Bool = true) -> String {
        // 获取当前的时间戳
        let currentTimeStamp = Date().timeIntervalSince1970
        // 服务器时间戳(如果是毫秒 要除以1000)
        var serverTimeStamp = TimeInterval(self)
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
        formatter.dateFormat = "yyyy年MM月dd日 HH: mm: ss"
        return formatter.string(from: date)
    }
}
