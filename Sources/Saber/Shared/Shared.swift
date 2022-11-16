import UIKit

// MARK: - 关联属性`协议`
internal protocol AssociatedAttributes {
    /// 关联类型
    associatedtype T

    /// 定义回调函数别名
    typealias SwiftCallback = (T?) -> Void

    /// 定义`SwiftCallback`类型的计算属性
    var swiftCallback: SwiftCallback? { get set }
}

// MARK: - 关联属性`操作方法`
public enum AssociatedObject {
    /// 设置关联属性
    static func associate<T>(
        _ object: Any,
        _ key: UnsafeRawPointer,
        _ value: T,
        _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(object, key, value, policy)
    }

    /// 获取关联属性
    static func object<T>(
        _ object: Any,
        _ key: UnsafeRawPointer
    ) -> T? {
        return objc_getAssociatedObject(object, key) as? T
    }
}
