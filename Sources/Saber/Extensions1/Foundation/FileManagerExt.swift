import UIKit

// MARK: - 静态属性
public extension FileManager {
    /// `iCloud`目录的完整路径
    static var supportPath: String {
        return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    }

    /// `Home`目录的完整路径
    static var homePath: String {
        return NSHomeDirectory()
    }

    /// `Documnets`目录的完整路径
    static var documnetsPath: String {
        return NSHomeDirectory() + "/Documents"
    }

    /// `Library`目录的完整路径名
    static var libraryPath: String {
        return NSHomeDirectory() + "/Library"
    }

    /// `Caches`目录的完整路径
    static var cachesPath: String {
        return NSHomeDirectory() + "/Library/Caches"
    }

    /// `Preferences`目录的完整路径
    static var preferencesPath: String {
        return NSHomeDirectory() + "/Library/Preferences"
    }

    /// `tmp`目录的完整路径
    static var tmpPath: String {
        return NSHomeDirectory() + "/tmp"
    }

    /// `iCloud`目录URL
    static var supportURL: URL {
        return URL(fileURLWithPath: supportPath, isDirectory: true)
    }

    /// `Home`目录的完整URL
    static var homeURL: URL {
        return URL(fileURLWithPath: homePath, isDirectory: true)
    }

    /// `Documnets`目录的完整URL
    static var documnetsURL: URL {
        return URL(fileURLWithPath: documnetsPath, isDirectory: true)
    }

    /// `Library`目录的完整URL
    static var libraryURL: URL {
        return URL(fileURLWithPath: libraryPath, isDirectory: true)
    }

    /// `Caches`目录的完整URL
    static var cachesURL: URL {
        return URL(fileURLWithPath: cachesPath, isDirectory: true)
    }

    /// `Preferences`目录的完整URL
    static var preferencesURL: URL {
        return URL(fileURLWithPath: preferencesPath, isDirectory: true)
    }

    /// `tmp`目录的完整URL
    static var tmpURL: URL {
        return URL(fileURLWithPath: tmpPath, isDirectory: true)
    }
}

// MARK: - 静态方法
public extension FileManager {
    /// 判断`path`所指`文件`或`文件夹`是否存在
    /// - Parameter path:路径
    /// - Returns:`Bool`
    static func isExists(_ path: String) -> Bool {
        let exist = self.default.fileExists(atPath: path)
        guard exist else {
            return false
        }
        return true
    }

    /// 获取`path`所指前一个路径(`上级目录`)
    /// - Parameter fullPath:完整路径
    /// - Returns:当前目录前一个路径(`上级目录`)
    static func previousPath(_ fullPath: String) -> String {
        return (fullPath as NSString).deletingLastPathComponent
    }

    /// 判断`path`所指`文件`或`目录`是否可读
    /// - Parameter path:路径
    /// - Returns:`Bool`
    static func isReadable(_ path: String) -> Bool {
        return self.default.isReadableFile(atPath: path)
    }

    /// 判断`path`所指`文件`或`目录`是否可写
    /// - Parameter path:路径
    /// - Returns:`Bool`
    static func isWritable(_ path: String) -> Bool {
        return self.default.isWritableFile(atPath: path)
    }

    /// 判断`path`所指`文件`或`目录`是否可执行
    /// - Parameter path:路径
    /// - Returns:`Bool`
    static func isExecutable(_ path: String) -> Bool {
        return self.default.isExecutableFile(atPath: path)
    }

    /// 判断`path`所指`文件`或`目录`是否可删除
    /// - Parameter path:路径
    /// - Returns:`Bool`
    static func isDeletable(_ path: String) -> Bool {
        return self.default.isDeletableFile(atPath: path)
    }

    /// 获取`path`所指文件的`扩展名`
    /// - Parameter path:路径
    /// - Returns:扩展名
    static func pathExtension(_ path: String) -> String {
        return (path as NSString).pathExtension
    }

    /// 获取`path`所指文件的`文件名`
    /// - Parameters:
    ///   - path:路径
    ///   - pathExtension:是否获取`扩展名`
    /// - Returns:文件名称
    static func fileName(_ path: String, suffix pathExtension: Bool = true) -> String {
        let fileName = (path as NSString).lastPathComponent
        guard pathExtension else {
            return (fileName as NSString).deletingPathExtension
        }
        return fileName
    }

