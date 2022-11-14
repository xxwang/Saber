import CoreGraphics
import UIKit

// MARK: - 属性
public extension CGImage {
    /// `CGImage`转`UIImage`
    var uiImage: UIImage? {
        return UIImage(cgImage: self)
    }
}
