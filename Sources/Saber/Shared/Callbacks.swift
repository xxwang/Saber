import UIKit

// MARK: - Callbacks(回调闭包别名)
public enum Callbacks {
    public typealias DispatchQueueTask = () -> Void

    public typealias BoolTask = (Bool) -> Void

    public typealias GestureTask = (UIGestureRecognizer) -> Void
    public typealias ControlTask = (UIControl) -> Void
    public typealias ButtonTask = (UIButton) -> Void
}
