import CoreGraphics
import Foundation

// MARK: - 属性
public extension CGVector {
    /// 向量的旋转角度(弧度).角度的范围是-π到π；向右0点的角度.
    var angle: CGFloat {
        return atan2(dy, dx)
    }

    /// 向量的大小(长度)
    var magnitude: CGFloat {
        return sqrt((dx * dx) + (dy * dy))
    }
}

// MARK: - 构造方法
public extension CGVector {
    /// 创建具有给定大小和角度的向量
    ///
    ///     let vector = CGVector(angle: .pi, magnitude: 1)
    /// - Parameters:
    ///     - angle: 从正x轴逆时针旋转的角度(弧度)
    ///     - magnitude: 向量的长度
    ///
    init(angle: CGFloat, magnitude: CGFloat) {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

// MARK: - 运算符
public extension CGVector {
    /// 向量与标量相乘
    ///
    ///     let vector = CGVector(dx: 1, dy: 1)
    ///     let largerVector = vector * 2
    /// - Parameters:
    ///   - vector: 向量
    ///   - scalar: 标量
    /// - Returns: 按大小缩放的向量
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    /// 标量与向量相乘
    ///
    ///     let vector = CGVector(dx: 1, dy: 1)
    ///     let largerVector = 2 * vector
    /// - Parameters:
    ///   - scalar: 标量
    ///   - vector: 向量
    /// - Returns: 按大小缩放的向量
    static func * (scalar: CGFloat, vector: CGVector) -> CGVector {
        return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }

    /// 向量标量乘法的复合赋值运算符(将结果赋值给向量)
    ///
    ///     var vector = CGVector(dx: 1, dy: 1)
    ///     vector *= 2
    /// - Parameters:
    ///   - vector: 向量
    ///   - scalar: 标量
    static func *= (vector: inout CGVector, scalar: CGFloat) {
        vector.dx *= scalar
        vector.dy *= scalar
    }

    /// 求反向量.方向相反,但大小不变
    ///
    ///     let vector = CGVector(dx: 1, dy: 1)
    ///     let reversedVector = -vector
    /// - Parameters vector: 向量
    /// - Returns: 求反之后的向量
    static prefix func - (vector: CGVector) -> CGVector {
        return CGVector(dx: -vector.dx, dy: -vector.dy)
    }
}
