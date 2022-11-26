import UIKit

// MARK: -  方法
public extension SaberEx where Base: UIRefreshControl {
    /// 在`UITableView`开始刷新控件
    ///
    /// - Parameters:
    ///   - tableView:`UITableView`实例,其中包含刷新控件
    ///   - animated:布尔值,表示内容偏移是否应设置动画
    ///   - sendAction:表示应该为`valueChanged`事件触发`UIControl`的`sendActions`方法
    func beginRefreshing(in tableView: UITableView, animated: Bool, sendAction: Bool = false) {
        assert(base.superview == tableView, "Refresh control does not belong to the receiving table view")

        base.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -base.frame.height)
        tableView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            base.sendActions(for: .valueChanged)
        }
    }

    /// 在`UIScrollView`中开始刷新控件
    ///
    /// - Parameters:
    ///   - animated:布尔值,表示内容偏移是否应设置动画
    ///   - sendAction:表示应该为`valueChanged`事件触发`UIControl`的`sendActions`方法
    func beginRefreshing(animated: Bool, sendAction: Bool = false) {
        guard let scrollView = base.superview as? UIScrollView else {
            assertionFailure("Refresh control does not belong to a scroll view")
            return
        }

        base.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -base.frame.height)
        scrollView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            base.sendActions(for: .valueChanged)
        }
    }
}

public extension UIRefreshControl {
    /// 关联类型
    typealias Associatedtype = UIRefreshControl

    /// 创建默认`UIRefreshControl`
    @objc override class func `default`() -> Associatedtype {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }
}
