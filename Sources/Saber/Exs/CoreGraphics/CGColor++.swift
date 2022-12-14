import CoreGraphics
import UIKit

extension CGColor: Saberable {}

// MARK: - 方法
public extension SaberEx where Base: CGColor {
    /// `CGColor`转`UIColor`
    /// - Returns: `UIColor`
    func toUIColor() -> UIColor {
        return UIColor(cgColor: base)
    }
}
