import SceneKit
import UIKit

// MARK: - 属性
public extension SCNVector3 {
    /// 返回向量分量的绝对值
    ///
    ///           SCNVector3(2, -3, -6).abs -> SCNVector3(2, 3, 6)
    ///
    var absolute: SCNVector3 {
        return SCNVector3(abs(x), abs(y), abs(z))
    }

    /// 返回向量的长度
    ///
    ///           SCNVector3(2, 3, 6).length -> 7
    ///
    var length: Float {
        return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }

    /// 返回单位或规格化向量,其'length=1'
    ///
    ///     SCNVector3(2, 3, 6).normalized  -> SCNVector3(2/7, 3/7, 6/7)
    ///
    var normalized: SCNVector3 {
        let length = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
        return SCNVector3(x / length, y / length, z / length)
    }
}

// MARK: - 运算符
public extension SCNVector3 {
    /// 求和
    ///
    ///     SCNVector3(10, 10, 10) + SCNVector3(10, 20, -30) -> SCNVector3(20, 30, -20)
    ///
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns: 结果
    static func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    /// 求和(结果赋值给左值)
    ///
    ///     SCNVector3(10, 10, 10) += SCNVector3(10, 20, -30) -> SCNVector3(20, 30, -20)
    ///
    /// - Parameters:
    ///   - lhs: 左值self
    ///   - rhs: 右值
    static func += (lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    /// 求差
    ///
    ///     SCNVector3(10, 10, 10) - SCNVector3(10, 20, -30) -> SCNVector3(0, -10, 40)
    ///
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns: 结果
    static func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    /// 求差(结果赋值给左值)
    ///
    ///     SCNVector3(10, 10, 10) -= SCNVector3(10, 20, -30) -> SCNVector3(0, -10, 40)
    ///
    /// - Parameters:
    ///   - lhs: 左值self
    ///   - rhs: 右值
    static func -= (lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }

    /// 求SCNVector3和标量的积
    ///
    ///     SCNVector3(10, 20, -30) * 3 -> SCNVector3(30, 60, -90)
    ///
    /// - Parameters:
    ///   - vector: SCNVector3
    ///   - scalar: 标量
    /// - Returns: 结果
    static func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }

    /// 求SCNVector3和标量的积(结果赋值给左值)
    ///
    ///     SCNVector3(10, 20, -30) *= 3 -> SCNVector3(30, 60, -90)
    ///
    /// - Parameters:
    ///   - vector: SCNVector3
    ///   - scalar: 标量
    /// - Returns: 结果
    static func *= (vector: inout SCNVector3, scalar: Float) {
        vector.x *= scalar
        vector.y *= scalar
        vector.z *= scalar
    }

    /// 求标量和SCNVector3的积
    ///
    ///     3 * SCNVector3(10, 20, -30) -> SCNVector3(30, 60, -90)
    ///
    /// - Parameters:
    ///   - scalar: 标量
    ///   - vector: SCNVector3
    /// - Returns: 结果
    static func * (scalar: Float, vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }

    /// 求SCNVector3和标量的商
    ///
    ///     SCNVector3(10, 20, -30) / 3 -> SCNVector3(3/10, 0.15, -30)
    ///
    /// - Parameters:
    ///   - vector: SCNVector3
    ///   - scalar: 标量
    /// - Returns: 结果
    static func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }

    /// 求标量和SCNVector3的商
    ///
    ///     SCNVector3(10, 20, -30) /= 3 -> SCNVector3(3/10, 0.15, -30)
    ///
    /// - Parameters:
    ///   - vector: SCNVector3
    ///   - scalar: 标量
    /// - Returns: 结果
    static func /= (vector: inout SCNVector3, scalar: Float) {
        vector = SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
}
