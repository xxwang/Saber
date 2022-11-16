import UIKit

// MARK: - 设计图尺寸
public class ScreenManager {
    /// 设计图尺寸(设计图的屏幕尺寸)
    private var screenSize = CGSize(width: 375, height: 812)
    /// 单例
    public static let shared = ScreenManager()
    private init() {}
}

public extension ScreenManager {
    /// 设计图尺寸
    var uiSize: CGSize {
        get {
            return screenSize
        }
        set {
            screenSize = newValue
        }
    }
}

// MARK: - 尺寸适配
public protocol AutoScreenable {}
public extension AutoScreenable {
    /// 获取尺寸值
    private var sizeValue: CGFloat {
        if let res = self as? CGFloat {
            return res
        }

        if let res = self as? Double {
            return CGFloat(res)
        }

        if let res = self as? Float {
            return CGFloat(res)
        }
        if let res = self as? Int {
            return CGFloat(res)
        }
        return 0
    }

    /// 适配宽度
    var autoWidth: CGFloat {
        let appSize = ScreenManager.shared.uiSize
        var scale: CGFloat = kScreenWidth / appSize.width
        if UIDevice.isLandscape {
            scale = kScreenWidth / appSize.height
        }
        return scale * sizeValue
    }

    /// 适配高度
    var autoHeight: CGFloat {
        let appSize = ScreenManager.shared.uiSize
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
extension Int: AutoScreenable {}
extension Float: AutoScreenable {}
extension Double: AutoScreenable {}
extension CGFloat: AutoScreenable {}
