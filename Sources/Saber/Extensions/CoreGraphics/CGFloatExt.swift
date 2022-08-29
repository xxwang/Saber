import CoreGraphics
import Foundation

    // MARK: - 属性
public extension CGFloat {
        /// Int
    var int: Int {
        return Int(self)
    }
    
        /// Int64
    var int64: Int64 {
        return Int64(self)
    }
    
        /// Float
    var float: Float {
        return Float(self)
    }
    
        /// Double
    var double: Double {
        return Double(self)
    }
    
        /// NSNumber
    var nsNumber: NSNumber {
        return NSNumber(value: double)
    }
    
        /// String
    var string: String {
        return String(double)
    }
    
        /// 角转弧度
    var degreesAsRadians: CGFloat {
        return (Double.pi * self) / 180.0
    }
    
        /// 弧度转角
    var radiansAsDegrees: CGFloat {
        return (self * 180.0) / Double.pi
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
    
        /// 宽高相同的CGSize
    var cgSize: CGSize {
        return CGSize(width: self, height: self)
    }
    
        /// 宽高相同的CGPoint
    var cgPoint: CGPoint {
        return CGPoint(x: self, y: self)
    }
}

    // MARK: - 方法
public extension CGFloat {
        /// 四舍五入到小数点后某一位
        /// - Parameter places: 指定位数
        /// - Returns: 四舍五入后的结果
    func roundTo(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
