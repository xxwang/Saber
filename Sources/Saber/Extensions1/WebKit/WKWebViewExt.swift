import WebKit

// MARK: - 关联键
private enum AssociateKeys {
    static var defaultConfig = "WKWebView" + "DefaultConfig"
}

// MARK: 属性
public extension WKWebView {
    /// 截取整个滚动视图的快照(截图)
    override var screenshot: UIImage? {
        return scrollView.screenshot
    }
}

// MARK: - 静态方法
public extension WKWebView {
    /// `WKWebViewConfiguration`默认配置
    static var defaultConfig: WKWebViewConfiguration {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociateKeys.defaultConfig) as? WKWebViewConfiguration {
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

            objc_setAssociatedObject(self, &AssociateKeys.defaultConfig, sender, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return sender
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.defaultConfig, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - 方法
public extension WKWebView {
    /// 获取网页快照
    /// - Parameter completion:完成回调
    func makemakeScreenshot(_ completion: @escaping (_ image: UIImage?) -> Void) {
        scrollView.makeScreenshot(completion)
    }
}

// MARK: - 脚本
public extension WKWebView {
    /// 向WKWebView注册JS代码
    /// - Parameter sourceCode:要注入的JS代码
    func addUserScript(_ sourceCode: String) {
        let userScript = WKUserScript(source: sourceCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(userScript)
    }

    /// 在WKWebView执行JS代码
    /// - Parameter sourceCode:注入的js代码
    func evaluateScript(_ sourceCode: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        evaluateJavaScript(sourceCode, completionHandler: completionHandler)
    }

    /// 调整字体的比例
    /// - Parameter ratio:比例
    /// - Returns:返回结果
    func adjustFontSizeRatio(_ ratio: CGFloat) {
        let scriptCode = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(ratio)%'"
        evaluateScript(scriptCode)
    }

    /// 适配手机(网页显示不正常)
    func adaptiveMobile() {
        let scriptCode = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        evaluateScript(scriptCode)
    }
}

// MARK: - load方法
public extension WKWebView {
    /// 加载网页(URL字符串)方法解决:Web页面包含了`Ajax`请求的话, `cookie`要重新处理, 这个处理需要在`WKWebView`的`WKWebViewConfiguration`中进行配置
    /// - Parameters:
    ///   - urlString:要加载的URL链接地址字符串
    ///   - headers:要加载的请求头
    ///   - timeout:超时时间
    /// - Returns:WKNavigation
    func load(_ urlString: String?, headers: [String: Any]? = nil, timeout: TimeInterval? = nil) -> WKNavigation? {
        guard let urlString = urlString,
              let url = URL(string: urlString)
        else {
            print("😭链接错误")
            return nil
        }
        return load(url, headers: headers, timeout: timeout)
    }

    /// 加载网页(URL)方法解决:Web页面包含了`Ajax`请求的话, `cookie`要重新处理, 这个处理需要在`WKWebView`的`WKWebViewConfiguration`中进行配置
    /// - Parameters:
    ///   - url:要加载的URL链接地址
    ///   - headers:要加载的请求头
    ///   - timeout:超时时间
    /// - Returns:WKNavigation
    @discardableResult
    func load(_ url: URL?, headers: [String: Any]? = nil, timeout: TimeInterval? = nil) -> WKNavigation? {
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
        configuration.userContentController = userContentController

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
        return load(request as URLRequest)
    }
}
