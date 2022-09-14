import CoreGraphics
import UIKit

// MARK: - 属性
public extension CGColor {
    /// UIColor
    var uiColor: UIColor? {
        return UIColor(cgColor: self)
    }
}
