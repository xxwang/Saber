import UIKit

// MARK: - `SkinProvider`协议
public protocol SkinProvider: AnyObject {
    /// 注册监听
    func register<Observer: Skinable>(observer: Observer)
    /// 移除监听
    func remove<Observer: Skinable>(observer: Observer)
    /// 更新主题
    func updateSkin()
}

// MARK: - `Skinable`协议
public protocol Skinable: AnyObject {
    /// 在这个方法中更新主题(前提:遵守`Skinable`协议)
    func apply()
}

// MARK: - 设置遵守`UITraitEnvironment`的可以使用协议`Skinable`
public extension Skinable where Self: UITraitEnvironment {
    // 返回单例对象
    var skinManager: SkinProvider {
        return SkinManager.shared
    }
}

// MARK: - `SkinManager`
public class SkinManager: SkinProvider {
    /// 单例
    static let shared = SkinManager()
    private init() {}

    /// 监听对象数组
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    /// 更新主题
    public func updateSkin() {
        notifyObservers()
    }

    /// 注册监听
    /// - Parameter observer: 监听对象
    public func register<Observer: Skinable>(observer: Observer) {
        if #available(iOS 13.0, *) {
            return
        }
        observers.add(observer)
    }

    /// 移除监听
    /// - Parameter observer: 监听对象
    public func remove<Observer: Skinable>(observer: Observer) {
        if !observers.contains(observer) {
            return
        }
        observers.remove(observer)
    }

    /// 通知监听对象更新`Skin`
    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers
                .allObjects
                .compactMap { $0 as? Skinable }
                .forEach { $0.apply() }
        }
    }
}
