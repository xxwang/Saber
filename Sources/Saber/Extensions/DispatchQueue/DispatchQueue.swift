import Dispatch
import Foundation

// MARK: - 队列判断
public extension SaberExt where Base: DispatchQueue {
    /// 判断`当前队列`是否是`指定队列`
    /// - Parameter queue: `指定队列`
    /// - Returns:
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()
        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }
        return DispatchQueue.getSpecific(key: key) != nil
    }

    /// 判断`当前队列`是否是`主队列`
    /// - Returns: `Bool`
    static func isMainQueue() -> Bool {
        return isCurrent(.main)
    }
}

// MARK: - 指定队列执行
public extension SaberExt where Base: DispatchQueue {
    /// `主队列``异步`执行
    /// - Parameter block: 要执行的任务
    static func mainAsync(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }

    /// `全局队列``异步`执行
    /// - Parameter block: 要执行的任务
    static func globalAsync(_ block: @escaping () -> Void) {
        DispatchQueue.global().async {
            block()
        }
    }

    /// `安全异步`执行
    /// - Parameter block: 要执行的任务
    static func safeAsync(_ queue: DispatchQueue = .main, block: @escaping () -> Void) {
        if queue === DispatchQueue.main, Thread.isMainThread {
            block()
        } else {
            // 在指定线程异步执行
            queue.async { block() }
        }
    }
}

// MARK: - 任务只被执行一次
public extension SaberExt where Base: DispatchQueue {
    /// `只执行一次``代码块`
    /// - Parameters:
    ///   - token: 函数标识
    ///   - block: 要执行的任务
    static func once(token: String, block: () -> Void) {
        if DispatchQueue._onceTracker.contains(token) {
            return
        }
        objc_sync_enter(Base.self)
        defer {
            objc_sync_exit(Base.self)
        }
        DispatchQueue._onceTracker.append(token)
        block()
    }
}

// MARK: - 延迟事件
public extension SaberExt where Base: DispatchQueue {
    /// 延时执行主线程任务
    /// - Parameters:
    ///   - seconds: 延迟秒数
    ///   - mainTask: 主线程任务
    /// - Returns: `DispatchWorkItem`
    @discardableResult
    static func delay_main_task(
        _ seconds: Double = 0,
        task mainTask: @escaping Callbacks.DispatchQueueTask
    ) -> DispatchWorkItem {
        return DispatchQueue._delay_async(delay: seconds, main: mainTask)
    }

    /// 延时异步执行子线程任务
    /// - Parameters:
    ///   - seconds: 延迟秒数
    ///   - asyncTask: 异步任务
    /// - Returns: `DispatchWorkItem`
    @discardableResult
    static func delay_async_task(
        _ seconds: Double = 0,
        task asyncTask: @escaping Callbacks.DispatchQueueTask
    ) -> DispatchWorkItem {
        return DispatchQueue._delay_async(delay: seconds, async: asyncTask)
    }

    /// `延迟``异步`执行任务, 完成后执行`mainTask`
    /// - Parameter seconds:延迟秒数
    /// - Parameter asyncTask:延时异步任务
    /// - Parameter mainTask:延时完成之后执行的主线程任务
    @discardableResult
    static func delay_async(
        _ seconds: Double = 0,
        async asyncTask: @escaping Callbacks.DispatchQueueTask,
        main mainTask: @escaping Callbacks.DispatchQueueTask
    ) -> DispatchWorkItem {
        DispatchQueue._delay_async(delay: seconds, async: asyncTask, main: mainTask)
    }

    /// `延时``异步`执行
    /// - Parameters:
    ///   - queue: 任务执行的队列
    ///   - seconds: `延迟时间`
    ///   - qos: 优化级
    ///   - flags: 标识
    ///   - work: 要执行的任务
    static func after_async(
        _ queue: DispatchQueue = .main,
        delay seconds: Double,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping () -> Void
    ) {
        queue.asyncAfter(
            deadline: .now() + seconds,
            qos: qos,
            flags: flags,
            execute: work
        )
    }

    /// `防抖``延时`执行
    /// - Parameters:
    ///   - queue: 任务执行的队列
    ///   - seconds: `延迟时间`
    ///   - work: 要执行的任务
    /// - Returns: `block`
    static func debounce(
        _ queue: DispatchQueue = .main,
        delay seconds: Double,
        execute work: @escaping () -> Void
    ) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + seconds }
        return {
            queue.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    work()
                }
            }
        }
    }
}

// MARK: - GCD定时器
public extension SaberExt where Base: DispatchQueue {
    /// `GCD延时`操作
    /// - Parameters:
    ///   - timeInterval:延迟的时间
    ///   - handler: 要执行的任务(`主线程`)
    static func after(
        _ timeInterval: TimeInterval = 0,
        handler: @escaping () -> Void
    ) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + timeInterval,
            execute: handler
        )
    }

    /// `GCD`定时器`倒计时`⏳
    /// - Parameters:
    ///   - timeInterval: 间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环执行任务(`主线程`)
    @discardableResult
    static func countdown(
        _ timeInterval: TimeInterval,
        repeatCount: Int,
        handler: @escaping (DispatchSourceTimer?, Int) -> Void
    ) -> DispatchSourceTimer? {
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

    /// `GCD`定时器`循环`操作
    /// - Parameters:
    ///   - timeInterval:循环间隔时间
    ///   - handler:循环执行任务(`主线程`)
    @discardableResult
    static func interval(
        _ timeInterval: TimeInterval = 1,
        handler: @escaping (DispatchSourceTimer?) -> Void
    ) -> DispatchSourceTimer {
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

// MARK: - 私有扩展
private extension DispatchQueue {
    /// 函数`token`数组
    static var _onceTracker = [String]()

    /// `延时`执行指定任务
    /// - Parameters:
    ///   - seconds: `延迟时间`
    ///   - asyncTask: `异步执行`的`任务`
    ///   - mainTask: `异步任务`完成之后执行的`主线程任务`
    /// - Returns:`DispatchWorkItem`
    static func _delay_async(
        delay seconds: TimeInterval,
        async asyncTask: Callbacks.DispatchQueueTask? = nil,
        main mainTask: Callbacks.DispatchQueueTask? = nil
    ) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: asyncTask ?? {})
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
