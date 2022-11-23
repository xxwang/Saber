import CoreLocation
import Foundation
import StoreKit
import UIKit
import UserNotifications

// MARK: - 应用程序运行环境枚举
public enum Environment {
    /// 应用程序正在调试模式下运行
    case debug
    /// 应用程序是从testFlight安装的
    case testFlight
    /// 应用程序是从应用商店安装的
    case appStore
}

// MARK: - 静态属性
public extension UIApplication {
    /// 当前应用程序的运行环境
    static var inferredEnvironment: Environment {
        #if DEBUG
            return .debug
        #elseif targetEnvironment(simulator)
            return .debug
        #else
            if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
                return .testFlight
            }

            guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
                return .debug
            }

            if appStoreReceiptURL.lastPathComponent.lowercased() == "sandboxreceipt" {
                return .testFlight
            }

            if appStoreReceiptURL.path.lowercased().contains("simulator") {
                return .debug
            }

            return .appStore
        #endif
    }

    /// 是否是调试环境
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    /// 是否是正式环境
    static var isRelease: Bool {
        return !isDebug
    }
}

// MARK: - 静态属性
public extension UIApplication {
    /// 获取屏幕的方向
    static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    /// 网络状态是否可用
    static var reachable: Bool {
        let data = NSData(contentsOf: URL(string: "https://www.baidu.com/")!)
        return (data != nil)
    }

    /// 消息推送是否可用
    static var isAvailableOfPush: Bool {
        let notOpen = UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType(rawValue: 0)
        return !notOpen
    }
}

// MARK: - 静态方法
public extension UIApplication {
    /// app商店链接
    /// - Parameter appID:应用在商店中的ID
    /// - Returns:URL字符串
    @discardableResult
    static func appURL(with appID: String) -> String {
        let appStoreURL = "itms-apps://itunes.apple.com/app/id\(appID)?mt=8"
        return appStoreURL
    }

    /// app详情链接
    /// - Parameter appID:应用在商店中的ID
    /// - Returns:URL字符串
    @discardableResult
    static func appDetailURL(with appID: String) -> String {
        let detailURL = "http://itunes.apple.com/cn/lookup?id=\(appID)"
        return detailURL
    }
}

// MARK: - 系统app枚举
public enum CMSystemApp: String {
    case safari = "http://"
    case googleMaps = "http://maps.google.com"
    case Phone = "tel://"
    case SMS = "sms://"
    case Mail = "mailto://"
    case iBooks = "ibooks://"
    case AppStore = "itms-apps://itunes.apple.com"
    case Music = "music://"
    case Videos = "videos://"
}

// MARK: - 系统app枚举扩展
public extension CMSystemApp {
    /// 要打开的App的URL地址
    var url: URL {
        return URL(string: rawValue)!
    }
}

// MARK: - 第三方app枚举
public enum CMOtherApp: String {
    /// 微信
    case weixin = "weixin://"
    /// QQ
    case qq = "mqq://"
    /// 腾讯微博
    case tencentWeibo = "TencentWeibo://"
    /// 淘宝
    case taobao = "taobao://"
    /// 支付宝
    case alipay = "alipay://"
    /// 微博
    case weico = "weico://"
    /// QQ浏览器
    case mqqbrowser = "mqqbrowser://"
    /// uc浏览器
    case ucbrowser = " ucbrowser://"
    /// 海豚浏览器
    case dolphin = "dolphin://"
    /// 欧朋浏览器
    case ohttp = "ohttp://"
    /// 搜狗浏览器
    case sogouMSE = "SogouMSE://"
    ///  百度地图
    case baidumap = "baidumap://"
    /// 谷歌Chrome浏览器
    case googlechrome = "googlechrome://"
    ///  优酷
    case youku = "youku://"
    /// 京东
    case jd = "openapp.jdmoble://"
    /// 人人
    case renren = "renren://"
    /// 美团
    case meituan = "imeituan://"
    /// 1号店
    case wccbyihaodian = "wccbyihaodian://"
    /// 我查查
    case wcc = " wcc://"
    /// 有道词典
    case yddictproapp = "yddictproapp://"
    /// 知乎
    case zhihu = "zhihu://"
    /// 点评
    case dianping = "dianping://"
    /// 微盘
    case sinavdisk = "sinavdisk://"
    /// 豆瓣fm
    case doubanradio = "doubanradio://"
    /// 网易公开课
    case ntesopen = "ntesopen://"
    /// 名片全能王
    case camcard = "camcard://"
    /// QQ音乐
    case qqmusic = "qqmusic://"
    /// 腾讯视频
    case tenvideo = "envideo://"
    /// 豆瓣电影
    case doubanmovie = "doubanmovie://"
    /// 网易云音乐
    case orpheus = "orpheus://"
    /// 网易新闻
    case newsapp = "newsapp://"
    /// 网易应用
    case apper = "apper://"
    /// 网易彩票
    case ntescaipiao = "ntescaipiao://"
    /// 有道云笔记
    case youdaonote = "youdaonote://"
    /// 多看
    case duokan = "duokan-reader://"
    /// 全国空气质量指数
    case dirtybeijing = "dirtybeijing://"
    /// 百度音乐
    case baidumusic = "baidumusic://"
    /// 下厨房
    case xcfapp = "xcfapp://"
}

