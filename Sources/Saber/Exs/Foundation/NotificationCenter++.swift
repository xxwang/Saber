import Foundation

// MARK: - 静态方法
public extension SaberEx where Base: NotificationCenter {
    /// 发送通知
    /// - Parameters:
    ///   - name:通知名称
    ///   - object:对象
    ///   - userInfo:携带信息
    static func post(
        _ name: Notification.Name,
        object: Any? = nil,
        userInfo: [AnyHashable: Any]? = nil
    ) {
        DispatchQueue.sb.mainAsync {
            NotificationCenter.default.post(
                name: name,
                object: object,
                userInfo: userInfo
            )
        }
    }

    /// 添加通知监听(方法)
    /// - Parameters:
    ///   - observer:监听者
    ///   - selector:响应方法
    ///   - name:通知名称
    ///   - object:对象
    static func add(
        _ observer: Any,
        selector: Selector,
        name: Notification.Name,
        object: Any? = nil
    ) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: name,
            object: object
        )
    }

    /// 添加通知监听(方法)
    /// - Parameters:
    ///   - name: 通知名称
    ///   - callback: 回调方法
    static func add(
        name: Notification.Name,
        callback: ((Notification) -> Void)?
    ) {
        Base.callback = callback
        NotificationCenter.default.addObserver(
            Base.self,
            selector: #selector(Base.addCallback(_:)),
            name: name,
            object: nil
        )
    }

    /// 移除监听者
    /// - Parameters:
    ///   - observer:要移除的监听者
    ///   - name:通知名称
    ///   - object:对象
    static func remove(
        _ observer: Any,
        name: Notification.Name? = nil,
        object: Any? = nil
    ) {
        guard let name = name else { // 移除全部
            NotificationCenter.default.removeObserver(observer)
            NotificationCenter.default.removeObserver(Base.self)
            return
        }
        // 移除指定通知监听者
        NotificationCenter.default.removeObserver(
            observer,
            name: name,
            object: object
        )
        
        NotificationCenter.default.removeObserver(
            Base.self,
            name: name,
            object: object
        )
    }
}

extension NotificationCenter {
    static var callback: ((Notification) -> Void)?
    @objc static func addCallback(_ n: Notification) {
        callback?(n)
    }
}
