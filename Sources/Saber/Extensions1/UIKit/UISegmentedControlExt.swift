import UIKit

// MARK: - 属性
public extension UISegmentedControl {
    /// 标题数组
    var titles: [String] {
        get {
            let range = 0 ..< numberOfSegments
            return range.compactMap { self.titleForSegment(at: $0) }
        }
        set {
            removeAllSegments()
            for (index, title) in newValue.enumerated() {
                insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }

    /// 图片数组
    var images: [UIImage] {
        get {
            let range = 0 ..< numberOfSegments
            return range.compactMap { imageForSegment(at: $0) }
        }
        set {
            removeAllSegments()
            for (index, image) in newValue.enumerated() {
                insertSegment(with: image, at: index, animated: false)
            }
        }
    }
}
