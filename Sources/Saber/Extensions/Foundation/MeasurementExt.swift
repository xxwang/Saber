import Foundation

// MARK: - 静态方法(UnitAngle)
public extension Measurement where UnitType == UnitAngle {
    /// 以度数为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func degrees(_ value: Double) -> Measurement {
        return Measurement(value: value, unit: .degrees)
    }

    /// 以弧分为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func arcMinutes(_ value: Double) -> Measurement {
        return Measurement(value: value, unit: .arcMinutes)
    }

    /// 以弧秒为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func arcSeconds(_ value: Double) -> Measurement {
        return Measurement(value: value, unit: .arcSeconds)
    }

    /// 以弧度为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func radians(_ value: Double) -> Measurement {
        return Measurement(value: value, unit: .radians)
    }

    /// 以梯度为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func gradians(_ value: Double) -> Measurement {
        return Measurement(value: value, unit: .gradians)
    }

    /// 以转数为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func revolutions(_ value: Double) -> Measurement {
        return Measurement(value: value, unit: .revolutions)
    }
}
