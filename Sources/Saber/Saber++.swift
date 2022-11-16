import UIKit

// MARK: - 系统类型
public extension Saber {
    /// 系统类型枚举
    enum OS: String {
        case macOS
        case iOS
        case tvOS
        case watchOS
        case Linux
    }

    /// 系统类型
    var os: Saber.OS {
        #if os(macOS)
            return .macOS
        #elseif os(iOS)
            return .iOS
        #elseif os(tvOS)
            return .tvOS
        #elseif os(watchOS)
            return .watchOS
        #elseif os(Linux)
            return .Linux
        #endif
    }
}

// MARK: - 常用判断
public extension Saber {
    /// 是否是模拟器
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    /// 是否是调试模式
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    /// 是否是`iPhoneX`系列
    static var isXSeries: Bool {
        if #available(iOS 11, *) {
            if UIWindow.sb.window!.safeAreaInsets.left > 0
                || UIWindow.sb.window!.safeAreaInsets.bottom > 0
            {
                return true
            }
        }
        return false
    }

    /// 是否是横屏
    static var isLandscape: Bool {
        if #available(iOS 13, *) {
            let orientation = UIDevice.current.orientation
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                return true
            }
            return false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}
