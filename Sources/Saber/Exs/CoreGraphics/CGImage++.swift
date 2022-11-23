import CoreGraphics
import UIKit

extension CGImage: Saberable {}

// MARK: - 方法
public extension SaberEx where Base: CGImage {
    /// `CGImage`转`UIImage`
    /// - Returns: `UIImage?`
    func toUIImage() -> UIImage? {
        return UIImage(cgImage: base)
    }
}
