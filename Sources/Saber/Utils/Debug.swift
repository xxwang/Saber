import Foundation

public enum Debug {
    /// 是否输出到文件
    static var isOut2File: Bool = false

    /// 信息输出
    static func Info(_ message: Any...,
                     file: String = #file,
                     line: Int = #line,
                     column: Int = #column,
                     function: String = #function)
    {
        #if DEBUG
            // 输出内容
            var content = ""
            for (index, item) in message.enumerated() {
                content += "\(item)"
            }
            // 格式化日期(当时时间)
            let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
            // 获取文件名称
            let fileName = (file as NSString).lastPathComponent
            content = "✅[\(dateStr)][\(fileName) => \(function)]:\(line):\(column): \(content)"
            print(content)
        #endif

        // 写入文件
        write2File(content: content)
    }

    /// 警告输出
    static func Warning(_ message: Any...,
                        file: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        function: String = #function)
    {
        #if DEBUG
            // 输出内容
            var content = ""
            for (index, item) in message.enumerated() {
                content += "\(item)"
            }
            // 格式化日期(当时时间)
            let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
            // 获取文件名称
            let fileName = (file as NSString).lastPathComponent
            content = "❗️[\(dateStr)][\(fileName) => \(function)]:\(line):\(column): \(content)"
            print(content)
        #endif
        // 写入文件
        write2File(content: content)
    }

    /// 错误输出
    static func Error(_ message: Any...,
                      file: String = #file,
                      line: Int = #line,
                      column: Int = #column,
                      function: String = #function)
    {
        #if DEBUG
            // 输出内容
            var content = ""
            for (index, item) in message.enumerated() {
                content += "\(item)"
            }
            // 格式化日期(当时时间)
            let dateStr = Date().format("HH:mm:ss.SSS", isGMT: false)
            // 获取文件名称
            let fileName = (file as NSString).lastPathComponent
            content = "❌[\(dateStr)][\(fileName) => \(function)]:\(line):\(column): \(content)"
            print(content)
        #endif
        // 写入文件
        write2File(content: content)
    }
}

extension Debug {
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
