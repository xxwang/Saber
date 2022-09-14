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

// MARK: - UIScreen
/// 屏幕尺寸相关信息
public var kSCREEN_BOUNDS: CGRect {
    return UIScreen.main.bounds
}

/// 屏幕尺寸
public var kSCREEN_SIZE: CGSize {
    return kSCREEN_BOUNDS.size
}

/// 屏幕宽度
public var kSCREEN_WIDTH: CGFloat {
    var width = min(kSCREEN_SIZE.width, kSCREEN_SIZE.height)
    if UIDevice.isLandscape {
        width = max(kSCREEN_SIZE.width, kSCREEN_SIZE.height)
    }
    return width
}

/// 屏幕高度
public var kSCREEN_HEIGHT: CGFloat {
    var height = max(kSCREEN_SIZE.width, kSCREEN_SIZE.height)
    if UIDevice.isLandscape {
        height = min(kSCREEN_SIZE.width, kSCREEN_SIZE.height)
    }
    return height
}

/// 安全区域
public var kSAFEAREA_INSETS: UIEdgeInsets {
    var insets: UIEdgeInsets = .zero
    if #available(iOS 11.0, *) {
        insets = UIWindow.availableWindow.safeAreaInsets
    }
    return insets
}

// MARK: - `UINavigationBar`
/// 状态栏高度
public var kSTATUSBAR_HEIGHT: CGFloat {
    var height: CGFloat = 0
    if #available(iOS 13.0, *) {
        if let statusbar = UIWindow.availableWindow.windowScene?.statusBarManager {
            height = statusbar.statusBarFrame.size.height
        }
    } else {
        height = UIApplication.shared.statusBarFrame.size.height
    }
    return height
}

/// 标题栏高度
public let kTITLEBAR_HEIGHT: CGFloat = 44
/// 导航栏整体
public var kTOPBAR_ALL_HEIGHT: CGFloat {
    let topBarHeight = kSTATUSBAR_HEIGHT + kTITLEBAR_HEIGHT
    return topBarHeight
}

// MARK: - `UITabBar`
/// 屏幕底部间距
public var kBOTTOM_INDENT: CGFloat {
    return UIDevice.isIphoneX ? 34 : 0
}

/// UITabBar高度
public let kTABBAR_HEIGHT: CGFloat = 49
/// 底部高度
public var kBOTTOMBAR_ALL_HEIGHT: CGFloat {
    return kBOTTOM_INDENT + kTABBAR_HEIGHT
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
        var scale: CGFloat = kSCREEN_WIDTH / appSize.width
        if UIDevice.isLandscape {
            scale = kSCREEN_WIDTH / appSize.height
        }
        return scale * sizeValue
    }

    /// 适配高度
    var autoHeight: CGFloat {
        let appSize = ScreenManager.shared.uiSize
        var scale: CGFloat = kSCREEN_HEIGHT / appSize.height
        if UIDevice.isLandscape {
            scale = kSCREEN_HEIGHT / appSize.width
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