    /// 获取`path`目录下的`文件``目录``符号链接`(不进行`递归遍历`)
    /// - Parameter path:要搜索的路径
    /// - Returns:结果数组
    static func shallowSearchAllFiles(_ path: String) -> [String] {
        guard let result = try? self.default.contentsOfDirectory(atPath: path) else {
            return []
        }
        return result
    }

    /// 获取`path`目录下的`文件``目录``符号链接`(`递归遍历`)
    /// - Parameter path:要搜索的路径
    /// - Returns:结果数组
    static func allFiles(_ path: String) -> [String] {
        guard
            isExists(path),
            let subPaths = self.default.subpaths(atPath: path)
        else {
            return []
        }
        return subPaths
    }

    /// 深度搜索`path`所指目录(`递归遍历子文件夹`,`不遍历符号链接`)
    /// - Parameter path:路径
    /// - Returns:结果数组
    static func deepSearchAllFiles(_ path: String) -> [Any]? {
        guard isExists(path),
              let contents = self.default.enumerator(atPath: path)
        else {
            return nil
        }
        return contents.allObjects
    }

    /// 获取`path`所指`文件`或`文件夹`的属性列表
    /// - Parameter path:路径
    /// - Returns:属性列表
    static func attributeList(_ path: String) -> [FileAttributeKey: Any]? {
        do {
            return try self.default.attributesOfItem(atPath: path)
        } catch {
            return nil
        }
    }

    /// 计算`path`所指`文件`或`文件夹`的存储大小(单位`字节`)
    /// - Parameter path:路径
    /// - Returns:存储大小(单位`字节`)
    static func fileSize(_ path: String) -> UInt64 {
        guard isExists(path) else {
            return 0
        }
        guard let attributes = try? self.default.attributesOfItem(atPath: path),
              let sizeValue = attributes[FileAttributeKey.size] as? UInt64
        else {
            return 0
        }
        return sizeValue
    }

    /// 计算`path`所指`文件`或`文件夹`的存储大小(格式化表示)
    /// - Parameter path:路径
    /// - Returns:存储大小(格式化表示)
    static func folderSize(_ path: String) -> String {
        if path.count == 0, !self.default.fileExists(atPath: path) {
            return "0KB"
        }

        var fileSize: UInt64 = 0
        do {
            let files = try self.default.contentsOfDirectory(atPath: path)
            for file in files {
                let path = path + "/\(file)"
                fileSize += self.fileSize(path)
            }
        } catch {
            fileSize += self.fileSize(path)
        }
        return fileSize.sb.toStoreUnit()
    }

    /// 判断`path1`与`path2`所指`文件`或`文件夹`是否一致
    /// - Parameters:
    ///   - path1:参与比较的第一个路径
    ///   - path2:参与比较的第二个路径
    /// - Returns:`Bool`
    static func isEqual(path1: String, path2: String) -> Bool {
        guard isExists(path1), isExists(path2) else {
            return false
        }
        return self.default.contentsEqual(atPath: path1, andPath: path2)
    }

    /// 创建`文件夹`
    /// - Parameter path:完整路径
    /// - Returns:结果
    @discardableResult
    static func createFolder(_ path: String) -> (isSuccess: Bool, error: String) {
        if isExists(path) {
            return (true, "文件已存在!")
        }
        do {
            try self.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return (true, "创建成功!")
        } catch {
            return (false, "创建失败")
        }
    }

    /// 删除`文件夹`
    /// - Parameter path:完整路径
    /// - Returns:结果信息
    @discardableResult
    static func removeFolder(_ path: String) -> (isSuccess: Bool, error: String) {
        guard isExists(path) else {
            return (true, "文件夹不存在!")
        }
        do {
            try self.default.removeItem(atPath: path)
            return (true, "删除成功!")
        } catch _ {
            return (false, "删除失败!")
        }
    }

    /// 创建`文件`
    /// - Parameter path:完整路径
    /// - Returns:结果信息
    @discardableResult
    static func createFile(_ path: String) -> (isSuccess: Bool, error: String) {
        guard isExists(path) else {
            let ok = self.default.createFile(atPath: path, contents: nil, attributes: nil)
            return (ok, ok ? "创建成功!" : "创建失败!")
        }
        return (true, "文件已存在!")
    }

