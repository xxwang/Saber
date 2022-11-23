import UIKit

extension UICollectionViewCell: Defaultable {}
public extension UICollectionViewCell {
    /// 关联类型
    typealias Associatedtype = UICollectionViewCell

    /// 创建默认`UICollectionViewCell`
    static func `default`() -> Associatedtype {
        let cell = UICollectionViewCell()
        return cell
    }
}

// MARK: - 属性
public extension SaberEx where Base: UICollectionViewCell {
    /// 标识符
    var identifier: String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Base.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }
}

// MARK: - 方法
public extension SaberEx where Base: UICollectionViewCell {
    /// `cell`所在`UICollectionView`
    /// - Returns:`UICollectionView`, 未找到返回`nil`
    func collectionView() -> UICollectionView? {
        for view in sequence(first: base.superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
}
