import AVFoundation
import UIKit

extension URL: Saberable {}
// MARK: - 属性
public extension SaberExt where Base == URL {
    /// 检测应用是否能打开这个`URL`
    var canOpen: Bool {
        return UIApplication.shared.canOpenURL(base)
    }

    /// 以字典形式返回`URL`的`参数`
    var parameters: [String: String]? {
        guard
            let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
        else {
            return nil
        }

        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }
}

// MARK: - 构造方法
public extension URL {
    /// 使用基础`URL`和`路径字符串`初始化`URL`对象
    /// - Parameters:
    ///   - string: `URL`路径
    ///   - url: 基础`URL`
    init?(path string: String?, base url: URL? = nil) {
        guard let string = string else { return nil }
        self.init(string: string, relativeTo: url)
    }

    /// 使用基础`URL字符串`和`路径字符串`初始化`URL`对象
    /// - Parameters:
    ///   - string: `URL`路径
    ///   - urlString: 基础`URL字符串`
    init?(path string: String?, base urlString: String? = nil) {
        guard let string = string else { return nil }
        guard let urlString = urlString else { return nil }
        guard let baseURL = urlString.sb.toUrl() else { return nil }
        self.init(string: string, relativeTo: baseURL)
    }
}

// MARK: - 方法
public extension SaberExt where Base == URL {
    /// 给`URL`添加查询参数并返回携带查询参数的 `URL`
    ///
    ///     let url = URL(string:"https://google.com")!
    ///     let param = ["q":"Swifter Swift"]
    ///     url.appendParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: 参数字典
    /// - Returns: 附加查询参数的`URL`
    func appendParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        return urlComponents.url!
    }

    /// 将查询参数添加到`URL`
    ///
    ///     var url = URL(string:"https://google.com")!
    ///     let param = ["q":"Swifter Swift"]
    ///     url.appendQueryParameters(params)
    ///     print(url) // prints "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters:参数字典
    func appendParameters(_ parameters: [String: String]) {
        base = appendParameters(parameters)
    }

    /// 获取查询参数中键对应的值
    ///
    ///     var url = URL(string:"https://google.com?code=12345")!
    ///     queryValue(for:"code") -> "12345"
    ///
    /// - Parameter key:键
    func queryValue(for key: String) -> String? {
        return URLComponents(string: base.absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// 通过删除所有路径组件返回新`URL`
    ///
    ///     let url = URL(string:"https://domain.com/path/other")!
    ///     print(url.deletingAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns:`URL`
    func deletingAllPathComponents() -> URL {
        var url: URL = base
        for _ in 0 ..< base.pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// 从`URL`中删除所有路径组件
    ///
    ///     var url = URL(string:"https://domain.com/path/other")!
    ///     url.deleteAllPathComponents()
    ///     print(url) // prints "https://domain.com/"
    ///
    func deleteAllPathComponents() {
        for _ in 0 ..< base.pathComponents.count - 1 {
            base.deleteLastPathComponent()
        }
    }

    /// 生成没有协议的新URL
    ///
    ///     let url = URL(string:"https://domain.com")!
    ///     print(url.droppedScheme()) // prints "domain.com"
    ///
    func droppedScheme() -> URL? {
        if let scheme = base.scheme {
            let droppedScheme = String(base.absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }
        guard base.host != nil else { return base }
        let droppedScheme = String(base.absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

    /// 根据`视频URL`在指定时间`秒`截取图像
    ///
    ///     var url = URL(string:"https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
    ///     var thumbnail = url.thumbnail()
    ///     thumbnail = url.thumbnail(fromTime:5)
    ///
    ///     DisptachQueue.main.async {
    ///      someImageView.image = url.thumbnail()
    ///     }
    ///
    /// - Parameter time:需要生成图片的视频的时间`秒`
    /// - Returns:`UIImage`
    func thumbnail(fromTime time: Float64 = 0) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: base))
        let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
