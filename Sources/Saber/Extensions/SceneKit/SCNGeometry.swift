import SceneKit
import UIKit

// MARK: - 属性
public extension SCNGeometry {
    /// 返回几何体边界框的大小
    var boundingSize: SCNVector3 {
        return (boundingBox.max - boundingBox.min).absolute
    }
}
