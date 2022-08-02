import CoreGraphics
import Foundation

public extension BinaryFloatingPoint {
    /// Int
    var int: Int {
        return Int(self)
    }
    
    /// UInt
    var uInt: UInt {
        return UInt(self)
    }
    
    /// Int64
    var int64: Int64 {
        return Int64(self)
    }
    
    /// Int64
    var uInt64: UInt64 {
        return UInt64(self)
    }
    
    /// Float
    var float: Float {
        return Float(self)
    }
    
    /// Double
    var double: Double {
        return Double(self)
    }
    
    /// CGFloat
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    /// 四舍五入转Int
    var lround: Int {
        return Darwin.lround(Double(self))
    }
    
    /// NSNumber
    var nsNumber: NSNumber {
        return NSNumber(value: self.double)
    }
    
    /// NSDecimalNumber
    var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: self.double)
    }
    
    /// String
    var string: String {
        return String(self.double)
    }
    
    /// 宽高相同的CGSize
    var cgSize: CGSize {
        return CGSize(width: self.cgFloat, height: self.cgFloat)
    }
    
    /// 宽高相同的CGPoint
    var cgPoint: CGPoint {
        return CGPoint(x: self.cgFloat, y: self.cgFloat)
    }
    
    /// 角度转弧度
    var degrees2radians: Double {
        return Double.pi * self.double / 180.0
    }
    
    /// 弧度转角度
    var radians2degrees: Double {
        return self.double * 180 / Double.pi
    }
    
    /// 是否为正数
    var isPositive: Bool {
        return self > 0
    }
    
    /// 是否为负数
    var isNegative: Bool {
        return self < 0
    }
    
    /// 绝对值
    var abs: Self {
        return Swift.abs(self)
    }
    
    /// 向上取整
    var ceil: Self {
        return Foundation.ceil(self)
    }
    
    /// 向下取整
    var floor: Self {
        return Foundation.floor(self)
    }
    
    /// 时间(单位:秒)长度转换成00'00"格式(分'秒")
    var durationText: String {
        let minute = int / 60
        let second = int % 60
        return "\(String(format: "%02d", minute))'\(String(format: "%02d", second))\""
    }
}

// MARK: - 方法
public extension BinaryFloatingPoint {
    /// 四舍五入到小数点后某一位
    /// - Parameter places: 指定位数
    /// - Returns: 四舍五入后的结果
    func round(_ places: Int) -> Self {
        let divisor = pow(10.0, places.double)
        return Self((self.double * divisor).rounded() / divisor)
    }
    
    /// 返回具有指定小数位数和舍入规则的舍入值.如果`places`为负数,小数部分则将使用'0'
    ///
    ///     let num = 3.1415927
    ///     num.rounded(numberOfDecimalPlaces: 3, rule: .up) -> 3.142
    ///     num.rounded(numberOfDecimalPlaces: 3, rule: .down) -> 3.141
    ///     num.rounded(numberOfDecimalPlaces: 2, rule: .awayFromZero) -> 3.15
    ///     num.rounded(numberOfDecimalPlaces: 4, rule: .towardZero) -> 3.1415
    ///     num.rounded(numberOfDecimalPlaces: -1, rule: .toNearestOrEven) -> 3
    /// - Parameters:
    ///   - places: 预期的小数位数
    ///   - rule: 要使用的舍入规则
    /// - Returns: 四舍五入的值
    func rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(max(0, places))))
        return (self * factor).rounded(rule) / factor
    }
    
    /// 截断到小数点后某一位
    /// - Parameter places: 指定位数
    /// - Returns: 截断后的结果
    func truncate(places: Int) -> Self {
        let divisor = pow(10.0, places.double)
        return Self(self.double * divisor / divisor)
    }
    
    /// 时间戳与当前时间的时间差
    /// - Parameter format: 格式化样式`yyyy-MM-dd HH:mm:ss`
    /// - Returns: 日期字符串
    func delta(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeInterval: self.double, since: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    /// 时间戳格式化为指定日期字符串
    /// - Parameters format: 格式化 yyyy-MM-dd HH:mm:ss
    /// - Returns: 日期字符串
    func format(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let time = self - 3600 * 8
        let date = Date(timeIntervalSince1970: time.double)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
