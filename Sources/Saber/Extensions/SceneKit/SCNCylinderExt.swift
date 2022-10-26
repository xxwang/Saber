import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNCylinder {
    /// 创建具有指定直径和高度的圆柱体几何体
    /// - Parameters:
    ///   - diameter: 圆柱体的圆形横截面在其局部坐标空间的x轴和z轴尺寸中的直径
    ///   - height: 圆柱体沿其局部坐标空间y轴的高度
    convenience init(diameter: CGFloat, height: CGFloat) {
        self.init(radius: diameter / 2, height: height)
    }

    /// 创建具有指定半径、高度和材质的圆柱体几何体
    /// - Parameters:
    ///   - radius: 圆柱体在其局部坐标空间的x轴和z轴尺寸中的圆形横截面半径
    ///   - height: 圆柱体沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质
    convenience init(radius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(radius: radius, height: height)
        materials = [material]
    }

    /// 创建具有指定直径、高度和材质的圆柱体几何体
    /// - Parameters:
    ///   - diameter: 圆柱体的圆形横截面在其局部坐标空间的x轴和z轴尺寸中的直径
    ///   - height: 圆柱体沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质
    convenience init(diameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(radius: diameter / 2, height: height)
        materials = [material]
    }

    /// 创建具有指定半径、高度和材质颜色的圆柱体几何体
    /// - Parameters:
    ///   - radius: 圆柱体在其局部坐标空间的x轴和z轴尺寸中的圆形横截面半径
    ///   - height: 圆柱体沿其局部坐标空间y轴的高度
    ///   - color: 几何体材质的颜色
    convenience init(radius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: radius, height: height)
        materials = [SCNMaterial(color: color)]
    }

    /// 创建具有指定直径、高度和材质颜色的圆柱体几何体
    /// - Parameters:
    ///   - diameter: 圆柱体的圆形横截面在其局部坐标空间的x轴和z轴尺寸中的直径
    ///   - height: 圆柱体沿其局部坐标空间y轴的高度
    ///   - color: 几何体材质的颜色
    convenience init(diameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: diameter / 2, height: height)
        materials = [SCNMaterial(color: color)]
    }
}
