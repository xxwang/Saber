import CoreGraphics
import UIKit

// MARK: - 方法
public extension SaberExt where Base == CGAffineTransform {
    /// `CGAffineTransform`转`CATransform3D`
    /// - Returns: `CATransform3D`
    func toCATransform3D() -> CATransform3D {
        return CATransform3DMakeAffineTransform(base)
    }
}