// MARK: - 第三方app枚举扩展
public extension CMOtherApp {
    /// 要打开的App的URL地址
    var url: URL {
        return URL(string: rawValue)!
    }
}

// MARK: - 打开操作
public extension UIApplication {
    /// 打开手机上的`设置App`并跳转至本App的权限界面(带提示窗)
    /// - Parameters:
    ///   - title:提示标题
    ///   - message:提示内容
    ///   - cancel:取消按钮标题
    ///   - confirm:确认按钮标题
    ///   - parent:来源控制器(谁来弹出提示窗)
    static func openSettings(_ title: String?, message: String?, cancel: String = "取消", confirm: String = "设置", parent: UIViewController? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        alert.addAction(cancleAction)
        let confirmAction = UIAlertAction(title: confirm, style: .default, handler: { _ in
            // 打开系统设置App
            self.openSettings()
        })
        alert.addAction(confirmAction)
        if let root = parent {
            root.present(alert, animated: true)
            return
        }
        if let root = UIWindow.sb.rootViewController() {
            root.present(alert, animated: true)
        }
    }

    /// 打开手机上的`设置App`并跳转至本App的权限界面
    static func openSettings() {
        guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(settingsAppURL)
        }
    }

    /// 前往AppStore进行评价
    /// - Parameter appID:应用在AppStore中的ID
    static func evaluationInAppStore(_ appID: String) {
        let appURLString = "https://itunes.apple.com/cn/app/id" + appID + "?mt=12"
        guard let url = URL(string: appURLString), UIApplication.shared.canOpenURL(url) else {
            return
        }

        // 打开评分页面
        openURL(url) { isSuccess in
            isSuccess ? Saber.info("打开应用商店评分页成功!") : Saber.error("打开应用商店评分页失败!")
        }
    }

    /// 应用跳转
    /// - Parameters:
    ///   - vc:跳转时所在控制器
    ///   - appID:app的id
    static func updateApp(vc: UIViewController, appID: String) {
        guard appID.count > 0 else {
            return
        }
        let productView = SKStoreProductViewController()
        // productView.delegate = (vc as! SKStoreProductViewControllerDelegate)
        productView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appID], completionBlock: { result, _ in
            if !result {
                // 点击取消
                productView.dismiss(animated: true, completion: nil)
            }
        })
        vc.showDetailViewController(productView, sender: vc)
    }

    /// 打开应用更新页面
    /// - Parameters:
    ///   - sourceVC:跳转时的来源控制器(需要遵守`SKStoreProductViewControllerDelegate`协议)
    ///   - appID:用在AppStore中的ID(在Connect中创建应用后生成的ID)
    static func updateApp<T>(from sourceVC: T, appID: String) where T: UIViewController, T: SKStoreProductViewControllerDelegate {
        guard appID.count > 0 else {
            return
        }
        let productVC = SKStoreProductViewController()
        productVC.delegate = sourceVC
        productVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appID]) { isSuccess, error in
            productVC.dismiss(animated: true)
            if !isSuccess {
                Saber.error(error?.localizedDescription ?? "")
                return
            }
        }
        sourceVC.showDetailViewController(productVC, sender: sourceVC)
    }

    /// 打开手机上安装的系统app
    /// - Parameters:
    ///   - app:系统App枚举
    ///   - completion:完成回调
    static func openSystemApp(_ app: CMSystemApp, completion: @escaping Callbacks.BoolResult) {
        openURL(app.url, completion: completion)
    }

    /// 打开手机上安装的第三方App
    /// - Parameters:
    ///   - app:第三方app枚举
    ///   - completion:完成回调
    static func openOtherApp(_ app: CMOtherApp, completion: @escaping Callbacks.BoolResult) {
        openURL(app.url, completion: completion)
    }

    /// 拨打电话操作
    /// - Parameters:
    ///   - phoneNumber:要拨打的电话号码
    ///   - completion:完成回调
    static func call(with phoneNumber: String, completion: @escaping Callbacks.BoolResult) {
        // 判断是否有效
        guard let phoneNumberEncoding = ("tel://" + phoneNumber)
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: phoneNumberEncoding),
            UIApplication.shared.canOpenURL(url)
        else {
            completion(false)
            return
        }
        openURL(url, completion: completion)
    }

    /// 打开指定URL地址
    /// - Parameters:
    ///   - url:要打开的URL地址
    ///   - complete:完成回调
    static func openURL(_ url: URL, completion: @escaping Callbacks.BoolResult) {
        // iOS 10.0 以前
        guard #available(iOS 10.0, *) else {
            let success = UIApplication.shared.openURL(url)
            if success {
                Saber.info("10以前可以跳转")
                completion(true)
            } else {
                Saber.info("10以前不能完成跳转")
                completion(false)
            }
            return
        }
        // iOS 10.0 以后
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                Saber.info("10以后可以跳转url")
                completion(true)
            } else {
                Saber.info("10以后不能完成跳转")
                completion(false)
            }
        }
    }
}

