import UIKit

// MARK: - ScreenManager
public class ScreenManager {
    /// 设计屏幕尺寸
    fileprivate var screenSize = CGSize(width: 375, height: 812)
    /// 单例
    public static let shared = ScreenManager()
    private init() {}

    /// 设置设计图尺寸
    func setup(uiSize size: CGSize) {
        screenSize = size
    }
}

// MARK: - ScreenAdaptor
public protocol ScreenAdaptor {}
public extension ScreenAdaptor {
    /// 获取尺寸值
    private var sizeValue: CGFloat {
        if let value = self as? CGFloat {
            return value
        }

        if let value = self as? Double {
            return CGFloat(value)
        }

        if let value = self as? Float {
            return CGFloat(value)
        }

        if let value = self as? Int {
            return CGFloat(value)
        }
        return 0
    }

    /// 设计图屏幕尺寸
    private var screenSize: CGSize { ScreenManager.shared.screenSize }

    /// 适配宽度
    var autoWidth: CGFloat {
        var scale: CGFloat = kScreenWidth / screenSize.width
        if UIDevice.isLandscape {
            scale = kScreenWidth / screenSize.height
        }
        return scale * sizeValue
    }

    /// 适配高度
    var autoHeight: CGFloat {
        let appSize = ScreenManager.shared.screenSize
        var scale: CGFloat = kScreenHeight / appSize.height
        if UIDevice.isLandscape {
            scale = kScreenHeight / appSize.width
        }
        return scale * sizeValue
    }

    /// 最大适配(特殊情况)
    var autoMax: CGFloat {
        return max(autoWidth, autoHeight)
    }

    /// 最小适配(特殊情况)
    var autoMin: CGFloat {
        return min(autoWidth, autoHeight)
    }

    /// 字体大小配置
    var fontAuto: CGFloat {
        let fontSize = UIDevice.isPad
            ? sizeValue * 1.5
            : sizeValue
        return fontSize
    }

    /// 适配屏幕缩放比
    var autoScale: CGFloat {
        return sizeValue / UIScreen.screenScale
    }
}

// MARK: - 为数字类型提供适配方法
extension Int: ScreenAdaptor {}
extension Float: ScreenAdaptor {}
extension Double: ScreenAdaptor {}
extension CGFloat: ScreenAdaptor {}
