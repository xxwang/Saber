import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNShape {
    /// 创建具有指定路径、拉伸深度和材质的形状几何体
    /// - Parameters:
    ///   - path:构成形状基础的二维路径
    ///   - extrusionDepth:沿z轴拉伸形状的厚度
    ///   - material:几何体的材质
    convenience init(path: UIBezierPath, extrusionDepth: CGFloat, material: SCNMaterial) {
        self.init(path: path, extrusionDepth: extrusionDepth)
        materials = [material]
    }

    /// 创建具有指定路径、拉伸深度和材质颜色的形状几何体
    /// - Parameters:
    ///   - path:构成形状基础的二维路径
    ///   - extrusionDepth:沿z轴拉伸形状的厚度
    ///   - color:几何体材质的颜色
    convenience init(path: UIBezierPath, extrusionDepth: CGFloat, color: UIColor) {
        self.init(path: path, extrusionDepth: extrusionDepth)
        materials = [SCNMaterial(color: color)]
    }
}
