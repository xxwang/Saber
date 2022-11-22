import Foundation


extension Notification.Name: Saberable {}

    // MARK: - 方法
public extension SaberExt where Base == Notification.Name {
        /// 发送通知
        /// - Parameters:
        ///   - object:对象
        ///   - userInfo:携带信息
    func post(
        object: Any? = nil,
        userInfo: [AnyHashable: Any]? = nil
    ) {
        NotificationCenter.sb.post(base, object: object, userInfo: userInfo)
    }
    
        /// 添加通知监听(方法)
        /// - Parameters:
        ///   - observer:监听者
        ///   - selector:响应方法
        ///   - object:对象
    func receive(
        _ observer: Any,
        selector: Selector,
        object: Any? = nil
    ) {
        NotificationCenter.sb.add(observer, selector: selector, name: base)
    }
    
        /// 移除监听者
        /// - Parameters:
        ///   - observer:要移除的监听者
        ///   - object:对象
    func remove(
        _ observer: Any,
        object: Any? = nil
    ) {
        NotificationCenter.sb.remove(observer, object: object)
    }
}
