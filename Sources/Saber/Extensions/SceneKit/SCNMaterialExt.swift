import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNMaterial {
    /// 使用特定漫反射颜色初始化SCN材质
    /// - Parameter color:漫反射颜色
    convenience init(color: UIColor) {
        self.init()
        diffuse.contents = color
    }
}
