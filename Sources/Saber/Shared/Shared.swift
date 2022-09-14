import UIKit

// MARK: - Callbacks(回调闭包别名)
public enum Callbacks {
    /// `DispatchQueue`任务闭包
    public typealias TaskCallback = () -> Void

    /// 完成回调(带`Bool`参数)
    public typealias CompleteBoolCallback = (Bool) -> Void

    /// `UIView`的`UITapGestureRecognizer`回调闭包
    public typealias TapViewCallback = (UITapGestureRecognizer?, UIView, Int) -> Void

    /// `UIGestureRecognizer`回调闭包
    public typealias RecognizerCallback = (UIGestureRecognizer) -> Void

    /// `UIControl`回调闭包
    public typealias ControlCallback = (UIControl) -> Void

    /// `UIButton`回调闭包
    public typealias ButtonCallback = (UIButton) -> Void
}

// MARK: - 关联属性
public enum AssociatedObject {
    /// 设置关联属性
    public static func associate<T>(
        _ object: Any,
        _ key: UnsafeRawPointer,
        _ value: T,
        _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(object, key, value, policy)
    }

    /// 获取关联属性
    public static func object<T>(
        _ object: Any,
        _ key: UnsafeRawPointer
    ) -> T? {
        return objc_getAssociatedObject(object, key) as? T
    }
}

// MARK: - AssociateCompatible(关联属性兼容)
internal protocol AssociateCompatible {
    /// 关联类型
    associatedtype T
    /// 定义回调函数别名
    typealias SwiftCallback = (T?) -> Void
    /// 定义`SwiftCallback`类型的计算属性
    var swiftCallback: SwiftCallback? { get set }
}
