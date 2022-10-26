import UIKit

// MARK: - 属性
public extension UICollectionViewCell {
    /// 标识符
    var identifier: String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Self.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }
}

// MARK: - 方法
public extension UICollectionViewCell {
    /// `cell`所在`UICollectionView`
    /// - Returns: `UICollectionView`, 未找到返回`nil`
    func collectionView() -> UICollectionView? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
}
