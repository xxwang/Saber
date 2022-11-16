import SceneKit
import UIKit

// MARK: - 属性
public extension SaberExt where Base: SCNGeometry {
    /// 返回几何体边界框的大小
    var boundingSize: SCNVector3 {
        return (base.boundingBox.max - base.boundingBox.min).sb.absolute
    }
}
