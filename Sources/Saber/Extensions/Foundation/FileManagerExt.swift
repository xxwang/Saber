import UIKit

// MARK: - 静态属性
public extension FileManager {
    /// 获取iCloud目录`备份在 iCloud`
    static var supportPath: String {
        return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    }

    /// 获取Home的完整路径名
    static var homePath: String {
        return NSHomeDirectory()
    }

    /// 获取Documnets的完整路径名
    static var documnetsPath: String {
        return NSHomeDirectory() + "/Documents"
    }

    /// 获取Library的完整路径名
    static var libraryPath: String {
        return NSHomeDirectory() + "/Library"
    }

    /// 获取/Library/Caches的完整路径名
    /// - Returns: /Library/Caches的完整路径名
    static var cachesPath: String {
        return NSHomeDirectory() + "/Library/Caches"
    }

    /// 获取Library/Preferences的完整路径名
    static var preferencesPath: String {
        return NSHomeDirectory() + "/Library/Preferences"
    }

    /// 获取Tmp的完整路径名,用于存放临时文件,保存应用程序再次启动过程中不需要的信息,重启后清空
    static var tmpPath: String {
        return NSHomeDirectory() + "/tmp"
    }

    /// 获取iCloud目录URL`备份在 iCloud`
    static var supportURL: URL {
        return URL(fileURLWithPath: supportPath, isDirectory: true)
    }

    /// 获取Home的完整URL
    static var homeURL: URL {
        return URL(fileURLWithPath: homePath, isDirectory: true)
    }

    /// 获取Documnets的完整URL
    static var documnetsURL: URL {
        return URL(fileURLWithPath: documnetsPath, isDirectory: true)
    }

    /// 获取Library的完整URL
    static var libraryURL: URL {
        return URL(fileURLWithPath: libraryPath, isDirectory: true)
    }

    /// 获取/Library/Caches的完整URL
    static var cachesURL: URL {
        return URL(fileURLWithPath: cachesPath, isDirectory: true)
    }

    /// 获取Library/Preferences的完整URL
    static var preferencesURL: URL {
        return URL(fileURLWithPath: preferencesPath, isDirectory: true)
    }

    /// 获取Tmp的完整URL,用于存放临时文件,保存应用程序再次启动过程中不需要的信息,重启后清空
    static var tmpURL: URL {
        return URL(fileURLWithPath: tmpPath, isDirectory: true)
    }
}

// MARK: - 方法
public extension FileManager {}

// MARK: - 静态方法
public extension FileManager {
    /// 在文件末尾追加新内容(l2console方法会使用)
    /// - Parameters:
    ///   - content: 要追加的文本
    ///   - address: 要写入的文件地址(可以是字符串, 也可以是URL)
    static func appendString(_ content: String, to address: Any) {
        do {
            // 获取写入文件URL
            var fileURL: URL?
            if let url = address as? URL {
                fileURL = url
            } else if let url = address as? String {
                fileURL = url.url
            }

            guard let fileURL = fileURL else {
                return
            }

            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let content = "\n" + "\(Date().string): " + content

            // 移动写入位置到末尾
            fileHandle.seekToEndOfFile()
            // 写入文件
            fileHandle.write(content.data!)

        } catch let error as NSError {
            print("failed to append: \(error)")
        }
    }

    /// 判断文件或文件夹是否存在
    /// - Parameter path: 文件或文件夹路径
    /// - Returns: 是否存在
    static func isExists(_ path: String) -> Bool {
        let exist = defaultManager.fileExists(atPath: path)
        guard exist else {
            return false
        }
        return true
    }

    /// 获取文件/文件夹的前一个路径
    /// - Parameter fullPath: 全路径
    /// - Returns: 前一个路径
    static func previousPath(_ fullPath: String) -> String {
        return (fullPath as NSString).deletingLastPathComponent
    }

    /// 判断目录是否可读
    /// - Parameter path: 路径
    /// - Returns: 是否可读
    static func isReadable(_ path: String) -> Bool {
        return defaultManager.isReadableFile(atPath: path)
    }

    /// 判断文件是否可写
    /// - Parameter path: 路径
    /// - Returns: 是否可写
    static func isWritable(_ path: String) -> Bool {
        return defaultManager.isWritableFile(atPath: path)
    }

    /// 判断文件是否可执行
    /// - Parameter path: 路径
    /// - Returns: 是否可执行
    static func isExecutable(_ path: String) -> Bool {
        return defaultManager.isExecutableFile(atPath: path)
    }

    /// 判断目录是否可删除
    /// - Parameter path: 路径
    /// - Returns: 是否可删除
    static func isDeletable(_ path: String) -> Bool {
        return defaultManager.isDeletableFile(atPath: path)
    }

    /// 获取文件扩展名
    /// - Parameter path: 路径
    /// - Returns: 扩展名
    static func pathExtension(_ path: String) -> String {
        return (path as NSString).pathExtension
    }

