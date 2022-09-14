import Foundation

// MARK: - 静态方法
public extension NotificationCenter {
    /// 发送通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - object: 对象
    ///   - userInfo: 携带信息
    static func post(
        _ name: Notification.Name,
        object: Any? = nil,
        userInfo: [AnyHashable: Any]? = nil
    ) {
        DispatchQueue.mainAsync {
            NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
        }
    }

    /// 添加通知监听(方法)
    /// - Parameters:
    ///   - observer: 监听者
    ///   - selector: 响应方法
    ///   - name: 通知名称
    ///   - object: 对象
    static func addObserver(
        _ observer: Any,
        selector: Selector,
        name: Notification.Name,
        object: Any? = nil
    ) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }

    /// 添加通知监听(闭包)
    /// - Parameters:
    ///   - name: 通知名称
    ///   - object: 对象
    ///   - queue: 队列
    ///   - using: 响应通知的闭包
    /// - Returns: 监听对象
    static func addObserver(
        name: Notification.Name,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        using: @escaping ((Notification) -> Void)
    ) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: using)
    }

    /// 只监听一次指定名称的通知,当通知响应后,会移除当前的监听
    /// - Parameters:
    ///   - name: 通知名称
    ///   - obj: 对象
    ///   - queue: 队列
    ///   - block: 接收到通知后要执行的代码块
    func observeOnce(
        forName name: Notification.Name?,
        object obj: Any? = nil,
        queue: OperationQueue? = nil,
        using block: @escaping (_ notification: Notification) -> Void
    ) {
        var handler: NSObjectProtocol!
        handler = addObserver(forName: name, object: obj, queue: queue) { [unowned self] in
            self.removeObserver(handler!)
            block($0)
        }
    }

    /// 移除监听者
    /// - Parameters:
    ///   - observer: 要移除的监听者
    ///   - name: 通知名称
    ///   - object: 对象
    static func removeObserver(
        _ observer: Any,
        name: Notification.Name? = nil,
        object: Any? = nil
    ) {
        guard let name = name else { // 移除全部
            NotificationCenter.default.removeObserver(observer)
            return
        }
        // 移除指定通知监听者
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }
}
