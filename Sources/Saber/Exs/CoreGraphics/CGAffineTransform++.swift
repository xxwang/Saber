import CoreGraphics
import UIKit

extension CGAffineTransform: Saberable {}

// MARK: - 方法
public extension SaberEx where Base == CGAffineTransform {
    /// `CGAffineTransform`转`CATransform3D`
    /// - Returns: `CATransform3D`
    func toCATransform3D() -> CATransform3D {
        return CATransform3DMakeAffineTransform(base)
    }
}
