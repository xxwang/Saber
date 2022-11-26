import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var FunctionNameKey = "UIGestureRecognizer" + "FunctionNameKey"
    static var CallbackKey = "UIGestureRecognizer" + "CallbackKey"
}

// MARK: - 属性
public extension SaberEx where Base: UIGestureRecognizer {
    /// 功能名称(用于自定义`标识`)
    var functionName: String {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociateKeys.FunctionNameKey) as? String {
                return obj
            }
            let string = String(describing: base.classForCoder)
            objc_setAssociatedObject(self, &AssociateKeys.FunctionNameKey, string, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return string
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.FunctionNameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - 方法
public extension SaberEx where Base: UIGestureRecognizer {
    /// 移除手势
    func remove() {
        base.view?.removeGestureRecognizer(base)
    }

    /// 添加手势响应回调
    /// - Parameter callback:响应回调
    func addCallback(_ callback: @escaping Callbacks.GestureResult) {
        base.addTarget(base, action: #selector(base.p_invoke))
        objc_setAssociatedObject(base, &AssociateKeys.CallbackKey, callback, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}

// MARK: - 私有方法
private extension UIGestureRecognizer {
    /// 手势响应方法
    @objc func p_invoke() {
        if let callback = objc_getAssociatedObject(self, &AssociateKeys.CallbackKey) as? Callbacks.GestureResult {
            callback(self)
        }
    }
}