    /// 获取文件名称
    /// - Parameters:
    ///   - path: 路径
    ///   - extension: 是否需要扩展名(默认: 显示)
    /// - Returns: 文件名称
    static func fileName(_ path: String, suffix pathExtension: Bool = true) -> String {
        let fileName = (path as NSString).lastPathComponent
        guard pathExtension else {
            // 移除后缀
            return (fileName as NSString).deletingPathExtension
        }
        return fileName
    }

    /// 对指定路径进行浅搜索,返回指定目录下的文件/子目录/符号链接的列表(不进行递归遍历)
    /// - Parameter path: 要搜索的路径
    /// - Returns: 结果数组
    static func shallowSearchAllFiles(_ path: String) -> [String] {
        guard let result = try? defaultManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        return result
    }

    /// 获取指定目录下所有文件/子目录/符号链接的列表(递归遍历)
    /// - Parameter path: 要搜索的路径
    /// - Returns: 结果数组
    static func allFiles(_ path: String) -> [String] {
        guard isExists(path),
              let subPaths = defaultManager.subpaths(atPath: path)
        else {
            return []
        }
        return subPaths
    }

    /// 深度搜索指定路径(递归遍历子文件夹,不遍历符号链接)
    /// - Parameter path: 路径
    /// - Returns: 结果数组
    static func deepSearchAllFiles(_ path: String) -> [Any]? {
        guard isExists(path),
              let contents = defaultManager.enumerator(atPath: path)
        else {
            return nil
        }
        return contents.allObjects
    }

    /// 获取文件/文件夹属性列表
    /// - Parameter path: 路径
    /// - Returns: 属性列表
    static func attributeList(_ path: String) -> [FileAttributeKey: Any]? {
        do {
            /*
             Key列表:
             public static let type:
             public static let size:
             public static let modificationDate:
             public static let referenceCount:
             public static let deviceIdentifier:
             public static let ownerAccountName:
             public static let groupOwnerAccountName:
             public static let posixPermissions:
             public static let systemNumber:
             public static let systemFileNumber:
             public static let extensionHidden:
             public static let hfsCreatorCode:
             public static let hfsTypeCode:
             public static let immutable:
             public static let appendOnly:
             public static let creationDate:
             public static let ownerAccountID:
             public static let groupOwnerAccountID:
             public static let busy:
             @available(iOS 4.0, *)
             public static let protectionKey:
             public static let systemSize:
             public static let systemFreeSize:
             public static let systemNodes:
             public static let systemFreeNodes:
             */
            let attributes = try defaultManager.attributesOfItem(atPath: path)
            return attributes
        } catch {
            return nil
        }
    }

    /// 计算单个文件/文件夹的大小(单位: 字节)
    /// - Parameter path: 路径
    /// - Returns: 大小
    static func fileSize(_ path: String) -> UInt64 {
        guard isExists(path) else {
            return 0
        }
        guard let attributes = try? defaultManager.attributesOfItem(atPath: path),
              let sizeValue = attributes[FileAttributeKey.size] as? UInt64
        else {
            return 0
        }
        return sizeValue
    }

    /// 计算一个或多个文件的大小(转换单位)
    /// - Parameter path: 路径
    /// - Returns: 大小(格式化表示)
    static func folderSize(_ path: String) -> String {
        if path.count == 0, !defaultManager.fileExists(atPath: path) {
            return "0KB"
        }

        // 大小(字节)
        var fileSize: UInt64 = 0
        do {
            let files = try defaultManager.contentsOfDirectory(atPath: path)
            for file in files {
                let path = path + "/\(file)"
                fileSize += self.fileSize(path)
            }
        } catch {
            fileSize += self.fileSize(path)
        }
        return fileSize.storeUnit
    }

    /// 判断两个文件/文件夹是否一样
    /// - Parameters:
    ///   - path1: 路径1
    ///   - path2: 路径2
    /// - Returns: 是否一样
    static func isEqual(path1: String, path2: String) -> Bool {
        guard isExists(path1), isExists(path2) else {
            return false
        }
        return defaultManager.contentsEqual(atPath: path1, andPath: path2)
    }

    /// 创建文件夹
    /// - Parameter path: 文件夹的路径
    /// - Returns: 结果信息
    @discardableResult
    static func createFolder(_ path: String) -> (isSuccess: Bool, error: String) {
        if isExists(path) {
            return (true, "")
        }
        do {
            try defaultManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return (true, "")
        } catch {
            return (false, "创建失败")
        }
    }

    /// 删除文件夹
    /// - Parameter path: 文件夹的路径
    /// - Returns: 结果信息
    @discardableResult
    static func removeFolder(_ path: String) -> (isSuccess: Bool, error: String) {
        guard isExists(path) else {
            return (true, "")
        }

        do {
            try defaultManager.removeItem(atPath: path)
            return (true, "")
        } catch _ {
            return (false, "删除失败")
        }
    }

