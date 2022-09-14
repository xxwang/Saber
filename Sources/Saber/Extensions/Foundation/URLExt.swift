import AVFoundation
import UIKit

// MARK: - 属性
public extension URL {
    /// 检测应用是否能打开这个URL
    var isValid: Bool {
        return UIApplication.shared.canOpenURL(self)
    }

    /// 以字典形式返回URL的参数
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]

        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }

        return items
    }
}

// MARK: - 构造方法
public extension URL {
    /// 使用基本URL和相对字符串初始化“URL”对象.如果'string'格式不正确,则返回nil
    /// - Parameters:
    ///   - string: 用来初始化'URL'对象的URL字符串
    ///   - url: BaseURL
    init?(string: String?, relativeTo url: URL? = nil) {
        guard let string = string else { return nil }
        self.init(string: string, relativeTo: url)
    }

    /**
     从字符串初始化强制展开的“URL”.如果字符串无效,可能会崩溃
     - Parameter unsafeString: 用于初始化'URL'对象的URL字符串
     */
    init(unsafeString: String) {
        self.init(string: unsafeString)!
    }
}

// MARK: - 方法
public extension URL {
    /// 返回附加查询参数的URL
    ///
    ///        let url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.appendingQueryParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: 参数字典
    /// - Returns: 附加给定查询参数的URL
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters
            .map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url!
    }

    /// 将查询参数附加到URL
    ///
    ///        var url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.appendQueryParameters(params)
    ///        print(url) // prints "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: 参数字典
    mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }

    /// 获取查询参数中键对应的值
    ///
    ///    var url = URL(string: "https://google.com?code=12345")!
    ///    queryValue(for: "code") -> "12345"
    ///
    /// - Parameter key: 键
    func queryValue(for key: String) -> String? {
        return URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// 通过删除所有路径组件返回新URL
    ///
    ///     let url = URL(string: "https://domain.com/path/other")!
    ///     print(url.deletingAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns: 删除所有路径组件的URL
    func deletingAllPathComponents() -> URL {
        var url: URL = self
        for _ in 0 ..< pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// 从URL中删除所有路径组件
    ///
    ///        var url = URL(string: "https://domain.com/path/other")!
    ///        url.deleteAllPathComponents()
    ///        print(url) // prints "https://domain.com/"
    mutating func deleteAllPathComponents() {
        for _ in 0 ..< pathComponents.count - 1 {
            deleteLastPathComponent()
        }
    }

    /// 生成没有协议的新URL
    ///
    ///        let url = URL(string: "https://domain.com")!
    ///        print(url.droppedScheme()) // prints "domain.com"
    func droppedScheme() -> URL? {
        if let scheme = scheme {
            let droppedScheme = String(absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }

        guard host != nil else { return self }

        let droppedScheme = String(absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

    /// 从给定的 url 生成缩略图. 如果无法创建缩略图,则返回 nil. 此功能可能需要一些时间才能完成. 如果缩略图不是从本地资源生成的,建议使用dispatch
    ///
    ///     var url = URL(string: "https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
    ///     var thumbnail = url.thumbnail()
    ///     thumbnail = url.thumbnail(fromTime: 5)
    ///
    ///     DisptachQueue.main.async {
    ///         someImageView.image = url.thumbnail()
    ///     }
    ///
    /// - Parameter time: 应生成图像的视频的秒数
    /// - Returns: AVAssetImageGenerator 的 UIImage 结果
    func thumbnail(fromTime time: Float64 = 0) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self))
        let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
