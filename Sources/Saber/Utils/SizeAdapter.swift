import UIKit

// MARK: - 尺寸尺寸
public class SizeAdapter {
    /// 单例
    public static let shared = SizeAdapter()
    private init() {}

    /// 设计图对应的屏幕尺寸
    private var sketchSize = CGSize(width: 375, height: 812)

    /// 设置设计图尺寸
    public func setupSketch(size: CGSize) {
        sketchSize = size
    }
}

// MARK: - 公开方法
public extension SizeAdapter {
    /// 适配`宽度`
    func adaptingWidth(value: Any) -> CGFloat {
        return ratioToSketchWidth() * sizeValueToCGFloat(value: value)
    }

    /// 适配`高度`
    func adaptingHeight(value: Any) -> CGFloat {
        return ratioToSketchHeight() * sizeValueToCGFloat(value: value)
    }

    /// 适配(获取`最大宽高`)
    func adaptingMax(value: Any) -> CGFloat {
        return Swift.max(adaptingWidth(value: value), adaptingHeight(value: value))
    }

    /// 适配(获取`最小宽高`)
    func adaptingMin(value: Any) -> CGFloat {
        return Swift.min(adaptingWidth(value: value), adaptingHeight(value: value))
    }

    /// 适配`字体大小`
    func adaptingFont(value: Any) -> CGFloat {
        return UIDevice.isPad
            ? sizeValueToCGFloat(value: value) * 1.5
            : sizeValueToCGFloat(value: value)
    }
}

// MARK: - 私有方法
private extension SizeAdapter {
    /// 设备屏幕尺寸与设计图屏幕尺寸的`宽度比`
    /// - Returns: `CGFloat`
    func ratioToSketchWidth() -> CGFloat {
        var scale: CGFloat = kScreenWidth / sketchSize.width
        if Saber.isLandscape {
            scale = kScreenWidth / sketchSize.height
        }
        return scale
    }

    /// 设备屏幕尺寸与设计图屏幕尺寸的`高度比`
    /// - Returns: `CGFloat`
    func ratioToSketchHeight() -> CGFloat {
        var scale: CGFloat = kScreenHeight / sketchSize.height
        if Saber.isLandscape {
            scale = kScreenHeight / sketchSize.width
        }
        return scale
    }

    /// 把尺寸数据转换成`CGFloat`格式
    /// - Parameter value: 要转换的数据
    /// - Returns: `CGFloat`格式
    func sizeValueToCGFloat(value: Any) -> CGFloat {
        if let value = value as? CGFloat {
            return value
        }

        if let value = value as? Double {
            return value
        }

        if let value = value as? Float {
            return value.sb.toCGFloat()
        }

        if let value = value as? Int {
            return value.sb.toCGFloat()
        }
        return 0
    }
}
