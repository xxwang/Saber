import Foundation

// MARK: - 日志等级
private extension Saber {
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
public extension Saber {
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
private extension Saber {
    /// 输出方法
    /// - Parameters:
    ///   - level:等级
    ///   - message:内容
    ///   - file:文件
    ///   - line:行
    ///   - function:方法
    private static func log(
        level: Saber.Level,
        message: Any...,
        file: String,
        line: Int,
        function: String
    ) {
        var content = message.map { "\($0)" }.joined(separator: "")

        let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
        let fileName = (file as NSString).lastPathComponent.removingSuffix(".swift")

        content = "\(level.icon)\(level.rawValue)[\(dateStr)][\(fileName)[\(line)] => \(function)]:" + content
        print(content)
    }
}
