import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNCone {
    /// 创建具有给定顶径、底径和高度的圆锥体几何体
    /// - Parameters:
    ///   - topDiameter: 圆锥体顶部的直径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - bottomDiameter: 圆锥体底部的直径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间y轴的高度
    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)
    }

    /// 使用给定的顶部半径、底部半径、高度和材质创建圆锥体几何体
    /// - Parameters:
    ///   - topRadius: 圆锥体顶部的半径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - bottomRadius: 圆锥体底部的半径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质
    convenience init(topRadius: CGFloat, bottomRadius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(topRadius: topRadius, bottomRadius: bottomRadius, height: height)
        materials = [material]
    }

    /// 创建具有给定顶径、底径、高度和材质的圆锥体几何体
    /// - Parameters:
    ///   - topDiameter: 圆锥体顶部的直径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - bottomDiameter: 圆锥体底部的直径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质
    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)
        materials = [material]
    }

    /// 使用给定的顶部半径、底部半径、高度和材质创建圆锥体几何体
    /// - Parameters:
    ///   - topRadius: 圆锥体顶部的半径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - bottomRadius: 圆锥体底部的半径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间y轴的高度
    ///   - color: 几何体材质的颜色
    convenience init(topRadius: CGFloat, bottomRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(topRadius: topRadius, bottomRadius: bottomRadius, height: height)
        materials = [SCNMaterial(color: color)]
    }

    /// 创建具有给定顶径、底径、高度和材质的圆锥体几何体
    /// - Parameters:
    ///   - topDiameter: 圆锥体顶部的直径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - bottomDiameter: 圆锥体底部的直径,在其局部坐标空间的x轴和z轴尺寸上形成一个圆
    ///   - height: 圆锥体沿其局部坐标空间y轴的高度
    ///   - color: 几何体材质的颜色
    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)
        materials = [SCNMaterial(color: color)]
    }
}
