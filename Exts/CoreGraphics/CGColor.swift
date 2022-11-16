import CoreGraphics
import UIKit

// MARK: - 方法
public extension SaberExt where Base: CGColor {
    /// `CGColor`转`UIColor`
    /// - Returns: `UIColor`
    func toUIColor() -> UIColor {
        return UIColor(cgColor: base)
    }
}