import Foundation

public enum Log {
    /// 是否输出到文件
    static var isOut2File: Bool = false
}

// MARK: - 方法
public extension Log {
    /// 调试
    static func debug(_ message: @autoclosure () -> String?,
                      file: String = #file,
                      line: Int = #line,
                      function: String = #function)
    {
        self.log(level: .debug, message: message(), file: file, line: line, function: function)
    }

    /// 信息
    static func info(_ message: @autoclosure () -> String?,
                     file: String = #file,
                     line: Int = #line,
                     function: String = #function)
    {
        self.log(level: .debug, message: message(), file: file, line: line, function: function)
    }

    /// 警告
    static func warning(_ message: @autoclosure () -> String?,
                        file: String = #file,
                        line: Int = #line,
                        function: String = #function)
    {
        self.log(level: .debug, message: message(), file: file, line: line, function: function)
    }

    /// 错误
    static func error(_ message: @autoclosure () -> String?,
                      file: String = #file,
                      line: Int = #line,
                      function: String = #function)
    {
        self.log(level: .debug, message: message(), file: file, line: line, function: function)
    }
}

// MARK: - 私有方法
extension Log {
    /// 输出方法
    /// - Parameters:
    ///   - level: 等级
    ///   - message: 内容
    ///   - file: 文件
    ///   - line: 行
    ///   - function: 方法
    private static func log(
        level: Log.Level,
        message: String?,
        file: String,
        line: Int,
        function: String)
    {
        #if DEBUG
            // 当时时间
            let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
            // 文件名称
            let fileName = (file as NSString).lastPathComponent

            let content = "\(level.levelIcon)\(level.levelName)[\(dateStr)][\(fileName) => \(function)]\(line): \(message ?? "")"
            print(content)
        #endif
        // 写入文件
        write2File(content: content)
    }

    /// 把内容写入到文件
    /// - Parameter content: 内容
    private static func write2File(content: String) {
        guard isOut2File else {
            return
        }

        // 将内容同步写到文件中去(Caches文件夹下)
        let fileURL = "/log.txt".urlByCache
        FileManager.appendString(content, to: fileURL)
    }
}

// MARK: - 日志等级
private extension Log {
    /// 日志等级
    enum Level {
        /// 调试
        case debug
        /// 信息
        case info
        /// 警告
        case warning
        /// 错误
        case error

        /// 图标
        var levelIcon: String {
            switch self {
                case .debug:
                    return "👻"
                case .info:
                    return "🌟"
                case .warning:
                    return "⚠️"
                case .error:
                    return "❌"
            }
        }

        /// 级别名称
        var levelName: String {
            switch self {
                case .debug:
                    return "[调试]"
                case .info:
                    return "[信息]"
                case .warning:
                    return "[警告]"
                case .error:
                    return "[错误]"
            }
        }
    }
}
