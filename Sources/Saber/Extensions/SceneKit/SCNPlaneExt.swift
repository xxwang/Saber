import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNPlane {
    /// 创建具有指定宽度的方形平面几何图形
    /// - Parameters width: 平面沿其局部坐标空间的x轴和y轴的宽度和高度
    convenience init(width: CGFloat) {
        self.init(width: width, height: width)
    }

    /// 创建具有指定宽度、高度和材质的平面几何图形
    /// - Parameters:
    ///   - width: 平面沿其局部坐标空间x轴的宽度
    ///   - height: 平面沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质
    convenience init(width: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(width: width, height: height)
        materials = [material]
    }

    /// 创建具有指定宽度和材质的方形平面几何图形
    /// - Parameters:
    ///   - width: 平面沿其局部坐标空间的x轴和y轴的宽度和高度
    ///   - material: 几何体的材质
    convenience init(width: CGFloat, material: SCNMaterial) {
        self.init(width: width, height: width)
        materials = [material]
    }

    /// 创建具有指定宽度、高度和材质颜色的平面几何体
    /// - Parameters:
    ///   - width: 平面沿其局部坐标空间x轴的宽度
    ///   - height: 平面沿其局部坐标空间y轴的高度
    ///   - color: 几何体材质的颜色
    convenience init(width: CGFloat, height: CGFloat, color: UIColor) {
        self.init(width: width, height: height)
        materials = [SCNMaterial(color: color)]
    }

    /// 创建具有指定宽度和材质颜色的方形平面几何体
    /// - Parameters:
    ///   - width: 平面沿其局部坐标空间的x轴和y轴的宽度和高度
    ///   - color: 几何体材质的颜色
    convenience init(width: CGFloat, color: UIColor) {
        self.init(width: width, height: width)
        materials = [SCNMaterial(color: color)]
    }
}
