import Foundation

// MARK: - 常用扩展(基于Saber类)
public extension Saber {
    // MARK: - 系统类型
    enum OS {
        case macOS
        case iOS
        case tvOS
        case watchOS
        case Linux
    }

    /// 系统类型
    static var os: Saber.OS {
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

    /// 是否是模拟器
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
