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
    static var isIphoneXSeries: Bool {
        if #available(iOS 11, *) {
            return max(kSafeAreaInsets.left, kSafeAreaInsets.bottom) > 0
        }
        return false
    }

    /// 是否是横屏
    static var isLandscape: Bool {
        if #available(iOS 13, *) {
            return [.landscapeLeft, .landscapeRight].contains(UIDevice.current.orientation)
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}
