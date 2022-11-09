import CoreGraphics
import Foundation

// MARK: - 属性
public extension CGFloat {
    /// `CGFloat`转`Int`
    var int: Int {
        return Int(self)
    }

    /// `CGFloat`转`Int64`
    var int64: Int64 {
        return Int64(self)
    }

    /// `CGFloat`转`Float`
    var float: Float {
        return Float(self)
    }

    /// `CGFloat`转`Double`
    var double: Double {
        return Double(self)
    }

    /// `CGFloat`转`NSNumber`
    var nsNumber: NSNumber {
        return NSNumber(value: double)
    }

    /// `CGFloat`转`String`
    var string: String {
        return String(double)
    }

    /// 绝对值
    var abs: CGFloat {
        return Swift.abs(self)
    }

    /// 向上取整
    var ceil: CGFloat {
        return Foundation.ceil(self)
    }

    /// 向下取整
    var floor: CGFloat {
        return Foundation.floor(self)
    }

    /// 是否是正数
    var isPositive: Bool {
        return self > 0
    }

    /// 是否是负数
    var isNegative: Bool {
        return self < 0
    }

    /// 宽高相同的`CGSize`
    var cgSize: CGSize {
        return CGSize(width: self, height: self)
    }

    /// 宽高相同的`CGPoint`
    var cgPoint: CGPoint {
        return CGPoint(x: self, y: self)
    }
}

// MARK: - 方法
public extension CGFloat {
    /// 角度转弧度
    func angle2radian() -> Self {
        return self * .pi / 180.0
    }

    /// 弧度转角度
    func radian2angle() -> Self {
        return self * 180.0 / Double.pi
    }

    /// 四舍五入到小数点后某一位
    /// - Parameter places:指定位数
    /// - Returns:四舍五入后的结果
    func round(_ places: Int) -> Self {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
