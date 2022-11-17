import UIKit

// MARK: - Callbacks(回调闭包别名)
public enum Callbacks {
    public typealias TaskCallback = () -> Void
    public typealias BoolCallback = (Bool) -> Void
    public typealias GestureCallback = (UIGestureRecognizer) -> Void
    public typealias ControlCallback = (UIControl) -> Void
    public typealias ButtonCallback = (UIButton) -> Void
}
