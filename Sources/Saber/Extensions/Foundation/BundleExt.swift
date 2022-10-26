import Foundation
import UIKit

// MARK: - 静态属性
public extension Bundle {
    /// `Info.plist`
    static var infoDict: [String: Any]? {
        return Bundle.main.infoDictionary
    }

    /// app的版本号
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    /// app的编译版本号
    static var buildVersion: String? {
        // "CFBundleVersion"
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// 获取app的 `Bundle Identifier`
    static var appBundleIdentifier: String? {
        return Bundle.main.bundleIdentifier
    }

    /// 使用反射时的命名空间(app工程名称)
    static var namespace: String? {
        return infoDict?["CFBundleExecutable"] as? String
    }

    /// 可执行文件名称
    static var executable: String? {
        let name = kCFBundleExecutableKey as String
        return infoDict?[name] as? String
    }

    /// App 名称
    static var appDisplayName: String? {
        if let appName = infoDict?["CFBundleDisplayName"] as? String {
            return appName
        }

        if let appName = infoDict?["CFBundleExecutable"] as? String {
            return appName
        }

        if let appName = infoDict?["CFBundleName"] as? String {
            return appName
        }

        return nil
    }

    /// 设备信息的获取
    static var userAgent: String {
        // 可执行程序名称
        let executable = self.executable ?? "Unknown"
        // 应用标识
        let bundleID = appBundleIdentifier ?? "Unknown"
        // 应用版本
        let version = buildVersion ?? "Unknown"

        // 操作系统名称
        let osName = UIDevice.current.systemName
        // 操作系统版本
        let osVersion = UIDevice.current.systemVersion
        let osNameVersion = "\(osName) \(osVersion)"

        return "\(executable)/\(bundleID) (\(version); \(osNameVersion))"
    }

    /// 本地化
    static var localizations: String? {
        guard let content = infoDict?[String(kCFBundleLocalizationsKey)] else {
            return nil
        }
        return (content as! String)
    }

    /// 应用商店收据URL(appStoreReceiptURL)
    static var storeReceiptURL: URL? {
        return Bundle.main.appStoreReceiptURL
    }
}

// MARK: - 方法
public extension Bundle {
    /// 获取项目中文件的路径
    /// - Parameters:
    ///   - fileName:文件名称
    ///   - offType:后缀名称
    /// - Returns:对应路径
    static func path(for fileName: String?, _ offType: String? = nil) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: offType) else {
            return nil
        }
        return path
    }
}
