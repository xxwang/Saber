import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension SaberExt where Base: BinaryInteger {
    /// 转`Int`
    /// - Returns: `Int`
    func toInt() -> Int {
        return Int(base)
    }

    /// 转`UInt`
    /// - Returns: `UInt`
    func toUInt() -> UInt {
        return UInt(base)
    }

    /// 转`Int64`
    /// - Returns: `Int64`
    func toInt64() -> Int64 {
        return Int64(base)
    }

    /// 转`Int64`
    /// - Returns: `UInt64`
    func toUInt64() -> UInt64 {
        return UInt64(base)
    }

    /// 转`Float`
    /// - Returns: `Float`
    func toFloat() -> Float {
        return Float(base)
    }

    /// 转`Double`
    /// - Returns: `Double`
    func toDouble() -> Double {
        return Double(base)
    }

    /// 转`CGFloat`
    /// - Returns: `CGFloat`
    func toCGFloat() -> CGFloat {
        return CGFloat(base)
    }

    /// 转`Character`
    /// - Returns: `Character?`
    func toCharacter() -> Character? {
        guard let n = base as? Int, let scalar = UnicodeScalar(n) else {
            return nil
        }
        return Character(scalar)
    }

    /// 转`String`
    /// - Returns: `String`
    func toString() -> String {
        return String(base)
    }

    /// 转`NSNumber`
    /// - Returns: `NSNumber`
    func toNSNumber() -> NSNumber {
        guard let n = base as? Int else {
            return NSNumber(value: 0)
        }
        return NSNumber(value: n)
    }

    /// 转`Decimal`
    /// - Returns: `Decimal`
    func toDecimal() -> Decimal {
        return toDecimalNumber().decimalValue
    }

    /// 转`NSDecimalNumber`
    /// - Returns: `NSDecimalNumber`
    func toDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: toDouble())
    }
}

// MARK: - 方法
public extension SaberExt where Base: BinaryInteger {
    /// 角度转弧度(`假设当前值为角度`)
    /// - Returns: `Double`弧度
    func toRadian() -> Double {
        return toDouble() * .pi / 180.0
    }

    /// 弧度转角度(`假设当前值为弧度`)
    /// - Returns: `Double`角度
    func toAngle() -> Double {
        return toDouble() * 180.0 / .pi
    }

    /// 数字转罗马数字
    /// - Returns: `String?`罗马数字
    func toRomanNumeral() -> String? {
        guard base > 0 else { return nil }
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = toInt()

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

    /// 转字节数组(`UInt8`数组)
    ///
    ///     var number = Int16(-128)
    ///     print(number.bytes) ->  "[255, 128]"
    /// - Returns: `[UInt8]`
    func toBytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Base>.size)
        var value = base
        for _ in 0 ..< MemoryLayout<Base>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }

    /// `byte(字节)`转换存储单位
    /// - Returns: `String`单位大小
    func toStoreUnit() -> String {
        var value = toDouble()
        var index = 0
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while value > 1024 {
            value /= 1024
            index += 1
        }
        return String(format: "%4.2f %@", value, units[index])
    }

    /// 生成`(width, height)`相同的`CGSize`
    /// - Returns: `CGSize`
    func toSize() -> CGSize {
        guard let n = base as? Int else {
            return .zero
        }
        return CGSize(width: n, height: n)
    }

    /// 生成`(x,y)`相同的`CGPoint`
    /// - Returns: `CGPoint`
    func toPoint() -> CGPoint {
        guard let n = base as? Int else {
            return .zero
        }
        return CGPoint(x: n, y: n)
    }

    /// 生成`0-self`之间的`CountableRange<Int>`
    /// - Returns: `CountableRange<Int>`
    func toRange() -> CountableRange<Int> {
        let n = base as! Int
        return 0 ..< n
    }
}

// MARK: - 判断
public extension SaberExt where Base: BinaryInteger {
    /// 是否是奇数
    var isOdd: Bool {
        return base % 2 != 0
    }

    /// 是否是偶数
    var isEven: Bool {
        return base % 2 == 0
    }

    /// 是否是正数
    var isPositive: Bool {
        return base > 0
    }

    /// 是否是负数
    var isNegative: Bool {
        return base < 0
    }

    /// 当前数值是否是素数
    var isPrime: Bool {
        if base == 2 { return true }
        guard base > 1, base % 2 != 0 else { return false }
        let basic = Int(sqrt(toDouble()))
        for _ in Swift.stride(from: 3, through: basic, by: 2) where Int(base) % toInt() == 0 {
            return false
        }
        return true
    }
}

// MARK: - 日期/时间
public extension SaberExt where Base: BinaryInteger {
    /// `Int`时间戳转日期对象
    /// - Parameter isUnix:是否是`Unix`时间戳格式(默认`true`)
    /// - Returns:Date
    func toDate(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(toDouble() / (isUnix ? 1.0 : 1000.0)))
    }

    /// `Int`时间戳转日期字符串
    /// - Parameters:
    ///   - dateFormat:日期格式化样式
    ///   - isUnix:是否是`Unix`时间戳格式(默认`true`)
    /// - Returns:表示日期的字符串
    func toDateString(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss", isUnix: Bool = true) -> String {
        // 如果时间戳为毫秒需要除以
        var serverTimeStamp = TimeInterval(base)
        if !isUnix {
            serverTimeStamp /= 1000.0
        }
        let date = Date(timeIntervalSince1970: serverTimeStamp)

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

        return formatter.string(from: date)
    }

    /// `时间戳`与`当前时间`的`时间差`
    /// - Parameter format:格式化样式`yyyy-MM-dd HH:mm:ss`
    /// - Returns:日期字符串
    func toNowDistance(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeInterval: toDouble(), since: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// `时间戳`格式化`指定日期格式`字符串
    /// - Parameter format: `yyyy-MM-dd HH:mm:ss`
    /// - Returns: 日期字符串
    func format(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let time = toDouble() - 3600 * 8
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    /// `Int`时间戳转表示日期的字符串(`刚刚/x分钟前`)
    /// - Parameter isUnix:是否是`Unix`时间戳格式(默认`true`)
    /// - Returns:表示日期的字符串
    func timeline(isUnix: Bool = true) -> String {
        // 获取当前的时间戳
        let currentTimeStamp = Date().timeIntervalSince1970
        // 服务器时间戳(如果是毫秒 要除以1000)
        var serverTimeStamp = TimeInterval(base)
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
