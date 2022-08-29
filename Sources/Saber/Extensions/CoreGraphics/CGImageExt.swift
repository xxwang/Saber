import CoreGraphics
import UIKit

    // MARK: - 属性
public extension CGImage {
        /// `UIImage`
    var uiImage: UIImage? {
        return UIImage(cgImage: self)
    }
}
