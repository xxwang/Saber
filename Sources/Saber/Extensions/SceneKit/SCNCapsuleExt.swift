import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNCapsule {
    /// 创建具有指定直径和高度的胶囊几何体
    /// - Parameters:
    ///   - capDiameter: 胶囊圆柱形主体及其半球形端部的直径
    ///   - height: 胶囊沿其局部坐标空间y轴的高度
    convenience init(capDiameter: CGFloat, height: CGFloat) {
        self.init(capRadius: capDiameter / 2, height: height)
    }

    /// 创建具有指定半径和高度的胶囊几何体
    /// - Parameters:
    ///   - capRadius: 胶囊圆柱形主体及其半球形端部的半径
    ///   - height: 胶囊沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质
    convenience init(capRadius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(capRadius: capRadius, height: height)
        materials = [material]
    }

    /// 创建具有指定直径和高度的胶囊几何体
    /// - Parameters:
    ///   - capDiameter: 胶囊圆柱形主体及其半球形端部的直径
    ///   - height: 胶囊沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质
    convenience init(capDiameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(capRadius: capDiameter / 2, height: height)
        materials = [material]
    }

    /// 创建具有指定半径和高度的胶囊几何体
    /// - Parameters:
    ///   - capRadius: 胶囊圆柱形主体及其半球形端部的半径
    ///   - height: 胶囊沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质
    convenience init(capRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capRadius, height: height)
        materials = [SCNMaterial(color: color)]
    }

    /// 创建具有指定直径和高度的胶囊几何体
    /// - Parameters:
    ///   - capDiameter: 胶囊圆柱形主体及其半球形端部的直径
    ///   - height: 胶囊沿其局部坐标空间y轴的高度
    ///   - material: 几何体的材质几何体的材质
    convenience init(capDiameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capDiameter / 2, height: height)
        materials = [SCNMaterial(color: color)]
    }
}