    /// 创建文件
    /// - Parameter path: 文件路径
    /// - Returns: 结果信息
    @discardableResult
    static func createFile(_ path: String) -> (isSuccess: Bool, error: String) {
        guard isExists(path) else {
            let ok = defaultManager.createFile(atPath: path, contents: nil, attributes: nil)
            return (ok, "")
        }
        return (true, "")
    }

    /// 删除文件
    /// - Parameter path: 文件路径
    /// - Returns: 结果信息
    @discardableResult
    static func removeFile(_ path: String) -> (isSuccess: Bool, error: String) {
        guard isExists(path) else {
            return (true, "")
        }

        do {
            try defaultManager.removeItem(atPath: path)
            return (true, "")
        } catch {
            return (false, "移除文件失败")
        }
    }

    /// 读取文件内容
    /// - Parameter path: 文件路径
    /// - Returns: 文件内容
    @discardableResult
    static func readFile(_ path: String) -> String? {
        guard isExists(path) else {
            return nil
        }
        let data = defaultManager.contents(atPath: path)
        return String(data: data!, encoding: String.Encoding.utf8)
    }

    /// 把文件`Data`写入到指定路径
    /// - Parameters:
    ///   - content: 要写入的数据
    ///   - path: 路径
    /// - Returns: 结果信息
    @discardableResult
    static func writeData(_ data: Data?, to path: String) -> (isSuccess: Bool, error: String) {
        guard isExists(previousPath(path)) else {
            return (false, "文件路径不存在!")
        }

        guard let data = data else {
            return (false, "写入数据不能为空!")
        }

        guard let url = path.url, path.isValidURL else {
            return (false, "写入路径错误!")
        }

        do {
            try data.write(to: url, options: .atomic)
            return (true, "")
        } catch {
            return (false, "写入数据失败!")
        }
    }

    /// 从指定路径读取数据
    /// - Parameter path: 文件路径
    /// - Returns: 结果信息
    @discardableResult
    static func readData(from path: String) -> (isSuccess: Bool, data: Data?, error: String) {
        guard isExists(path),
              let readHandler = FileHandle(forReadingAtPath: path)
        else {
            return (false, nil, "文件路径不存在!")
        }

        let data = readHandler.readDataToEndOfFile()
        if data.count == 0 {
            return (false, nil, "读取文件失败!")
        }
        return (true, data, "")
    }

    /// 拷贝文件/文件夹(路径要完整路径带文件名称及扩展)
    /// - Parameters:
    ///   - fromPath: 来源路径
    ///   - toPath: 目标路径
    ///   - isFile: 是否是文件
    ///   - isCover: 是否覆盖
    /// - Returns: 结果信息
    @discardableResult
    static func copyItem(from fromPath: String, to toPath: String, isFile: Bool = true, isCover: Bool = true) -> (isSuccess: Bool, error: String) {
        guard isExists(fromPath) else {
            return (false, "文件路径不存在!")
        }

        if !isExists(previousPath(toPath)),
           isFile
           ? !createFile(previousPath(toPath)).isSuccess
           : !createFolder(toPath).isSuccess
        {
            return (false, "要拷贝到的路径不存在!")
        }

        if isCover, isExists(toPath) {
            do {
                try defaultManager.removeItem(atPath: toPath)
            } catch {
                return (false, "拷贝失败!")
            }
        }

        do {
            try defaultManager.copyItem(atPath: fromPath, toPath: toPath)
        } catch {
            return (false, "拷贝失败!")
        }
        return (true, "拷贝成功!")
    }

    /// 移动文件/文件夹(路径要完整路径带文件名称及扩展)
    /// - Parameters:
    ///   - fromPath: 来源路径
    ///   - toPath: 目标路径
    ///   - isFile: 是否是文件
    ///   - isCover: 是否覆盖
    /// - Returns: 结果信息
    @discardableResult
    static func moveItem(from fromPath: String, to toPath: String, isFile: Bool = true, isCover: Bool = true) -> (isSuccess: Bool, error: String) {
        guard isExists(fromPath) else {
            return (false, "要移动的文件不存在!")
        }

        if !isExists(previousPath(toPath)),
           isFile
           ? !createFile(toPath).isSuccess
           : !createFolder(toPath).isSuccess
        {
            return (false, "目标文件夹不存在!")
        }

        if isCover, isExists(toPath) {
            do {
                try defaultManager.removeItem(atPath: toPath)
            } catch {
                return (false, "移动失败!")
            }
        }

        do {
            try defaultManager.moveItem(atPath: fromPath, toPath: toPath)
        } catch {
            return (false, "移动失败!")
        }
        return (true, "移动成功!")
    }
}

// MARK: - 链式语法
public extension FileManager {
    /// 创建默认`FileManager`
    static var defaultManager: FileManager {
        let manager = FileManager()
        return manager
    }
}
