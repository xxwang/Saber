import CoreGraphics
import Foundation

// MARK: - 属性
public extension BinaryFloatingPoint {
    /// 转Int
    var int: Int {
        return Int(self)
    }

    /// 转UInt
    var uInt: UInt {
        return UInt(self)
    }

    /// 转Int64
    var int64: Int64 {
        return Int64(self)
    }

    /// 转UInt64
    var uInt64: UInt64 {
        return UInt64(self)
    }

    /// 转Float
    var float: Float {
        return Float(self)
    }

    /// 转Double
    var double: Double {
        return Double(self)
    }

    /// 转CGFloat
    var cgFloat: CGFloat {
        return CGFloat(self)
    }

    /// 四舍五入转Int
    var lround: Int {
        return Darwin.lround(Double(self))
    }

    /// 转NSNumber
    var nsNumber: NSNumber {
        return NSNumber(value: double)
    }

    /// 转NSDecimalNumber
    var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: double)
    }

    /// 转Decimal
    var decimal: Decimal {
        return decimalNumber.decimalValue
    }

    /// 转String
    var string: String {
        return String(double)
    }

    /// 生成宽高相同的CGSize
    var size: CGSize {
        return CGSize(width: cgFloat, height: cgFloat)
    }

    /// 生成(x,y)相同的CGPoint
    var point: CGPoint {
        return CGPoint(x: cgFloat, y: cgFloat)
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
}

// MARK: - 方法
public extension BinaryFloatingPoint {
    /// 角度转弧度
    func angle2radian() -> Double {
        return double * .pi / 180.0
    }

    /// 弧度转角度
    func radian2angle() -> Double {
        return double * 180.0 / .pi
    }

    /// 截断到小数点后某一位
    /// - Parameter places: 指定位数
    /// - Returns: 截断后的结果
    func truncate(places: Int) -> Self {
        let divisor = pow(10.0, places.double)
        return Self(double * divisor / divisor)
    }

    /// 四舍五入到小数点后某一位
    /// - Parameter places: 指定位数
    /// - Returns: 四舍五入后的结果
    func round(_ places: Int) -> Self {
        let divisor = pow(10.0, places.double)
        return Self((double * divisor).rounded() / divisor)
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

    /// 转时间长度字符串(单位:秒)长度转换成00'00"格式(分'秒")
    func duration() -> String {
        let minute = int / 60
        let second = int % 60
        return "\(String(format: "%02d", minute))'\(String(format: "%02d", second))\""
    }
}
