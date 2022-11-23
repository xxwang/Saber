import CoreGraphics
import Foundation

extension CGSize: Saberable {}

// MARK: - 属性
public extension SaberEx where Base == CGSize {
    /// 获取`宽高比`
    var aspectRatio: CGFloat {
        guard base.height != 0 else { return 0 }
        return base.width / base.height
    }

    /// 获取`宽高最大值`
    var maxDimension: CGFloat {
        return max(base.width, base.height)
    }

    /// 获取`宽高最小值`
    var minDimension: CGFloat {
        return min(base.width, base.height)
    }
}

// MARK: - 方法
public extension SaberEx where Base == CGSize {
    /// 以`size``最小``宽高比`缩放`CGSize`(不超过`size`)
    ///
    ///     let rect = CGSize(width:120, height:80)
    ///     let parentSize  = CGSize(width:100, height:50)
    ///     let newSize = rect.aspectFit(to:parentSize)
    ///     // newSize.width = 75 , newSize = 50
    /// - Parameter size: 边界`CGSize`
    /// - Returns: 缩放后的`CGSize`
    func aspectFit(to size: CGSize) -> CGSize {
        let minRatio = min(size.width / base.width, size.height / base.height)
        return CGSize(width: base.width * minRatio, height: base.height * minRatio)
    }

    /// 以`size``最大``宽高比`缩放`CGSize`(不超过`size`)
    ///
    ///     let size = CGSize(width:20, height:120)
    ///     let parentSize  = CGSize(width:100, height:60)
    ///     let newSize = size.aspectFit(to:parentSize)
    ///     // newSize.width = 100 , newSize = 60
    /// - Parameter size: 边界`CGSize`
    /// - Returns: 缩放后的`CGSize`
    func aspectFill(to size: CGSize) -> CGSize {
        let maxRatio = max(size.width / base.width, size.height / base.height)
        let aWidth = min(base.width * maxRatio, size.width)
        let aHeight = min(base.height * maxRatio, size.height)
        return CGSize(width: aWidth, height: aHeight)
    }
}

// MARK: - 构造方法
public extension CGSize {
    /// 构造一个`宽高一致`的`CGSize`
    /// - Parameter value: 宽高
    init(value: CGFloat) {
        self.init(width: value, height: value)
    }
}

// MARK: - 运算符
public extension CGSize {
    /// 求两个`CGSize`的`和`
    /// - Parameters:
    ///   - lhs: 被加`CGSize`
    ///   - rhs: 加数`CGSize`
    /// - Returns: `CGSize`
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    /// 求`CGSize`与`元组`的`和`
    /// - Parameters:
    ///   - lhs: 被加`CGSize`
    ///   - tuple: 加数`tuple`
    /// - Returns: `CGSize`
    static func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
    }

    /// 求两个`CGSize`的`和`并赋值给被加`CGSize`
    /// - Parameters:
    ///   - lhs: 被加`CGSize`
    ///   - rhs: 加数`CGSize`
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    /// 求`CGSize`与`元组`的`和`并赋值给被加`CGSize`
    /// - Parameters:
    ///   - lhs: 被加`CGSize`
    ///   - tuple: 加数`tuple`
    static func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width += tuple.width
        lhs.height += tuple.height
    }

    /// 求两个`CGSize`的`差`
    /// - Parameters:
    ///   - lhs: 被减`CGSize`
    ///   - rhs: 减数`CGSize`
    /// - Returns: `CGSize`
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    /// 求`CGSize`与`元组`的`差`
    /// - Parameters:
    ///   - lhs: 被减`CGSize`
    ///   - tuple: 减数`tuple`
    /// - Returns: `CGSize`
    static func - (lhs: CGSize, tuple: (width: CGFloat, heoght: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.heoght)
    }

    /// 求两个`CGSize`的`差`并赋值给被减`CGSize`
    /// - Parameters:
    ///   - lhs:被减`CGSize`
    ///   - rhs:减数`CGSize`
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    /// 求`CGSize`与`元组`的`差`并赋值给被减`CGSize`
    /// - Parameters:
    ///   - lhs: 被减`CGSize`
    ///   - tuple: 减数`tuple`
    static func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width -= tuple.width
        lhs.height -= tuple.height
    }

    /// 求两个`CGSize`的`积`
    /// - Parameters:
    ///   - lhs:被乘`CGSize`
    ///   - rhs:乘数`CGSize`
    /// - Returns:`CGSize`
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    /// 两个`CGSize`的`积`并赋值给被乘`CGSize`
    /// - Parameters:
    ///   - lhs: 被乘`CGSize`
    ///   - rhs: 乘数`CGSize`
    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    /// 求`CGSize`与`标量`的`积`
    /// - Parameters:
    ///   - lhs:被乘`CGSize`
    ///   - scalar:乘数`标量`
    /// - Returns:`CGSize`
    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    /// 求`标量`与`CGSize`的`积`
    /// - Parameters:
    ///   - scalar:被乘`标量`
    ///   - rhs:乘数`CGSize`
    /// - Returns:`CGSize`
    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        return CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
    }

    /// 求`CGSize`与`标量`的`积`并赋值给被乘`CGSize`
    /// - Parameters:
    ///   - lhs: 被乘`CGSize`
    ///   - scalar: 乘数`标量`
    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }
}
