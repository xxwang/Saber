import UIKit

// MARK: - 属性
public extension SaberEx where Base: UITableViewCell {
    /// 标识符
    var identifier: String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Base.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }
}

// MARK: - 方法
public extension SaberEx where Base: UITableViewCell {
    /// `cell`所在`UITableView`
    /// - Returns:`UITableView`, 未找到返回`nil`
    func tableView() -> UITableView? {
        for view in sequence(first: base.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}

extension UITableViewCell: Defaultable {}
public extension UITableViewCell {
    /// 关联类型
    typealias Associatedtype = UITableViewCell

    /// 创建默认`UITableViewCell`
    static func `default`() -> Associatedtype {
        let cell = UITableViewCell()
        return cell
    }
}

// MARK: - 链式语法
public extension UITableViewCell {
    /// 设置`UITableViewCell`选中样式
    /// - Parameter style:样式
    /// - Returns:`Self`
    @discardableResult
    func selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        selectionStyle = style
        return self
    }
}
