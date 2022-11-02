import Foundation

// MARK: - 方法
public extension Notification.Name {
    /// 发送通知
    /// - Parameters:
    ///   - object: 对象
    ///   - userInfo: 携带信息
    func sendNotification(
        object: Any? = nil,
        userInfo: [AnyHashable: Any]? = nil
    ) {
        NotificationCenter.post(self, object: object, userInfo: userInfo)
    }

    /// 添加通知监听(方法)
    /// - Parameters:
    ///   - observer: 监听者
    ///   - selector: 响应方法
    ///   - object: 对象
    func receiveNotification(
        _ observer: Any,
        selector: Selector,
        object: Any? = nil
    ) {
        NotificationCenter.addObserver(observer, selector: selector, name: self)
    }

    /// 移除监听者
    /// - Parameters:
    ///   - observer: 要移除的监听者
    ///   - object: 对象
    func removeObserver(
        _ observer: Any,
        object: Any? = nil
    ) {
        NotificationCenter.removeObserver(observer, object: object)
    }
}
