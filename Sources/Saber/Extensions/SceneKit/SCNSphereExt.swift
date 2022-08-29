import SceneKit
import UIKit

    // MARK: - 构造方法
public extension SCNSphere {
        /// 创建具有指定直径的球体几何体
        ///
        /// - Parameter diameter: 球体在其局部坐标空间中的直径
    convenience init(diameter: CGFloat) {
        self.init(radius: diameter / 2)
    }
    
        /// 创建具有指定半径和材质的球体几何体
        /// - Parameters:
        ///   - radius: 球体在其局部坐标空间中的半径
        ///   - material: 几何体的材质
    convenience init(radius: CGFloat, material: SCNMaterial) {
        self.init(radius: radius)
        materials = [material]
    }
    
        /// 创建具有指定半径和材质颜色的球体几何体
        /// - Parameters:
        ///   - radius: 球体在其局部坐标空间中的半径
        ///   - color: 几何体材质的颜色
    convenience init(radius: CGFloat, color: UIColor) {
        self.init(radius: radius, material: SCNMaterial(color: color))
    }
    
        /// 创建具有指定直径和材质的球体几何体
        /// - Parameters:
        ///   - diameter: 球体在其局部坐标空间中的直径
        ///   - material: 几何体的材质
    convenience init(diameter: CGFloat, material: SCNMaterial) {
        self.init(radius: diameter / 2)
        materials = [material]
    }
    
        /// 创建具有指定直径和材质颜色的球体几何体
        /// - Parameters:
        ///   - diameter: 球体在其局部坐标空间中的直径
        ///   - color: 几何体材质的颜色
    convenience init(diameter: CGFloat, color: UIColor) {
        self.init(diameter: diameter, material: SCNMaterial(color: color))
    }
}
