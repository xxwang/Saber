import Dispatch

// MARK: - 静态方法
public extension SaberExt where Base: DispatchQueue {
    /// 判断`当前队列`是否是`主队列`
    static func isMainQueue() -> Bool {
        let key = DispatchSpecificKey<Void>()
        DispatchQueue.main.setSpecific(key: key, value: ())
        
        defer { DispatchQueue.main.setSpecific(key: key, value: nil) }
        
        return Base.getSpecific(key: key) != nil
    }
    
    /// 判断`当前队列`是否是`指定队列`
    /// - Parameter queue: `指定队列`
    /// - Returns: `Bool`
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()
        queue.setSpecific(key: key, value: ())
        
        defer { queue.setSpecific(key: key, value: nil) }
        
        return DispatchQueue.getSpecific(key: key) != nil
    }
}
