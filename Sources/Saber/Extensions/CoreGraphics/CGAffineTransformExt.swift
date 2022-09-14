import CoreGraphics
import UIKit

// MARK: - 属性
public extension CGAffineTransform {
    /// CATransform3D
    @inlinable
    var transform3D: CATransform3D {
        return CATransform3DMakeAffineTransform(self)
    }
}
