import UIKit

public class sb1 {}
// MARK: - 尺寸相关
public extension sb1 {
    /// 屏幕
    enum sc {
        public static var bounds: CGRect { return UIScreen.main.bounds }
        public static var size: CGSize { return bounds.size }
        public static var width: CGFloat { return size.width }
        public static var height: CGFloat { return size.height }
    }

    /// 导航
    enum nav {
        public static var status: CGFloat {
            var height: CGFloat = 0
            if #available(iOS 13.0, *) {
                if let statusbar = UIWindow.sb.window?.windowScene?.statusBarManager {
                    height = statusbar.statusBarFrame.size.height
                }
            } else {
                height = UIApplication.shared.statusBarFrame.size.height
            }
            return height
        }

        public static var title: CGFloat { return 44 }
        public static var all: CGFloat { return status + status }
    }

    /// 标签栏
    enum tab {
        public static var tabbar: CGFloat { return 49 }
        public static var indent: CGFloat { return sb1.isIphoneXSeries ? 34 : 0 }
        public static var all: CGFloat { return tabbar + indent }
    }

    static var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) { return UIWindow.sb.window?.safeAreaInsets ?? .zero }
        return .zero
    }
}

// MARK: - 系统类型
public extension sb1 {
    /// 系统类型枚举
    enum OS: String {
        case macOS
        case iOS
        case tvOS
        case watchOS
        case Linux
    }

    /// 系统类型
    var os: sb1.OS {
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
public extension sb1 {
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
            return max(sb1.safeArea.left, sb1.safeArea.bottom) > 0
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

// MARK: - 日志等级
private extension sb1 {
    /// 日志等级
    enum Level: String {
        /// 调试
        case debug = "[调试]"
        /// 信息
        case info = "[信息]"
        /// 警告
        case warning = "[警告]"
        /// 错误
        case error = "[错误]"

        /// 图标
        var icon: String {
            switch self {
            case .debug:
                return "👻"
            case .info:
                return "🌸"
            case .warning:
                return "⚠️"
            case .error:
                return "❌"
            }
        }
    }
}

// MARK: - 输出调试
public extension sb1 {
    /// 调试
    static func debug(
        _ message: Any...,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(level: .debug, message: message, file: file, line: line, function: function)
    }

    /// 信息
    static func info(_ message: Any...,
                     file: String = #file,
                     line: Int = #line,
                     function: String = #function)
    {
        log(level: .info, message: message, file: file, line: line, function: function)
    }

    /// 警告
    static func warning(_ message: Any...,
                        file: String = #file,
                        line: Int = #line,
                        function: String = #function)
    {
        log(level: .warning, message: message, file: file, line: line, function: function)
    }

    /// 错误
    static func error(_ message: Any...,
                      file: String = #file,
                      line: Int = #line,
                      function: String = #function)
    {
        log(level: .error, message: message, file: file, line: line, function: function)
    }
}

// MARK: - 私有方法
private extension sb1 {
    /// 输出方法
    /// - Parameters:
    ///   - level:等级
    ///   - message:内容
    ///   - file:文件
    ///   - line:行
    ///   - function:方法
    private static func log(
        level: sb1.Level,
        message: Any...,
        file: String,
        line: Int,
        function: String
    ) {
        let dateStr = Date.sb.nowDate().sb.format("HH:mm:ss.SSS", isGMT: false)
        let fileName = file.sb.toNSString().lastPathComponent.sb.removingSuffix(".swift")

        let content = message.map { "\($0)" }.joined(separator: "")
        print("\(level.icon)\(level.rawValue)[\(dateStr)][\(fileName).\(line) => \(function)]: " + content)
    }
}

public extension sb1 {
    /// 解析`.plist`文件`文件名称`
    /// - Parameter plistName: `.plist`文件名称
    /// - Returns: 解析结果
    static func parse(plistName: String?) -> Any? {
        guard let plistName,
              let plistPath = Bundle.sb.path(for: plistName)
        else {
            return nil
        }
        return parse(plistPath: plistPath)
    }

    /// 解析`.plist`文件`文件路径`
    /// - Parameter plistPath: 文件路径
    /// - Returns: 解析结果
    static func parse(plistPath: String?) -> Any? {
        guard let plistPath,
              let plistData = FileManager.default.contents(atPath: plistPath)
        else {
            return nil
        }

        do {
            var format = PropertyListSerialization.PropertyListFormat.xml
            return try PropertyListSerialization.propertyList(
                from: plistData,
                options: .mutableContainersAndLeaves,
                format: &format
            )
        } catch {
            return nil
        }
    }
}

// MARK: - 尺寸适配
public extension sb1 {
    /// 设计图对应的屏幕尺寸
    static var sketchSize = CGSize(width: 375, height: 812)

    /// 设置设计图尺寸
    static func setupSketch(size: CGSize) {
        sketchSize = size
    }

    /// 适配`宽度`
    static func adaptingWidth(value: Any) -> CGFloat {
        return ratioToSketchWidth() * sizeValueToCGFloat(value: value)
    }

    /// 适配`高度`
    static func adaptingHeight(value: Any) -> CGFloat {
        return ratioToSketchHeight() * sizeValueToCGFloat(value: value)
    }

    /// 适配(获取`最大宽高`)
    static func adaptingMax(value: Any) -> CGFloat {
        return Swift.max(adaptingWidth(value: value), adaptingHeight(value: value))
    }

    /// 适配(获取`最小宽高`)
    static func adaptingMin(value: Any) -> CGFloat {
        return Swift.min(adaptingWidth(value: value), adaptingHeight(value: value))
    }

    /// 适配`字体大小`
    static func adaptingFont(value: Any) -> CGFloat {
        return UIDevice.isPad
            ? sizeValueToCGFloat(value: value) * 1.5
            : sizeValueToCGFloat(value: value)
    }
}

// MARK: - 私有方法
private extension sb1 {
    /// 设备屏幕尺寸与设计图屏幕尺寸的`宽度比`
    /// - Returns: `CGFloat`
    static func ratioToSketchWidth() -> CGFloat {
        var scale: CGFloat = sb1.sc.width / sketchSize.width
        if sb1.isLandscape {
            scale = sb1.sc.width / sketchSize.height
        }
        return scale
    }

    /// 设备屏幕尺寸与设计图屏幕尺寸的`高度比`
    /// - Returns: `CGFloat`
    static func ratioToSketchHeight() -> CGFloat {
        var scale: CGFloat = sb1.sc.height / sketchSize.height
        if sb1.isLandscape {
            scale = sb1.sc.height / sketchSize.width
        }
        return scale
    }

    /// 把尺寸数据转换成`CGFloat`格式
    /// - Parameter value: 要转换的数据
    /// - Returns: `CGFloat`格式
    static func sizeValueToCGFloat(value: Any) -> CGFloat {
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

// MARK: - App Delegate
public extension sb1 {
    var appDelegate: UIApplicationDelegate? {
        let delegate = UIApplication.shared.delegate
        return delegate
    }

    @available(iOS 13.0, *)
    var sceneDelegate: UIWindowSceneDelegate {
        let connectedScenes = UIApplication.shared.connectedScenes
        var sceneDelegate: UIWindowSceneDelegate!
        connectedScenes.forEach { scene in
            if let windowScene = scene as? UIWindowScene,
               let windowSceneDelegate = windowScene.delegate as? UIWindowSceneDelegate
            {
                sceneDelegate = windowSceneDelegate
                return
            }
        }
        return sceneDelegate
    }
}
