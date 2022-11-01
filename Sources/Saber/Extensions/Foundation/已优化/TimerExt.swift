import Foundation

// MARK: - 构造方法
public extension Timer {
    /// 使用构造方法创建定时器(需要调用`fire()`)
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行代码的`block`
    convenience init(
        safeTimerWithTimeInterval timeInterval: TimeInterval,
        repeats: Bool,
        block: @escaping ((Timer) -> Void)
    ) {
        if #available(iOS 10.0, *) {
            self.init(timeInterval: timeInterval, repeats: repeats, block: block)
            return
        }
        self.init(timeInterval: timeInterval, target: Timer.self, selector: #selector(Timer.timerCB(timer:)), userInfo: block, repeats: repeats)
    }
}

// MARK: - 静态方法
public extension Timer {
    /// 创建定时器(不需要调用`fire()`)
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行代码的`block`
    /// - Returns: `Timer`
    @discardableResult
    static func safeScheduledTimer(
        timeInterval: TimeInterval,
        repeats: Bool,
        block: @escaping ((Timer) -> Void)
    ) -> Timer {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: block)
        }
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(Timer.timerCB(timer:)), userInfo: block, repeats: repeats)
    }

    /// 创建`C语言`形式的定时器(不需要调用`fire()`)
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - block: 重复执行的`block`
    /// - Returns: `Timer`
    @discardableResult
    static func runThisEvery(
        timeInterval: TimeInterval,
        block: @escaping (Timer?) -> Void
    ) -> Timer? {
        let fireDate = CFAbsoluteTimeGetCurrent()
        guard let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, timeInterval, 0, 0, block) else {
            return nil
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer
    }
}

// MARK: - 私有方法
private extension Timer {
    /// `Timer`执行方法
    /// - Parameter timer: `Timer`
    @objc class func timerCB(timer: Timer) {
        guard let cb = timer.userInfo as? ((Timer) -> Void) else {
            timer.invalidate()
            return
        }
        cb(timer)
    }
}
