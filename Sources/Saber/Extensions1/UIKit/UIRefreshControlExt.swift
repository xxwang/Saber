import UIKit

// MARK: -  方法
public extension UIRefreshControl {
    /// 在UITableView开始刷新控件
    ///
    /// - Parameters:
    ///   - tableView:UITableView实例,其中包含刷新控件
    ///   - animated:布尔值,表示内容偏移是否应设置动画
    ///   - sendAction:表示应该为valueChanged事件触发uicontrol的sendActions方法
    func beginRefreshing(in tableView: UITableView, animated: Bool, sendAction: Bool = false) {
        assert(superview == tableView, "Refresh control does not belong to the receiving table view")

        beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -frame.height)
        tableView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            sendActions(for: .valueChanged)
        }
    }

    /// 在UIScrollView中开始刷新控件
    ///
    /// - Parameters:
    ///   - animated:布尔值,表示内容偏移是否应设置动画
    ///   - sendAction:表示应该为valueChanged事件触发uicontrol的sendActions方法
    func beginRefreshing(animated: Bool, sendAction: Bool = false) {
        guard let scrollView = superview as? UIScrollView else {
            assertionFailure("Refresh control does not belong to a scroll view")
            return
        }

        beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -frame.height)
        scrollView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            sendActions(for: .valueChanged)
        }
    }
}