// MARK: - 版本号
public extension UIApplication {
    /// 判断当前版本是否为新版本
    static var isNewVersion: Bool {
        // 当前应用版本
        let currentVersion = Bundle.sb.appVersion ?? "0.0.0"
        // 获取存储的版本
        let sandboxVersion = UserDefaults.sb.fetch(for: "appVersion") as? String ?? ""
        // 存储当前版本
        UserDefaults.sb.save(currentVersion, for: "appVersion")

        // 返回比较结果
        return currentVersion.compare(sandboxVersion) == .orderedDescending
    }

    /// 指定版本号与应用当前版本号进行比较
    /// - Parameter version:传进来的版本号码
    /// - Returns:返回对比加过,true:比当前的版本大,false:比当前的版本小
    static func compareVersion(version: String) -> Bool {
        // 获取要比较的(主版本号、次版本号、补丁版本号)
        let newVersionResult = appVersion(version: version)
        guard newVersionResult.isSuccess else {
            return false
        }

        // 获取当前应用的(主版本号、次版本号、补丁版本号)
        let currentVersion = Bundle.sb.appVersion ?? "0.0.0"
        let currentVersionResult = appVersion(version: currentVersion)
        guard currentVersionResult.isSuccess else {
            return false
        }

        // 主版本大于
        if newVersionResult.versions.major > currentVersionResult.versions.major {
            return true
        }

        // 主版本小于
        if newVersionResult.versions.major < currentVersionResult.versions.major {
            return false
        }

        // 次版本号大于
        if newVersionResult.versions.minor > currentVersionResult.versions.minor {
            return true
        }

        // 次版本号小于
        if newVersionResult.versions.minor < currentVersionResult.versions.minor {
            return false
        }

        // 补丁版本大于
        if newVersionResult.versions.patch > currentVersionResult.versions.patch {
            return true
        }

        // 补丁版本小于
        if newVersionResult.versions.patch < currentVersionResult.versions.patch {
            return false
        }

        // 相等
        return false
    }

    /// 分割版本号
    /// - Parameter version:要分割的版本号
    /// - Returns:(isSuccess:是否成功, versions:(major:主版本号, minor:次版本号, patch:补丁版本号))
    static func appVersion(version: String) -> (isSuccess: Bool, versions: (major: Int, minor: Int, patch: Int)) {
        // 获取(主版本号、次版本号、补丁版本号)字符串数组
        let versionNumbers = version.sb.split(with: ".")
        if versionNumbers.count != 3 {
            return (isSuccess: false, versions: (major: 0, minor: 0, patch: 0))
        }

        // 主版本号
        let majorString = versionNumbers[0]
        let majorNumber = majorString.sb.toInt()

        // 次版本号
        let minorString = versionNumbers[1]
        let minorNumber = minorString.sb.toInt()

        // 补丁版本号
        let patchString = versionNumbers[2]
        let patchNumber = patchString.sb.toInt()

        return (isSuccess: true, versions: (major: majorNumber, minor: minorNumber, patch: patchNumber))
    }
}

// MARK: - 推送
public extension UIApplication {
    /// 注册APNs远程推送
    /// - Parameter delegate:代理对象
    static func registerAPNsWithDelegate(_ delegate: Any) {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.delegate = (delegate as! UNUserNotificationCenterDelegate)
            center.requestAuthorization(options: options) { (granted: Bool, error: Error?) in
                if granted {
                    Saber.info("远程推送注册成功!")
                }
            }
            self.shared.registerForRemoteNotifications()
        } else {
            // 请求授权
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            // 需要通过设备UDID,和bundleID,发送请求,获取deviceToken
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    /// 添加本地通知
    /// - Parameters:
    ///   - trigger:触发器
    ///   - content:内容
    ///   - identifier:标识
    ///   - categories:分类
    ///   - repeats:是否重复
    ///   - handler:处理回调
    @available(iOS 10.0, *)
    func addLocalUserNotification(
        trigger: AnyObject,
        content: UNMutableNotificationContent,
        identifier: String,
        categories: AnyObject,
        repeats: Bool = true,
        handler: ((UNUserNotificationCenter, UNNotificationRequest, Error?) -> Void)?
    ) {
        // 通知触发器
        var notiTrigger: UNNotificationTrigger?
        if let date = trigger as? Date { // 日期触发
            var interval = date.timeIntervalSince1970 - Date().timeIntervalSince1970
            interval = interval < 0 ? 1 : interval
            notiTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        } else if let components = trigger as? DateComponents { // 日历触发
            notiTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        } else if let region = trigger as? CLCircularRegion { // 区域触发
            notiTrigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        }

        // 通知请求
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notiTrigger)
        // 通知中心
        let center = UNUserNotificationCenter.current()

        // 添加通知请求
        center.add(request) { error in
            // 回调结果
            handler?(center, request, error)
            if error == nil {
                return
            }
            Saber.info("通知添加成功!")
        }
    }
}
