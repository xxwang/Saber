import UIKit

public class PlistManager {
    /// 解析`.plist`文件到`T.Type`(使用:`plist文件名称`)
    /// - Parameters:
    ///   - plistName: `.plist`文件名称
    ///   - resultType: 结果类型默认`[String: Any]`
    ///   - completion: 完成回调
    static func analysis<T>(with plistName: String?, resultType: T.Type = [String: Any].self, completion: (_ isOK: Bool, _ result: T?) -> Void) where T: Sequence {
        guard let plistName,
              let plistPath = Bundle.path(for: plistName)
        else {
            completion(false, nil)
            return
        }
        self.analysis(from: plistPath, resultType: resultType, completion: completion)
    }

    /// 解析`.plist`文件到`T.Type`(使用:`plist文件路径`)
    /// - Parameters:
    ///   - plistPath: 文件路径
    ///   - resultType: 结果类型默认`[String: Any]`
    ///   - completion: 完成回调
    static func analysis<T>(from plistPath: String?, resultType: T.Type = [String: Any].self, completion: (_ isOK: Bool, _ result: T?) -> Void) where T: Sequence {
        guard let plistPath,
              let plistData = FileManager.default.contents(atPath: plistPath)
        else {
            completion(false, nil)
            return
        }
        var format = PropertyListSerialization.PropertyListFormat.xml
        do {
            let anyResult = try PropertyListSerialization.propertyList(
                from: plistData,
                options: .mutableContainersAndLeaves,
                format: &format
            )
            guard let result = anyResult as? T else {
                completion(false, nil)
                return
            }
            completion(true, result)
        } catch {
            completion(false, nil)
        }
    }
}
