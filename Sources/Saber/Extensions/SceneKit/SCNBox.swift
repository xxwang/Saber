import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNBox {
    /// 创建具有指定宽度、高度和长度的长方体几何图形
    /// - Parameters:
    ///   - width:框沿其局部坐标空间x轴的宽度
    ///   - height:长方体沿其局部坐标空间y轴的高度
    ///   - length:长方体沿其局部坐标空间z轴的长度
    convenience init(width: CGFloat, height: CGFloat, length: CGFloat) {
        self.init(width: width, height: height, length: length, chamferRadius: 0)
    }

    /// 创建具有指定边长和倒角半径的立方体几何体
    /// - Parameters:
    ///   - sideLength:框在其局部坐标空间中的宽度、高度和长度
    ///   - chamferRadius:盒子边缘和角落的曲率半径
    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)
    }

    /// 创建具有指定宽度、高度、长度、倒角半径和材质的长方体几何图形
    /// - Parameters:
    ///   - width:框沿其局部坐标空间x轴的宽度
    ///   - height:长方体沿其局部坐标空间y轴的高度
    ///   - length:长方体沿其局部坐标空间z轴的长度
    ///   - chamferRadius:盒子边缘和角落的曲率半径
    ///   - material:几何体的材质
    convenience init(width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat = 0, material: SCNMaterial) {
        self.init(width: width, height: height, length: length, chamferRadius: chamferRadius)
        materials = [material]
    }

    /// 创建具有指定边长、倒角半径和材质的立方体几何体
    /// - Parameters:
    ///   - sideLength:框在其局部坐标空间中的宽度、高度和长度
    ///   - chamferRadius:盒子边缘和角落的曲率半径
    ///   - material:几何体的材质
    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0, material: SCNMaterial) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)
        materials = [material]
    }

    /// 创建具有指定宽度、高度、长度、倒角半径和材质颜色的长方体几何图形
    /// - Parameters:
    ///   - width:框沿其局部坐标空间x轴的宽度
    ///   - height:长方体沿其局部坐标空间y轴的高度
    ///   - length:长方体沿其局部坐标空间z轴的长度
    ///   - chamferRadius:盒子边缘和角落的曲率半径
    ///   - color:几何体材质的颜色
    convenience init(width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat = 0, color: UIColor) {
        self.init(width: width, height: height, length: length, chamferRadius: chamferRadius)
        materials = [SCNMaterial(color: color)]
    }

    /// 创建具有指定边长、倒角半径和材质颜色的立方体几何体
    /// - Parameters:
    ///   - sideLength:框在其局部坐标空间中的宽度、高度和长度
    ///   - chamferRadius:盒子边缘和角落的曲率半径
    ///   - color:几何体材质的颜色
    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0, color: UIColor) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)
        materials = [SCNMaterial(color: color)]
    }
}
