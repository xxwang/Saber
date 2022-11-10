import CoreGraphics
import Foundation

// MARK: - 属性
public extension CGSize {
    /// 获取宽高比
    var aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }

    /// 获取宽高最大值
    var maxDimension: CGFloat {
        return max(width, height)
    }

    /// 获取宽高最小值
    var minDimension: CGFloat {
        return min(width, height)
    }
}

// MARK: - 方法
public extension CGSize {
    /// 构造一个宽高一致的`CGSize`
    /// - Parameter value:宽/高
    init(value: CGFloat) {
        self.init(width: value, height: value)
    }
}

// MARK: - 方法
public extension CGSize {
    /// 按`boundingSize`最小宽高比缩放`CGSize`(不超过边界)
    ///
    ///     let rect = CGSize(width:120, height:80)
    ///     let parentRect  = CGSize(width:100, height:50)
    ///     let newRect = rect.aspectFit(to:parentRect)
    ///     // newRect.width = 75 , newRect = 50
    /// - Parameter boundingSize: 边界`CGSize`
    /// - Returns: 缩放后的`CGSize`
    func aspectFit(to boundingSize: CGSize) -> CGSize {
        let minRatio = min(boundingSize.width / width, boundingSize.height / height)
        return CGSize(width: width * minRatio, height: height * minRatio)
    }

    /// 按`boundingSize`最大宽高比缩放`CGSize`(不超过边界)
    ///
    ///     let rect = CGSize(width:20, height:120)
    ///     let parentRect  = CGSize(width:100, height:60)
    ///     let newRect = rect.aspectFit(to:parentRect)
    ///     // newRect.width = 100 , newRect = 60
    /// - Parameter boundingSize: 边界`CGSize`
    /// - Returns:缩放后的`CGSize`
    func aspectFill(to boundingSize: CGSize) -> CGSize {
        let minRatio = max(boundingSize.width / width, boundingSize.height / height)
        let aWidth = min(width * minRatio, boundingSize.width)
        let aHeight = min(height * minRatio, boundingSize.height)
        return CGSize(width: aWidth, height: aHeight)
    }
}

// MARK: - 运算符
public extension CGSize {
    /// 求两个`CGSize`的和
    ///
    ///     let sizeA = CGSize(width:5, height:10)
    ///     let sizeB = CGSize(width:3, height:4)
    ///     let result = sizeA + sizeB
    ///     // result = CGSize(width:8, height:14)
    /// - Parameters:
    ///   - lhs: 被加数
    ///   - rhs: 加数
    /// - Returns:和
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    /// 求`CGSize`与元组的和
    ///
    ///     let sizeA = CGSize(width:5, height:10)
    ///     let result = sizeA + (5, 4)
    ///     // result = CGSize(width:10, height:14)
    /// - Parameters:
    ///   - lhs:`CGSize`
    ///   - tuple:要相加的元组`(width:CGFloat, height:CGFloat)`
    /// - Returns:和
    static func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
    }

    /// 向`self(CGSize)`追加一个`CGSize`
    ///
    ///     var sizeA = CGSize(width:5, height:10)
    ///     let sizeB = CGSize(width:3, height:4)
    ///     sizeA += sizeB
    ///     // sizeA = CGPoint(width:8, height:14)
    /// - Parameters:
    ///   - lhs:`self(CGSize)`
    ///   - rhs:要追加的`CGSize`
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    /// 向`self(CGSize)`追加一个元组
    ///
    ///     var sizeA = CGSize(width:5, height:10)
    ///     sizeA += (3, 4)
    ///     // result = CGSize(width:8, height:14)
    /// - Parameters:
    ///   - lhs:`self(CGSize)`
    ///   - tuple:要追加的元组
    static func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width += tuple.width
        lhs.height += tuple.height
    }

    /// 求两个`CGSize`的差
    ///
    ///     let sizeA = CGSize(width:5, height:10)
    ///     let sizeB = CGSize(width:3, height:4)
    ///     let result = sizeA - sizeB
    ///     // result = CGSize(width:2, height:6)
    /// - Parameters:
    ///   - lhs:被减`CGSize`
    ///   - rhs:减数`CGSize`
    /// - Returns:差
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    /// 求CGSize与元组的差
    ///
    ///     let sizeA = CGSize(width:5, height:10)
    ///     let result = sizeA - (3, 2)
    ///     // result = CGSize(width:2, height:8)
    /// - Parameters:
    ///   - lhs:被减`CGSize`
    ///   - tuple:减数元组
    /// - Returns:差
    static func - (lhs: CGSize, tuple: (width: CGFloat, heoght: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.heoght)
    }

    /// 从`self(CGSize)`中减去一个`CGSize`
    ///
    ///     var sizeA = CGSize(width:5, height:10)
    ///     let sizeB = CGSize(width:3, height:4)
    ///     sizeA -= sizeB
    ///     // sizeA = CGPoint(width:2, height:6)
    /// - Parameters:
    ///   - lhs:被减`CGSize`
    ///   - rhs:减数`CGSize`
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    /// 从`self(CGSize)`中减去一个元组
    ///
    ///     var sizeA = CGSize(width:5, height:10)
    ///     sizeA -= (2, 4)
    ///     // result = CGSize(width:3, height:6)
    /// - Parameters:
    ///   - lhs:被减`CGSize`
    ///   - tuple:减数元组
    static func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width -= tuple.width
        lhs.height -= tuple.height
    }

    /// 求两个`CGSize`的积
    ///
    ///     let sizeA = CGSize(width:5, height:10)
    ///     let sizeB = CGSize(width:3, height:4)
    ///     let result = sizeA * sizeB
    ///     // result = CGSize(width:15, height:40)
    /// - Parameters:
    ///   - lhs:被乘数`CGSize`
    ///   - rhs:乘数`CGSize`
    /// - Returns:积
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    /// 求`CGSize`与一个标量的积
    ///
    ///     let sizeA = CGSize(width:5, height:10)
    ///     let result = sizeA * 5
    ///     // result = CGSize(width:25, height:50)
    /// - Parameters:
    ///   - lhs:被乘数`CGSize`
    ///   - scalar:乘数标量
    /// - Returns:积
    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    /// 求一个标量与`CGSize`的积
    ///
    ///     let sizeA = CGSize(width:5, height:10)
    ///     let result = 5 * sizeA
    ///     // result = CGSize(width:25, height:50)
    /// - Parameters:
    ///   - scalar:被乘数标量
    ///   - rhs:乘数`CGSize`
    /// - Returns:积
    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        return CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
    }

    /// 求两个`CGSize`的积(赋值给被乘数)
    ///
    ///     var sizeA = CGSize(width:5, height:10)
    ///     let sizeB = CGSize(width:3, height:4)
    ///     sizeA *= sizeB
    ///     // result = CGSize(width:15, height:40)
    /// - Parameters:
    ///   - lhs:被乘数`CGSize`
    ///   - rhs:乘数`CGSize`
    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    /// 求`CGSize`与一个标量的积(赋值给被乘数)
    ///
    ///     var sizeA = CGSize(width:5, height:10)
    ///     sizeA *= 3
    ///     // result = CGSize(width:15, height:30)
    /// - Parameters:
    ///   - lhs:被乘数`CGSize`
    ///   - scalar:标量
    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }
}
