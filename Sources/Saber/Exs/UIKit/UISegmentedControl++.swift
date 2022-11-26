import UIKit

// MARK: - 属性
public extension SaberEx where Base: UISegmentedControl {
    /// 标题数组
    var titles: [String] {
        get {
            let range = 0 ..< base.numberOfSegments
            return range.compactMap { base.titleForSegment(at: $0) }
        }
        set {
            base.removeAllSegments()
            for (index, title) in newValue.enumerated() {
                base.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }

    /// 图片数组
    var images: [UIImage] {
        get {
            let range = 0 ..< base.numberOfSegments
            return range.compactMap { base.imageForSegment(at: $0) }
        }
        set {
            base.removeAllSegments()
            for (index, image) in newValue.enumerated() {
                base.insertSegment(with: image, at: index, animated: false)
            }
        }
    }
}

public extension UISegmentedControl {
    /// 关联类型
    typealias Associatedtype = UISegmentedControl

    /// 创建默认`UISegmentedControl`
    @objc override class func `default`() -> Associatedtype {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }
}
