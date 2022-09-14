import CoreGraphics
import Foundation

// MARK: - 属性
public extension NSObject {
    /// 获取对象类名(需要继承自`NSObject`)
    var className: String {
        let name = type(of: self).description()
        if name.contains(".") {
            return name.components(separatedBy: ".").last ?? ""
        } else {
            return name
        }
    }
}

// MARK: - 静态属性
public extension NSObject {
    /// 获取类的类名(需要继承自`NSObject`)
    static var className: String {
        return String(describing: self)
    }
}

// MARK: - Runtime
public extension NSObject {
    /// 利用运行时获取类里面的成员变量
    /// - Returns: 成员变量名数组
    @discardableResult
    static func printIvars() -> [String] {
        // 成员变量名字
        var propertyNames = [String]()
        // 成员变量数量
        var count: UInt32 = 0
        // ivars是一个数组
        let ivars = class_copyIvarList(Self.self, &count)
        for i in 0 ..< count {
            // ivar是一个结构体的指针
            let ivar = ivars![Int(i)]
            // 获取 成员变量的名称,cName c语言的字符串,首元素地址
            let cName = ivar_getName(ivar)
            let name = String(cString: cName!, encoding: String.Encoding.utf8)
            propertyNames.append(name ?? "没有内容")
        }
        // 方法中有copy,create,的都需要释放
        free(ivars)
        return propertyNames
    }
}

// MARK: - 交换方法
@objc public extension NSObject {
    ///

    /// 方法交换
    /// - Parameters:
    ///   - origSel: 原方法
    ///   - replSel: 新方法
    ///   - isClassMethod: 是否是类方法
    /// - Returns: 是否交换成功
    class func hookMethod(of origSel: Selector, with replSel: Selector, isClassMethod: Bool) -> Bool {
        let clz: AnyClass = classForCoder()

        guard let oriMethod = (isClassMethod ? class_getClassMethod(clz, origSel) : class_getClassMethod(clz, origSel)) as Method?,
              let repMethod = (isClassMethod ? class_getClassMethod(clz, replSel) : class_getClassMethod(clz, replSel)) as Method?
        else {
            Debug.Info("Swizzling Method(s) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }

        // 在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(clz, origSel, method_getImplementation(repMethod), method_getTypeEncoding(repMethod))

        /*
         如果 class_addMethod返回true,说明当前类中没有要替换方法的实现,所以需要在父类中查找,
         这时候就用到method_getImplementation去获取class_getInstanceMethod里面的方法实现,
         然后再进行class_replaceMethod来实现Swizzing
         */
        if didAddMethod {
            class_replaceMethod(clz, replSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, repMethod)
        }
        return true
    }

    /// 交换实例对象方法
    /// - Parameters:
    ///   - origSel: 原 实例方法
    ///   - replSel: 新 实例方法
    /// - Returns: 是否成功
    class func hookInstanceMethod(of origSel: Selector, with replSel: Selector) -> Bool {
        let clz: AnyClass = classForCoder()
        guard let oriMethod = class_getInstanceMethod(clz, origSel) as Method? else {
            Debug.Info("原 实例方法：Swizzling Method(\(origSel)) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }

        guard let repMethod = class_getInstanceMethod(clz, replSel) as Method? else {
            Debug.Info("新 实例方法：Swizzling Method(\(replSel)) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }

        // 判断类中是否存在要替换方法的实现
        let didAddMethod: Bool = class_addMethod(clz, origSel, method_getImplementation(repMethod), method_getTypeEncoding(repMethod))

        /*
         如果 class_addMethod返回true,说明当前类中没有要替换方法的实现,所以需要在父类中查找,
         这时候就用到method_getImplementation去获取class_getInstanceMethod里面的方法实现,
         然后再进行class_replaceMethod来实现Swizzing
         */
        if didAddMethod {
            class_replaceMethod(clz, replSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, repMethod)
        }
        return true
    }

    /// 交换类方法
    /// - Parameters:
    ///   - origSel: 原 类方法
    ///   - replSel: 新 类方法
    /// - Returns: 是否成功
    class func hookClassMethod(of origSel: Selector, with replSel: Selector) -> Bool {
        let clz: AnyClass = classForCoder()

        guard let oriMethod = class_getClassMethod(clz, origSel) as Method? else {
            Debug.Info("原 类方法：Swizzling Method(\(origSel)) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }

        guard let repMethod = class_getClassMethod(clz, replSel) as Method? else {
            Debug.Info("新 类方法 replSel：Swizzling Method(\(replSel)) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false
        }

        // 在进行Swizzling的时候,需要用 class_addMethod先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(clz, origSel, method_getImplementation(repMethod), method_getTypeEncoding(repMethod))
        /*
         如果class_addMethod返回true,说明当前类中没有要替换方法的实现,所以需要在父类中查找,
         这时候就用到method_getImplemetation去获取 class_getInstanceMethod里面的方法实现,
         然后再进行class_replaceMethod来实现Swizzing
         */
        if didAddMethod {
            class_replaceMethod(clz, replSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, repMethod)
        }
        return true
    }
}

@objc public extension NSObject {
    /// 初始化方法
    class func initializeMethod() {
        if self != NSObject.self {
            return
        }

        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
        DispatchQueue.once(token: onceToken) {
            let oriSel = #selector(self.setValue(_:forUndefinedKey:))
            let repSel = #selector(self.hook_setValue(_:forUndefinedKey:))
            _ = hookInstanceMethod(of: oriSel, with: repSel)

            let oriSel0 = #selector(self.value(forUndefinedKey:))
            let repSel0 = #selector(self.hook_value(forUndefinedKey:))
            _ = hookInstanceMethod(of: oriSel0, with: repSel0)

            let oriSel1 = #selector(self.setNilValueForKey(_:))
            let repSel1 = #selector(self.hook_setNilValueForKey(_:))
            _ = hookInstanceMethod(of: oriSel1, with: repSel1)

            let oriSel2 = #selector(self.setValuesForKeys(_:))
            let repSel2 = #selector(self.hook_setValuesForKeys(_:))
            _ = hookInstanceMethod(of: oriSel2, with: repSel2)
        }
    }

    /// 如果键不存在会调用这个方法
    private func hook_setValue(_ value: Any?, forUndefinedKey key: String) {
        Debug.Warning("setValue: forUndefinedKey:, 未知键Key: \(key) 值:\(value ?? "")")
    }

    /// 如果键不存在会调用这个方法
    private func hook_value(forUndefinedKey key: String) -> Any? {
        Debug.Warning("valueForUndefinedKey:, 未知键: \(key)")
        return nil
    }

    /// 给一个非指针对象(如`NSInteger`)赋值 nil, 直接忽略
    private func hook_setNilValueForKey(_ key: String) {
        Debug.Info("Invoke setNilValueForKey:, 不能给非指针对象(如NSInteger)赋值 nil 键: \(key)")
    }

    private func hook_setValuesForKeys(_ keyedValues: [String: Any]) {
        for (key, value) in keyedValues {
            Debug.Info(key, value)
            if value is Int || value is CGFloat || value is Double {
                setValue("\(value)", forKey: key)
            } else {
                setValue(value, forKey: key)
            }
        }
    }
}