    /// 删除`文件`
    /// - Parameter path:完整路径
    /// - Returns:结果信息
    @discardableResult
    static func removeFile(_ path: String) -> (isSuccess: Bool, error: String) {
        guard isExists(path) else {
            return (true, "文件不存在!")
        }

        do {
            try self.default.removeItem(atPath: path)
            return (true, "删除文件成功!")
        } catch {
            return (false, "删除文件失败!")
        }
    }

    /// 追加`String`内容到文件末尾
    /// - Parameters:
    ///   - string:`String`内容
    ///   - address:文件所在位置(可是是`Path`或者`URL`)
    /// - Returns:是否追加成功
    static func appendStringToEnd(_ string: String, to address: Any) -> Bool {
        do {
            var fileURL: URL?
            if let url = address as? URL {
                fileURL = url
            } else if let path = address as? String {
                fileURL = path.sb.toUrl()
            }

            guard let fileURL = fileURL else {
                return false
            }

            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let content = "\n" + "\(Date().string):" + string

            fileHandle.seekToEndOfFile()
            fileHandle.write(content.sb.toData()!)

            return true
        } catch let error as NSError {
            print("failed to append:\(error)")
            return false
        }
    }

    /// 把文件`Data`写入到`path`所指`文件`
    /// - Parameters:
    ///   - data:待写入的`Data?`数据
    ///   - path:`文件`路径
    /// - Returns:结果信息
    @discardableResult
    static func writeData(_ data: Data?, to path: String) -> (isSuccess: Bool, error: String) {
        guard isExists(previousPath(path)) else {
            return (false, "文件路径不存在!")
        }

        guard let data = data else {
            return (false, "写入数据不能为空!")
        }

        guard let url = path.sb.toUrl(), path.sb.isURL() else {
            return (false, "写入路径错误!")
        }

        do {
            try data.write(to: url, options: .atomic)
            return (true, "写入数据成功!")
        } catch {
            return (false, "写入数据失败!")
        }
    }

    /// 读取`文件`内容
    /// - Parameter path:完整路径
    /// - Returns:`String?`
    @discardableResult
    static func readFile(_ path: String) -> String? {
        guard isExists(path) else {
            return nil
        }
        let data = self.default.contents(atPath: path)
        return String(data: data!, encoding: String.Encoding.utf8)
    }

    /// 从`path`所指`文件`读取数据(`Data?`)
    /// - Parameter path:完整路径
    /// - Returns:结果信息
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

    /// 拷贝`文件`或`文件夹`
    /// - Parameters:
    ///   - fromPath:来源路径
    ///   - toPath:目标路径
    ///   - isFile:是否是文件
    ///   - isCover:是否覆盖
    /// - Returns:结果信息
    @discardableResult
    static func copyItem(from fromPath: String, to toPath: String, isFile: Bool = true, isCover: Bool = true) -> (isSuccess: Bool, error: String) {
        guard isExists(fromPath) else {
            return (false, "文件路径不存在!")
        }

        if !isExists(previousPath(toPath)),
           isFile
           ? !createFile(previousPath(toPath)).isSuccess
        :!createFolder(toPath).isSuccess {
            return (false, "要拷贝到的路径不存在!")
        }

        if isCover, isExists(toPath) {
            do {
                try self.default.removeItem(atPath: toPath)
            } catch {
                return (false, "拷贝失败!")
            }
        }

        do {
            try self.default.copyItem(atPath: fromPath, toPath: toPath)
        } catch {
            return (false, "拷贝失败!")
        }
        return (true, "拷贝成功!")
    }

    /// 移动`文件`或`文件夹`
    /// - Parameters:
    ///   - fromPath:来源路径
    ///   - toPath:目标路径
    ///   - isFile:是否是文件
    ///   - isCover:是否覆盖
    /// - Returns:结果信息
    @discardableResult
    static func moveItem(from fromPath: String, to toPath: String, isFile: Bool = true, isCover: Bool = true) -> (isSuccess: Bool, error: String) {
        guard isExists(fromPath) else {
            return (false, "要移动的文件不存在!")
        }

        if !isExists(previousPath(toPath)),
           isFile
           ? !createFile(toPath).isSuccess
        :!createFolder(toPath).isSuccess {
            return (false, "目标文件夹不存在!")
        }

        if isCover, isExists(toPath) {
            do {
                try self.default.removeItem(atPath: toPath)
            } catch {
                return (false, "移动失败!")
            }
        }

        do {
            try self.default.moveItem(atPath: fromPath, toPath: toPath)
        } catch {
            return (false, "移动失败!")
        }
        return (true, "移动成功!")
    }
}
