import UIKit

// MARK: - 静态属性
public extension SaberEx where Base: UIStoryboard {
    /// 获取应用程序的主`UIStoryboard`
    static var main: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }
}

// MARK: - 方法
public extension SaberEx where Base: UIStoryboard {
    /// 使用`UIStoryboard`实例化指定类型控制器(`UIViewController`类或其子类)
    /// - Parameter name:`UIViewController`类型
    /// - Returns:与指定类名对应的视图控制器
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return base.instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
}
