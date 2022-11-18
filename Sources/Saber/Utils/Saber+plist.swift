import UIKit

public extension Saber {
    /// 解析`.plist`文件`文件名称`
    /// - Parameter plistName: `.plist`文件名称
    /// - Returns: 解析结果
    static func parse(plistName: String?) -> Any? {
        guard let plistName,
              let plistPath = Bundle.path(for: plistName)
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
