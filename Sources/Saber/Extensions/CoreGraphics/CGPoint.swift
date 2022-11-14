import CoreGraphics
import Foundation

// MARK: - 构造方法
public extension CGPoint {
    /// 构造一个`x,y`一致的`CGPoint`
    /// - Parameter value: 宽和高
    init(value: CGFloat) {
        self.init(x: value, y: value)
    }
}

// MARK: - 静态方法
public extension CGPoint {
    /// 两点之间的距离
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     let point2 = CGPoint(x:30, y:30)
    ///     let distance = CGPoint.distance(from:point2, to:point1)
    ///     // distance = 28.28
    /// - Parameters:
    ///   - point1:参与计算的起始点
    ///   - point2:参与计算的结束点
    /// - Returns:两点之间的距离
    static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }
}

// MARK: - 方法
public extension CGPoint {
    /// 与另一点之间的距离
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     let point2 = CGPoint(x:30, y:30)
    ///     let distance = point1.distance(from:point2)
    ///     // distance = 28.28
    /// - Parameters point:参与比较的点
    /// - Returns:距离
    func distance(from point: CGPoint) -> CGFloat {
        return CGPoint.distance(from: self, to: point)
    }
}

// MARK: - 运算符
public extension CGPoint {
    /// 求两个点的和
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     let point2 = CGPoint(x:30, y:30)
    ///     let point = point1 + point2
    ///     // point = CGPoint(x:40, y:40)
    /// - Parameters:
    ///   - lhs:点1
    ///   - rhs:点2
    /// - Returns:结果
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    /// 向`self`添加另一个点
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     let point2 = CGPoint(x:30, y:30)
    ///     point1 += point2
    ///     // point1 = CGPoint(x:40, y:40)
    /// - Parameters:
    ///   - lhs:self
    ///   - rhs:要添加的点
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    /// 求两个点的差
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     let point2 = CGPoint(x:30, y:30)
    ///     let point = point1 - point2
    ///     // point = CGPoint(x:-20, y:-20)
    /// - Parameters:
    ///   - lhs:被减点
    ///   - rhs:要减去的点
    /// - Returns:结果
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    /// 从`self`减去一个点
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     let point2 = CGPoint(x:30, y:30)
    ///     point1 -= point2
    ///     // point1 = CGPoint(x:-20, y:-20)
    /// - Parameters:
    ///   - lhs:被减点
    ///   - rhs:要减去的点
    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    /// 求点和标量的积
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     let scalar = point1 * 5
    ///     // scalar = CGPoint(x:50, y:50)
    /// - Parameters:
    ///   - point:点
    ///   - scalar:标量
    /// - Returns:结果
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    /// 求点和标量的积(并赋值给当前点)
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     point *= 5
    ///     // point1 = CGPoint(x:50, y:50)
    /// - Parameters:
    ///   - point:self
    ///   - scalar:标量
    /// - Returns:结果
    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point.x *= scalar
        point.y *= scalar
    }

    /// 求标量与点的积
    ///
    ///     let point1 = CGPoint(x:10, y:10)
    ///     let scalar = 5 * point1
    ///     // scalar = CGPoint(x:50, y:50)
    /// - Parameters:
    ///   - scalar:标量
    ///   - point:点
    /// - Returns:结果
    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
}
