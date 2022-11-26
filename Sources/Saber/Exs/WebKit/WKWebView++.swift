import WebKit

// MARK: - 关联键
private enum AssociateKeys {
    static var DefaultConfigKey = "WKWebView" + "DefaultConfigKey"
}

// MARK: 属性
public extension SaberEx where Base: WKWebView {
    /// 截取整个滚动视图的快照(截图)
    var screenshot: UIImage? {
        return base.scrollView.sb.screenshot
    }
}

// MARK: - 方法
public extension SaberEx where Base: WKWebView {
    /// 获取网页快照
    /// - Parameter completion:完成回调
    func screenshot(_ completion: @escaping (_ image: UIImage?) -> Void) {
        base.scrollView.sb.screenshot(completion)
    }
}

// MARK: - 脚本
public extension SaberEx where Base: WKWebView {
    /// 向`WKWebView`注入`JS`代码
    /// - Parameter script: 要注册的脚本
    func injection(_ script: String) {
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        base.configuration.userContentController.addUserScript(userScript)
    }

    /// 在`WKWebView`执行`JS`代码
    /// - Parameters:
    ///   - script: 要执行的`JS`脚本
    ///   - completion: 完成回调
    func evaluate(_ script: String, completion: ((Any?, Error?) -> Void)? = nil) {
        base.evaluateJavaScript(script, completionHandler: completion)
    }

    /// 文字大小调整
    /// - Parameter ratio: 比例
    func textSizeAdjust(_ ratio: CGFloat) {
        let scriptCode = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(ratio)%'"
        evaluate(scriptCode)
    }

    /// 适配手机(网页显示不正常)
    func adaptionMobile() {
        let scriptCode = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        evaluate(scriptCode)
    }
}

// MARK: - load方法
public extension SaberEx where Base: WKWebView {
    /// 以`URL字符串`加载网页
    /// - Parameters:
    ///   - urlString: `URL字符串`
    ///   - headers: 头信息
    ///   - timeout: 超时时间
    /// - Returns: `WKNavigation?`
    @discardableResult
    func load(
        _ string: String?,
        headers: [String: Any]? = nil,
        timeout: TimeInterval? = nil
    ) -> WKNavigation? {
        guard let urlString = string, let url = URL(string: urlString) else {
            print("😭链接错误")
            return nil
        }
        return load(url, headers: headers, timeout: timeout)
    }

    /// 以`URL`加载网页
    /// - Parameters:
    ///   - url: `URL`
    ///   - headers: 头信息
    ///   - timeout: 超时时间
    /// - Returns: `WKNavigation?`
    @discardableResult
    func load(
        _ url: URL?,
        headers: [String: Any]? = nil,
        timeout: TimeInterval? = nil
    ) -> WKNavigation? {
        // 要加载的URL
        guard let url = url else {
            print("😭链接错误")
            return nil
        }

        // cookie JS脚本代码
        let cookieSourceCode = "document.cookie = 'user=\("userValue")';"
        let cookieScript = WKUserScript(source: cookieSourceCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(cookieScript)
        base.configuration.userContentController = userContentController

        var request = URLRequest(url: url)
        if let headFields: [AnyHashable: Any] = request.allHTTPHeaderFields {
            if headFields["user"] != nil {
            } else {
                request.addValue("user=\("userValue")", forHTTPHeaderField: "Cookie")
            }
        }

        // 添加headers
        headers?.forEach { key, value in
            let valueString = (value as? String) ?? ""
            request.addValue(valueString, forHTTPHeaderField: key)
        }

        // 超时时间
        if let timeout = timeout {
            request.timeoutInterval = timeout
        }
        return base.load(request as URLRequest)
    }
}

// MARK: - 静态方法
public extension SaberEx where Base: WKWebView {
    /// `WKWebViewConfiguration`默认配置
    static var defaultConfig: WKWebViewConfiguration {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociateKeys.DefaultConfigKey) as? WKWebViewConfiguration {
                return obj
            }

            let sender = WKWebViewConfiguration()
            sender.allowsInlineMediaPlayback = true
            sender.selectionGranularity = .dynamic
            sender.preferences = WKPreferences()
            sender.preferences.javaScriptCanOpenWindowsAutomatically = false

            if #available(iOS 14, *) {
                sender.defaultWebpagePreferences.allowsContentJavaScript = true
            } else {
                sender.preferences.javaScriptEnabled = true
            }

            objc_setAssociatedObject(self, &AssociateKeys.DefaultConfigKey, sender, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return sender
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.DefaultConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
