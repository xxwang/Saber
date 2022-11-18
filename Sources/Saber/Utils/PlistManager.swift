import UIKit

public class PlistManager {
    /// 解析`.plist`文件到`T.Type`(使用:`plist文件名称`)
    /// - Parameters:
    ///   - plistName: `.plist`文件名称
    ///   - resultType: 结果类型默认`[String: Any]`
    ///   - completion: 完成回调
    public static func parsePlist<T>(with plistName: String?) -> (Bool, T?) where T: Sequence {
        guard let plistName,
              let plistPath = Bundle.path(for: plistName)
        else {
            return (false, nil)
        }
        return self.parsePlist(from: plistPath)
    }

    /// 解析`.plist`文件到`T.Type`(使用:`plist文件路径`)
    /// - Parameters:
    ///   - plistPath: 文件路径
    ///   - resultType: 结果类型默认`[String: Any]`
    ///   - completion: 完成回调
    public static func parsePlist<T>(from plistPath: String?) -> (Bool, T?) where T: Sequence {
        guard let plistPath,
              let plistData = FileManager.default.contents(atPath: plistPath)
        else {
            return (false, nil)
        }
        var format = PropertyListSerialization.PropertyListFormat.xml
        do {
            let anyResult = try PropertyListSerialization.propertyList(
                from: plistData,
                options: .mutableContainersAndLeaves,
                format: &format
            )
            guard let result = anyResult as? T else {
                return (false, nil)
            }
            return (true, result)
        } catch {
            return (false, nil)
        }
    }
}
