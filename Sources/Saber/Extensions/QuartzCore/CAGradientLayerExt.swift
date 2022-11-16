import QuartzCore
import UIKit

// MARK: - 线性渐变方向枚举
public enum CMGradientDirection {
    /// 水平从左到右
    case horizontal
    /// 垂直从上到下
    case vertical
    /// 左上到右下
    case leftOblique
    /// 右上到左下
    case rightOblique
    /// 自定义
    case customize(CGPoint, CGPoint)
}

// MARK: - 渐变方向
public extension CMGradientDirection {
    /// 获取渐变方向`Point`
    var point: (start: CGPoint, end: CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        case .rightOblique:
            return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
        case let .customize(start, end):
            return (start, end)
        }
    }
}

// MARK: - 构造方法
public extension CAGradientLayer {
    /// 创建渐变图层(`CAGradientLayer`)
    /// - Parameters:
    ///   - frame:图层尺寸及位置信息
    ///   - direction:渐变方向
    ///   - colors:颜色位置数组
    ///   - locations:颜色数组中颜色对应的位置
    ///   - type:渐变类型
    convenience init(
        _ frame: CGRect = .zero,
        direction: CMGradientDirection,
        colors: [UIColor],
        locations: [CGFloat]? = nil,
        type: CAGradientLayerType = .axial
    ) {
        self.init()
        self.frame = frame
        self.colors = colors.map(\.cgColor)
        self.locations = locations?.map { NSNumber(value: Double($0)) }
        startPoint = direction.point.start
        endPoint = direction.point.end
        self.type = type
    }
}

// MARK: - 静态方法
public extension CAGradientLayer {
    /// 创建线性渐变色图层
    /// - Parameters:
    ///   - frame:图层尺寸及位置信息
    ///   - direction:渐变方向(起止位置)
    ///   - colors:渐变的颜色数组
    ///   - locations:颜色数组中颜色对应位置
    /// - Returns:渐变色图层
    static func linearGradient(
        _ frame: CGRect = .zero,
        direction: CMGradientDirection = .horizontal,
        colors: [UIColor],
        locations: [CGFloat] = [0, 1]
    ) -> CAGradientLayer {
        return defaultGradientLayer.setupLinearGradient(
            frame,
            direction: direction,
            colors: colors,
            locations: locations
        )
    }
}

// MARK: - 方法
public extension CAGradientLayer {
    /// 设置线性渐变色图层
    /// - Parameters:
    ///   - frame:图层尺寸及位置信息
    ///   - direction:渐变方向(起止位置)
    ///   - colors:渐变的颜色数组
    ///   - locations:颜色数组中颜色对应位置
    /// - Returns:渐变色图层
    @discardableResult
    func setupLinearGradient(
        _ frame: CGRect = .zero,
        direction: CMGradientDirection = .horizontal,
        colors: [UIColor],
        locations: [CGFloat] = [0, 1]
    ) -> CAGradientLayer {
        self.frame = frame
        startPoint = direction.point.start
        endPoint = direction.point.end
        self.colors = colors.map(\.cgColor)
        self.locations = locations.map { location in
            location.sb.toNSNumber()
        }
        return self
    }
}

// MARK: - 链式语法
public extension CAGradientLayer {
    /// 创建默认`CAGradientLayer`
    static var defaultGradientLayer: CAGradientLayer {
        let layer = CAGradientLayer()
        return layer
    }

    /// 设置渐变颜色数组
    /// - Parameter colors:要设置的渐变颜色数组
    /// - Returns:`Self`
    @discardableResult
    func colors(_ colors: [UIColor]) -> Self {
        let cgColors = colors.map {
            $0.cgColor
        }
        self.colors = cgColors
        return self
    }

    /// 设置渐变位置数组
    /// - Parameter locations:要设置的渐变位置数组
    /// - Returns:`Self`
    @discardableResult
    func locations(_ locations: [CGFloat] = [0, 1]) -> Self {
        let locationNumbers = locations.map { flt in
            NSNumber(floatLiteral: flt)
        }
        self.locations = locationNumbers
        return self
    }

    /// 设置渐变开始位置
    /// - Parameter startPoint:渐变开始位置
    /// - Returns:`Self`
    @discardableResult
    func startPoint(_ startPoint: CGPoint = .zero) -> Self {
        self.startPoint = startPoint
        return self
    }

    /// 设置渐变结束位置
    /// - Parameter endPoint:渐变结束位置
    /// - Returns:`Self`
    @discardableResult
    func endPoint(_ endPoint: CGPoint = .zero) -> Self {
        self.endPoint = endPoint
        return self
    }

    /// 设置渐变方向(线性渐变)
    /// - Parameter direction:渐变方向
    /// - Returns:`Self`
    @discardableResult
    func direction(_ direction: CMGradientDirection = .horizontal) -> Self {
        startPoint = direction.point.0
        endPoint = direction.point.1
        return self
    }
}
