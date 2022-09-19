import CoreGraphics
import Foundation

// MARK: - 属性
public extension SaberExt where Base: BinaryInteger {
    /// 转Int
    var int: Int {
        return Int(self.base)
    }
    
    /// 转UInt
    var uInt: UInt {
        return UInt(self.base)
    }
    
    /// 转Int64
    var int64: Int64 {
        return Int64(self.base)
    }
    
    /// 转Int64
    var uInt64: UInt64 {
        return UInt64(self.base)
    }
    
    /// 转Float
    var float: Float {
        return Float(self.base)
    }
    
    /// 转Double
    var double: Double {
        return Double(self.base)
    }
    
    /// 转CGFloat
    var cGFloat: CGFloat {
        return CGFloat(self.base)
    }
    
    /// 转NSNumber
    var nsNumber: NSNumber {
        guard let n = self.base as? Int else {
            return NSNumber(value: 0)
        }
        return NSNumber(value: n)
    }
    
    /// 转NSDecimalNumber
    var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: self.double)
    }
    
    /// 转Decimal
    var decimal: Decimal {
        return self.decimalNumber.decimalValue
    }
    
    /// 转Character
    var character: Character? {
        guard let n = self.base as? Int,
              let scalar = UnicodeScalar(n)
        else {
            return nil
        }
        return Character(scalar)
    }
    
    /// 转String
    var string: String {
        return String(self.base)
    }
    
    /// 生成宽高相同的CGSize
    var size: CGSize {
        guard let n = self.base as? Int else {
            return .zero
        }
        return CGSize(width: n, height: n)
    }
    
    /// 生成(x,y)相同的CGPoint
    var point: CGPoint {
        guard let n = self.base as? Int else {
            return .zero
        }
        return CGPoint(x: n, y: n)
    }
    
    /// 生成0-self之间的`CountableRange<Int>`
    var range: CountableRange
    <Int> {
        let n = self.base as! Int
        return 0 ..< n
    }
    
    /// 转字节数组(UInt8数组)
    ///
    ///     var number = Int16(-128)
    ///     print(number.bytes)
    ///     // prints "[255, 128]"
    ///
    var bytes: [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Base>.size)
        var value = self.base
        for _ in 0 ..< MemoryLayout<Base>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }
    
    /// 数字转罗马数字
    var romanNumeral: String? {
        guard self.base > 0 else {
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
    
    /// 是否是奇数
    var isOdd: Bool {
        return self.base % 2 != 0
    }
    
    /// 是否是偶数
    var isEven: Bool {
        return self.base % 2 == 0
    }
    
    /// 是否是正数
    var isPositive: Bool {
        return self.base > 0
    }
    
    /// 是否是负数
    var isNegative: Bool {
        return self.base < 0
    }

    /// 当前数值是否是素数
    var isPrime: Bool {
        if self.base == 2 { return true }
        guard self.base > 1, self.base % 2 != 0 else { return false }
        let basic = Int(sqrt(Double(self.base)))
        for int in Swift.stride(from: 3, through: basic, by: 2) where Int(self.base) % int == 0 {
            return false
        }
        return true
    }
}

// MARK: - 方法
public extension SaberExt where Base: BinaryInteger {
    /// 角度转弧度
    func angle2radian() -> Double {
        return self.double * .pi / 180.0
    }
    
    /// 弧度转角度
    func radian2angle() -> Double {
        return self.double * 180.0 / .pi
    }
}
