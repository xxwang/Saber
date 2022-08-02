import CoreGraphics
import Foundation

    // MARK: - 属性
public extension BinaryInteger {
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
    
        /// NSNumber
    var nsNumber: NSNumber {
        guard let n = self as? Int else {
            return NSNumber(value: 0)
        }
        return NSNumber(value: n)
    }
    
        /// NSDecimalNumber
    var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: self.double)
    }
    
        /// Character
    var character: Character? {
        guard let n = self as? Int,
              let scalar = UnicodeScalar(n)
        else {
            return nil
        }
        return Character(scalar)
    }
    
        /// String
    var string: String {
        return String(self)
    }
    
        /// 宽高相同的CGSize
    var cgSize: CGSize {
        guard let n = self as? Int else {
            return .zero
        }
        return CGSize(width: n, height: n)
    }
    
        /// 宽高相同的CGPoint
    var cgPoint: CGPoint {
        guard let n = self as? Int else {
            return .zero
        }
        return CGPoint(x: n, y: n)
    }
    
        /// 生成0-self之间的`CountableRange<Int>`
    var countableRange: CountableRange<Int> {
        let n = self as! Int
        return 0 ..< n
    }
    
        /// 角度转弧度
    var degrees2radians: Double {
        return Double.pi * Double(self) / 180.0
    }
    
        /// 弧度转角度
    var radians2degrees: Double {
        return Double(self) * 180 / Double.pi
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
    
        /// 数字转罗马数字(字符串)
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
    
        /// 转字节数组(UInt8数组)
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
}

    // MARK: - 构造方法
public extension BinaryInteger {
        /// 从字节数组创建BinaryInteger
        ///
        ///     var number = Int16(bytes: [0xFF, 0b1111_1101])
        ///     print(number!)
        ///     // prints "-3"
        /// - Parameters bytes: 表示整数值的字节数组
    init?(bytes: [UInt8]) {
        precondition(bytes.count <= MemoryLayout<Self>.size,
                     "Integer with a \(bytes.count) byte binary representation of '\(bytes.map { String($0, radix: 2) }.joined(separator: " "))' overflows when stored into a \(MemoryLayout<Self>.size) byte '\(Self.self)'")
        var value: Self = 0
        for byte in bytes {
            value <<= 8
            value |= Self(byte)
        }
        self.init(exactly: value)
    }
}

    // MARK: - 方法
public extension BinaryInteger {
        /// 四舍五入到最近数字
        /// - Parameter number: 舍入值
        /// - Returns: 结果数字
    func round(_ number: Self) -> Self {
        let result = Self(Darwin.round(self.double / number.double).int * number.int)
        return result
    }
}
