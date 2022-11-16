import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var functionName = "UIGestureRecognizer" + "functionName"
    static var closure = "UIGestureRecognizer" + "closure"
}

// MARK: - 方法
public extension UIGestureRecognizer {
    /// 移除手势
    func removeFromView() {
        view?.removeGestureRecognizer(self)
    }

    /// 添加手势响应回调
    /// - Parameter closure:响应回调
    func addActionHandler(_ closure: @escaping Callbacks.RecognizerCallback) {
        addTarget(self, action: #selector(p_invoke))
        objc_setAssociatedObject(self, &AssociateKeys.closure, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}

@objc extension UIGestureRecognizer {
    /// 功能名称(用于自定义)
    public var functionName: String {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociateKeys.functionName) as? String {
                return obj
            }
            let string = String(describing: classForCoder)
            objc_setAssociatedObject(self, &AssociateKeys.functionName, string, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return string
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.functionName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 手势响应方法
    private func p_invoke() {
        if let closure = objc_getAssociatedObject(self, &AssociateKeys.closure) as? Callbacks.RecognizerCallback {
            closure(self)
        }
    }
}
