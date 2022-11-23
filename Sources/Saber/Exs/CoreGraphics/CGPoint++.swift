import CoreGraphics
import Foundation

extension CGPoint: Saberable {}

// MARK: - 方法
public extension SaberEx where Base == CGPoint {
    /// 计算两个`CGPoint`之间的`距离`
    /// - Parameter point: 要计算的结束点
    /// - Returns: `CGFloat`
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - base.x, 2) + pow(point.y - base.y, 2))
    }
}

// MARK: - 静态方法
public extension SaberEx where Base == CGPoint {
    /// 计算两个`CGPoint`之间的`距离`
    /// - Parameters:
    ///   - point1: 要计算的起始点
    ///   - point2: 要计算的结束点
    /// - Returns: `CGFloat`
    static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return point1.sb.distance(to: point2)
    }
}

// MARK: - 构造方法
public extension CGPoint {
    /// 构造一个`x,y`一致的`CGPoint`
    /// - Parameter value: 宽和高
    init(value: CGFloat) {
        self.init(x: value, y: value)
    }
}

// MARK: - 运算符
public extension CGPoint {
    /// 计算并返回两个`CGPoint`的`和`
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns: `CGPoint`
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    /// 计算两个`CGPoint`的`和`并`赋值`给`左侧`的`CGPoint`
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    /// 计算并返回两个`CGPoint`的`差`
    /// - Parameters:
    ///   - lhs: 被减数`CGPoint`
    ///   - rhs: 减数`CGPoint`
    /// - Returns: `CGPoint`
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    /// 计算并返回两个`CGPoint`的`差`并`赋值`给`左侧`的`CGPoint`
    /// - Parameters:
    ///   - lhs: 被减数`CGPoint`
    ///   - rhs: 减数`CGPoint`
    /// - Returns: `CGPoint`
    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    /// 求`CGPoint`和`标量`的`积`
    /// - Parameters:
    ///   - point: `CGPoint`
    ///   - scalar: `标量`
    /// - Returns: `CGPoint`
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    /// 求`CGPoint`和`标量`的`积`并`赋值`给`左侧`的`CGPoint`
    /// - Parameters:
    ///   - point: `CGPoint`
    ///   - scalar: `标量`
    /// - Returns: `CGPoint`
    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point.x *= scalar
        point.y *= scalar
    }

    /// 求`标量`和`CGPoint`的`积`
    /// - Parameters:
    ///   - scalar: `标量`
    ///   - point: `CGPoint`
    /// - Returns: `CGPoint`
    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
}
