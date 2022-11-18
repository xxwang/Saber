import UIKit

// MARK: - Callbacks(回调闭包别名)
public enum Callbacks {}

// MARK: - 无参数回调
public extension Callbacks {
    typealias Task = () -> Void
    typealias Completion = () -> Void
}

// MARK: - 单参数回调
public extension Callbacks {
    typealias BoolResult = (_ isOk: Bool) -> Void
    typealias GestureResult = (_ gesture: UIGestureRecognizer) -> Void
    typealias ControlResult = (_ control: UIControl) -> Void
    typealias ButtonResult = (_ button: UIButton) -> Void
}

// MARK: - 多参数回调
public extension Callbacks {
    typealias Result = (_ isOK: Bool, _ message: String?) -> Void
}
