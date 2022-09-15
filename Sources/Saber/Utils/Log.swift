import Foundation

public enum Log {
    /// 是否输出到文件
    public static var isOut2File: Bool = false

    /// 信息输出
    public static func info(_ message: Any...,
                            file: String = #file,
                            line: Int = #line,
                            function: String = #function)
    {
        #if DEBUG
            // 输出内容
            var content = ""
            for item in message {
                content += "\(item)"
            }
            // 格式化日期(当时时间)
            let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
            // 获取文件名称
            let fileName = (file as NSString).lastPathComponent.split(with: ".").first ?? ""
            content = "ℹ️[\(dateStr)][\(fileName)::\(function)]\(line): \(content)"
            print(content)
        #endif
        // 写入文件
        write2File(content: content)
    }

    /// 警告输出
    public static func warning(_ message: Any...,
                               file: String = #file,
                               line: Int = #line,
                               function: String = #function)
    {
        #if DEBUG
            // 输出内容
            var content = ""
            for item in message {
                content += "\(item)"
            }
            // 格式化日期(当时时间)
            let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
            // 获取文件名称
            let fileName = (file as NSString).lastPathComponent.split(with: ".").first ?? ""
            content = "❗️[\(dateStr)][\(fileName)::\(function)]\(line): \(content)"
            print(content)
        #endif
        // 写入文件
        write2File(content: content)
    }

    /// 错误输出
    public static func error(_ message: Any...,
                             file: String = #file,
                             line: Int = #line,
                             function: String = #function)
    {
        #if DEBUG
            // 输出内容
            var content = ""
            for item in message {
                content += "\(item)"
            }
            // 格式化日期(当时时间)
            let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
            // 获取文件名称
            let fileName = (file as NSString).lastPathComponent.split(with: ".").first ?? ""
            content = "❌[\(dateStr)][\(fileName)::\(function)]\(line): \(content)"
            print(content)
        #endif
        // 写入文件
        write2File(content: content)
    }

    /// 成功输出
    public static func success(_ message: Any...,
                               file: String = #file,
                               line: Int = #line,
                               function: String = #function)
    {
        #if DEBUG
            // 输出内容
            var content = ""
            for item in message {
                content += "\(item)"
            }
            // 格式化日期(当时时间)
            let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
            // 获取文件名称
            let fileName = (file as NSString).lastPathComponent.split(with: ".").first ?? ""
            content = "✅[\(dateStr)][\(fileName)::\(function)]\(line): \(content)"
            print(content)
        #endif
        // 写入文件
        write2File(content: content)
    }
}

extension Log {
    /// 写入文件
    private static func write2File(content: String) {
        guard isOut2File else {
            return
        }

        // 将内容同步写到文件中去(Caches文件夹下)
        let fileURL = "/log.txt".urlByCache
        FileManager.appendString(content, to: fileURL)
    }
}
