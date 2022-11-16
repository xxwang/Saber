import UIKit

// MARK: - Callbacks(回调闭包别名)
public enum Callbacks {
    /// `DispatchQueue`任务代码块
    public typealias DispatchQueueTask = () -> Void

    /// 完成回调(带`Bool`参数)
    public typealias CompleteBoolCallback = (Bool) -> Void
    BoolResult

    /// `UIView`的`UITapGestureRecognizer`回调闭包
    public typealias TapViewCallback = (UITapGestureRecognizer?, UIView, Int) -> Void

    /// `UIGestureRecognizer`回调闭包
    public typealias RecognizerCallback = (UIGestureRecognizer) -> Void

    /// `UIControl`回调闭包
    public typealias ControlCallback = (UIControl) -> Void

    /// `UIButton`回调闭包
    public typealias ButtonCallback = (UIButton) -> Void
}
