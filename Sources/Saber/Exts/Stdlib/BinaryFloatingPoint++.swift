import CoreGraphics
import Foundation

public extension BinaryFloatingPoint {
    var sb: SaberExt<Self> { SaberExt(self) }
    static var sb: SaberExt<Self>.Type { SaberExt<Self>.self }
}

// MARK: - 类型转换
public extension SaberExt where Base: BinaryFloatingPoint {
    /// 转`Int`
    /// - Returns: `Int`
    func toInt() -> Int {
        return Int(base)
    }

    /// 转`Int64`
    /// - Returns: `Int64`
    func toInt64() -> Int64 {
        return Int64(base)
    }

    /// 转`UInt`
    /// - Returns: `UInt`
    func toUInt() -> UInt {
        return UInt(base)
    }

    /// 转`UInt64`
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

    /// 转`NSNumber`
    /// - Returns: `NSNumber`
    func toNSNumber() -> NSNumber {
        return NSNumber(value: toDouble())
    }

    /// 转`NSDecimalNumber`
    /// - Returns: `NSDecimalNumber`
    func toDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: toDouble())
    }

    /// 转`Decimal`
    /// - Returns: `Decimal`
    func toDecimal() -> Decimal {
        return toDecimalNumber().decimalValue
    }

    /// 转`String`
    /// - Returns: `String`
    func toString() -> String {
        return String(toDouble())
    }

    /// 生成宽高相同的`CGSize`
    /// - Returns: `CGSize`
    func toSize() -> CGSize {
        return CGSize(width: toCGFloat(), height: toCGFloat())
    }

    /// 生成`(x,y)`相同的`CGPoint`
    /// - Returns: `CGPoint`
    func toPoint() -> CGPoint {
        return CGPoint(x: toCGFloat(), y: toCGFloat())
    }
}

// MARK: - 方法
public extension SaberExt where Base: BinaryFloatingPoint {
    /// `角度`转`弧度`(`假设当前值为角度`)
    /// - Returns: `Double`弧度
    func toRadian() -> Double {
        return toDouble() * .pi / 180.0
    }

    /// `弧度`转`角度`(`假设当前值为弧度`)
    /// - Returns: `Double`角度
    func toAngle() -> Double {
        return toDouble() * 180.0 / .pi
    }

    /// 取`绝对值`
    /// - Returns: `绝对值`
    func abs() -> Base {
        return Swift.abs(base)
    }

    /// 向上取整
    /// - Returns: 取整结果
    func ceil() -> Base {
        return Foundation.ceil(base)
    }

    /// 向下取整
    /// - Returns: 取整结果
    func floor() -> Base {
        return Foundation.floor(base)
    }

    /// 四舍五入转`Int`
    /// - Returns: `Int`
    func lround() -> Int {
        return Darwin.lround(Double(base))
    }

    /// 截断到小数点后某一位
    /// - Parameter places:指定位数
    /// - Returns:截断后的结果
    func truncate(places: Int) -> Base {
        let divisor = pow(10.0, places.sb.toDouble())
        return Base(toDouble() * divisor / divisor)
    }

    /// 四舍五入到小数点后某一位
    /// - Parameter places:指定位数
    /// - Returns:四舍五入后的结果
    func round(_ places: Int) -> Base {
        let divisor = pow(10.0, places.sb.toDouble())
        return Base((toDouble() * divisor).rounded() / divisor)
    }

    /// 返回具有指定小数位数和舍入规则的舍入值.如果`places`为负数,小数部分则将使用'0'
    /// - Parameters:
    ///   - places:预期的小数位数
    ///   - rule:要使用的舍入规则
    /// - Returns:四舍五入的值
    func rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Base {
        let factor = Base(pow(10.0, Double(max(0, places))))
        return (base * factor).rounded(rule) / factor
    }

    /// 转时间长度字符串(单位:`秒`)长度转换成`00'00`格式(`分'秒"`)
    /// - Returns: 时长的`String`表示
    func duration() -> String {
        let minute = toInt() / 60
        let second = toInt() % 60
        return "\(String(format: "%02d", minute))'\(String(format: "%02d", second))\""
    }
}

// MARK: - 判断
public extension SaberExt where Base: BinaryFloatingPoint {
    /// 是否为正数
    var isPositive: Bool {
        return base > 0
    }

    /// 是否为负数
    var isNegative: Bool {
        return base < 0
    }
}

// MARK: - 屏幕适配
public extension SaberExt where Base: BinaryFloatingPoint {
    /// 适配宽度
    var w: CGFloat { return SizeAdapter.shared.adaptingWidth(value: self) }

    /// 适配高度
    var h: CGFloat { return SizeAdapter.shared.adaptingHeight(value: self) }

    /// 最大适配(特殊情况)
    var max: CGFloat { return SizeAdapter.shared.adaptingMax(value: self) }

    /// 最小适配(特殊情况)
    var min: CGFloat { return SizeAdapter.shared.adaptingMin(value: self) }

    /// 字体大小配置
    var font: CGFloat { return SizeAdapter.shared.adaptingFont(value: self) }
}
