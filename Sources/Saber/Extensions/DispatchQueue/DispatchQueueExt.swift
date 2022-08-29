import Dispatch
import Foundation

    // MARK: - 静态属性
public extension DispatchQueue {
        /// 判断当前`DispatchQueue`是否是`主DispatchQueue`
    static var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }
}

    // MARK: - 线程比较
public extension DispatchQueue {
        /// 判断当前`DispatchQueue`是否是指定的`DispatchQueue`
        /// - Parameters queue: 要判断的`DispatchQueue`
        /// - Returns: 比较结果
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()
        queue.setSpecific(key: key, value: ())
        
        defer { queue.setSpecific(key: key, value: nil) }
        
        return DispatchQueue.getSpecific(key: key) != nil
    }
}

    // MARK: - 指定线程执行
public extension DispatchQueue {
        /// 安全异步执行
        /// - Parameter block: 要执行的任务
    func safeAsync(_ block: @escaping () -> Void) {
        if self === DispatchQueue.main, Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
    
        /// 主线程异步执行
        /// - Parameter block: 要执行的任务
    static func mainAsync(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
        /// 子线程异步执行
        /// - Parameter block: 要执行的任务
    static func globalAsync(_ block: @escaping () -> Void) {
        DispatchQueue.global().async {
            block()
        }
    }
}

    // MARK: - 函数只被执行一次
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
        /// 函数只被执行一次
        /// - Parameters:
        ///   - token: 函数标识
        ///   - block: 执行的闭包
        /// - Returns: 一次性函数
    static func once(token: String, block: () -> Void) {
        if _onceTracker.contains(token) {
            return
        }
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        _onceTracker.append(token)
        block()
    }
}

    // MARK: - GCD定时器
public extension DispatchQueue {
        /// GCD延时操作
        /// - Parameters:
        ///   - afterTime: 延迟的时间
        ///   - handler: 执行操作
    static func after(_ timeInterval: TimeInterval = 0, handler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: handler)
    }
    
        /// GCD定时器倒计时⏳
        /// - Parameters:
        ///   - timeInterval: 循环间隔时间
        ///   - repeatCount: 重复次数
        ///   - handler: 循环事件, 闭包参数： 1. timer, 2. 剩余执行次数
    @discardableResult
    static func countdown(_ timeInterval: TimeInterval, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) -> DispatchSourceTimer? {
        if repeatCount <= 0 {
            return nil
        }
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
        return timer
    }
    
        /// GCD定时器循环操作
        /// - Parameters:
        ///   - timeInterval: 循环间隔时间
        ///   - handler: 循环事件
    @discardableResult
    static func interval(_ timeInterval: TimeInterval = 1, handler: @escaping (DispatchSourceTimer?) -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler {
            DispatchQueue.main.async {
                handler(timer)
            }
        }
        timer.resume()
        return timer
    }
}

    // MARK: - 方法
public extension DispatchQueue {
        /// 延时异步执行
        /// - Parameters:
        ///   - delay: 延时时长
        ///   - qos: 优化级
        ///   - flags: 标识
        ///   - work: 要执行的代码
    func asyncAfter(delay: Double,
                    qos: DispatchQoS = .unspecified,
                    flags: DispatchWorkItemFlags = [],
                    execute work: @escaping () -> Void)
    {
    asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }
    
        /// 防抖延时执行
        /// - Parameters:
        ///   - delay: 延时时长
        ///   - action: 要执行的代码
        /// - Returns: block
    func debounce(delay: Double, action: @escaping () -> Void) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + delay }
        return {
            self.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
}

    // MARK: - 延迟事件
public extension DispatchQueue {
        /// 异步做一些任务(立刻执行0延时)
        /// - Parameter asyncTask: 延时异步任务
    @discardableResult
    static func async(_ asyncTask: @escaping Callbacks.TaskCallback) -> DispatchWorkItem {
        return _AsyncDelay(0, asyncTask: asyncTask)
    }
    
        /// 异步做任务后回到主线程做任务(立刻执行0延时)
        /// - Parameters:
        ///   - asyncTask: 延时异步任务
        ///   - mainTask: 延时完成之后执行的主线程任务
    @discardableResult
    static func async(_ asyncTask: @escaping Callbacks.TaskCallback,
                      mainTask: Callbacks.TaskCallback? = nil) -> DispatchWorkItem
    {
    return _AsyncDelay(0, asyncTask: asyncTask, mainTask: mainTask)
    }
    
        /// 异步延迟(子线程执行任务)
        /// - Parameter seconds: 延迟秒数
        /// - Parameter asyncTask: 延时异步任务
    @discardableResult
    static func asyncDelay(_ seconds: Double,
                           asyncTask: @escaping Callbacks.TaskCallback) -> DispatchWorkItem
    {
    return _AsyncDelay(seconds, asyncTask: asyncTask)
    }
    
        /// 异步延迟回到主线程(子线程执行任务,然后回到主线程执行任务)
        /// - Parameter seconds: 延迟秒数
        /// - Parameter asyncTask: 延时异步任务
        /// - Parameter mainTask: 延时完成之后执行的主线程任务
    @discardableResult
    static func asyncDelay(_ seconds: Double,
                           asyncTask: @escaping Callbacks.TaskCallback,
                           mainTask: Callbacks.TaskCallback? = nil) -> DispatchWorkItem
    {
    return _AsyncDelay(seconds, asyncTask: asyncTask, mainTask: mainTask)
    }
}

    // MARK: - 私有方法
private extension DispatchQueue {
        /// 延迟任务
        /// - Parameters:
        ///   - seconds: 延迟时间
        ///   - asyncTask: 延时异步任务
        ///   - mainTask: 延时完成之后执行的主线程任务
        /// - Returns: DispatchWorkItem
    static func _AsyncDelay(_ seconds: Double,
                            asyncTask: @escaping Callbacks.TaskCallback,
                            mainTask: Callbacks.TaskCallback? = nil) -> DispatchWorkItem
    {
    let item = DispatchWorkItem(block: asyncTask)
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
    if let main = mainTask {
        item.notify(queue: DispatchQueue.main, execute: main)
    }
    return item
    }
}
