import CoreGraphics
import QuartzCore

extension CATransform3D: Saberable {}

// MARK: - 构造方法
public extension CATransform3D {
    /// 返回一个值为 `(tx, ty, tz)` 的`CATransform3D`
    /// - Parameters:
    ///   - tx:x 轴平移
    ///   - ty:y轴平移
    ///   - tz:z 轴平移
    @inlinable
    init(translationX tx: CGFloat, y ty: CGFloat, z tz: CGFloat) {
        self = CATransform3DMakeTranslation(tx, ty, tz)
    }

    /// 返回一个按 `(sx, sy, sz)` 缩放的`CATransform3D`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y轴缩放
    ///   - sz:z轴缩放
    @inlinable
    init(scaleX sx: CGFloat, y sy: CGFloat, z sz: CGFloat) {
        self = CATransform3DMakeScale(sx, sy, sz)
    }

    /// 返回一个围绕向量 `(x, y, z)` 旋转 `angle` 弧度的`CATransform3D`
    ///
    /// 如果向量的长度为零，则行为未定义
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的z位置
    @inlinable
    init(rotationAngle angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DMakeRotation(angle, x, y, z)
    }
}
