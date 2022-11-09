import CoreGraphics
import UIKit

// MARK: - 属性
public extension CGColor {
    /// `CGColor`转`UIColor`
    var uiColor: UIColor? {
        return UIColor(cgColor: self)
    }
}
