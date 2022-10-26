import MJRefresh
import UIKit

// MARK: - 属性
public extension UITableView {
    /// `UITableView`中最后一行的`IndexPath`
    var indexPathForLastRow: IndexPath? {
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }

    /// `UITableView`中最后一组的索引
    var lastSection: Int? {
        return numberOfSections > 0 ? numberOfSections - 1 : nil
    }
}

// MARK: - MJRefresh
public extension UITableView {
    /// 设置头部刷新控件(下拉刷新)
    func setupHeaderRefreshing(refreshingCallback: @escaping MJRefreshComponentAction) {
        let header = MJRefreshNormalHeader(refreshingBlock: refreshingCallback)
        mj_header = header
    }

    /// 设置底部刷新控件(上拉加载更多)
    func setupFooterRefreshing(refreshingCallback: @escaping MJRefreshComponentAction, noMoreDataText: String = "已经到底了") {
        let footer = MJRefreshBackNormalFooter(refreshingBlock: refreshingCallback)
        footer.setTitle(noMoreDataText, for: .noMoreData)
        mj_footer = footer
    }

    /// 结束刷新动作
    func endRefreshing(_ moreData: Bool = true) {
        // 结束下拉刷新
        endHeaderRefreshing()
        // 结束上拉刷新
        endFooterRefreshing(moreData)
    }

    /// 结束下拉刷新
    func endHeaderRefreshing() {
        mj_header?.endRefreshing()
    }

    /// 结束上拉刷新
    func endFooterRefreshing(_ moreData: Bool) {
        if moreData {
            mj_footer?.endRefreshing()
        } else {
            mj_footer?.endRefreshingWithNoMoreData()
        }
    }
}

// MARK: - 方法
public extension UITableView {
    /// `UITableView` 适配
    func adaptationTableView() {
        if #available(iOS 11, *) {
            self.estimatedRowHeight = 0
            self.estimatedSectionFooterHeight = 0
            self.estimatedSectionHeaderHeight = 0
            self.contentInsetAdjustmentBehavior = .never
        }
    }

    /// `UITableView`所有组中的所有行数总和
    /// - Returns: `UITableView`中所有行的总数
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }

    /// 指定组中最后一行的`indexath`
    /// - Parameter section: 要获取最后一行的组
    /// - Returns: 组中最后一行的可选`IndexPath`(没有返回`nil`)
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard numberOfSections > 0, section >= 0 else { return nil }
        guard numberOfRows(inSection: section) > 0 else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }

    /// 重新加载数据后调用`completion`回调
    /// - Parameter completion: 完成回调
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    /// 移除`tableFooterView`.
    func removeTableFooterView() {
        tableFooterView = nil
    }

    /// 移除`tableHeaderView`.
    func removeTableHeaderView() {
        tableHeaderView = nil
    }

    /// 检查`IndexPath`在`UITableView`中是否存在
    /// - Parameter indexPath: 要检查的`indexPath`
    /// - Returns: 是否存在
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.row >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.row < numberOfRows(inSection: indexPath.section)
    }

    /// 是否滚动到顶部
    /// - Parameter animated: 是否要动画
    func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }

    /// 是否滚动到底部
    /// - Parameter animated: 是否要动画
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 {
            return
        }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }

    /// 滚动到什么位置(CGPoint)
    /// - Parameter animated: 是否要动画
    func scrollToOffset(offsetX: CGFloat = 0, offsetY: CGFloat = 0, animated: Bool) {
        setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: animated)
    }

    /// 安全地滚动到指定的`IndexPath`
    /// - Parameters:
    ///   - indexPath: 要滚动到的目标`indexPath`
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否设置动画
    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }

    /// 使用类名注册`UITableViewCell`
    /// - Parameter name: `UITableViewCell`类型
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册`UITableViewCell`
    /// - Parameters:
    ///   - nib: 用于创建`UITableViewCell`的nib文件
    ///   - name: `UITableViewCell`类型
    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }

    /// 注册`UITableViewCell`,使用其对应类的xib文件
    /// 假设`xib`文件名和cell类具有相同的名称
    /// - Parameters:
    ///   - name: `UITableViewCell`类型
    ///   - bundleClass: `bundle`实例基于的类
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }

    /// 使用类名获取可重用`UITableViewCell`
    /// - Parameter name: `UITableViewCell`类型
    /// - Returns: 类名关联的`UITableViewCell`对象
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    /// 使用`类名`和`indexPath`获取可重用`UITableViewCell`
    /// - Parameters:
    ///   - name: `UITableViewCell`类型
    ///   - indexPath: 单元格在`tableView`中的位置
    /// - Returns: 类名关联的`UITableViewCell`对象
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    /// 使用类名注册`UITableViewHeaderFooterView`
    /// - Parameters:
    ///   - nib: 用于创建页眉或页脚视图的`nib`文件
    ///   - name: `UITableViewHeaderFooterView`类型
    func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册`UITableViewHeaderFooterView`
    /// - Parameter name: `UITableViewHeaderFooterView`类型
    func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// 使用类名获取可重用`UITableViewHeaderFooterView`
    /// - Parameter name: `UITableViewHeaderFooterView`类型
    /// - Returns: 类名关联的`UITableViewHeaderFooterView`对象
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }
}

// MARK: - 链式语法
public extension UITableView {
    /// 创建默认`UITableView`
    static var defaultTableView: UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
            .rowHeight(UITableView.automaticDimension)
            .estimatedRowHeight(50)
            .backgroundColor(.clear)
            .sectionHeaderHeight(0.001)
            .sectionFooterHeight(0.001)
            .showsHorizontalScrollIndicator(false)
            .showsVerticalScrollIndicator(false)
            .cellLayoutMarginsFollowReadableWidth(false)
            .separatorStyle(.none)
            .keyboardDismissMode(.onDrag)

        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        return tableView
    }

    /// 设置 `delegate`
    /// - Parameter delegate: `delegate`
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 `dataSource` 代理
    /// - Parameter dataSource: `dataSource`
    /// - Returns: `Self`
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 注册`cell`
    /// - Returns: `Self`
    @discardableResult
    func register<T: UITableViewCell>(_ cell: T.Type) -> Self {
        register(cellWithClass: T.self)
        return self
    }

    /// 设置行高
    /// - Parameter height: 行高
    /// - Returns: `Self`
    @discardableResult
    func rowHeight(_ height: CGFloat) -> Self {
        rowHeight = height
        return self
    }

    /// 设置段头(`sectionHeaderHeight`)的高度
    /// - Parameter height: 组头的高度
    /// - Returns: `Self`
    @discardableResult
    func sectionHeaderHeight(_ height: CGFloat) -> Self {
        sectionHeaderHeight = height
        return self
    }

    /// 设置组脚(`sectionFooterHeight`)的高度
    /// - Parameter height: 组脚的高度
    /// - Returns: `Self`
    @discardableResult
    func sectionFooterHeight(_ height: CGFloat) -> Self {
        sectionFooterHeight = height
        return self
    }

    /// 设置一个默认(预估)`cell`高度
    /// - Parameter height: 默认`cell`高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> Self {
        estimatedRowHeight = height
        return self
    }

    /// 设置默认段头(`estimatedSectionHeaderHeight`)高度
    /// - Parameter height: 组头高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        estimatedSectionHeaderHeight = height
        return self
    }

    /// 设置默认组脚(`estimatedSectionFooterHeight`)高度
    /// - Parameter height: 组脚高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        estimatedSectionFooterHeight = height
        return self
    }

    /// 键盘消息模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        keyboardDismissMode = mode
        return self
    }

    /// `Cell`是否自动缩进
    /// - Parameter cellLayoutMarginsFollowReadableWidth: 是否留白
    /// - Returns: `Self`
    @discardableResult
    func cellLayoutMarginsFollowReadableWidth(_ cellLayoutMarginsFollowReadableWidth: Bool) -> Self {
        self.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        return self
    }

    /// 设置分割线的样式
    /// - Parameter style: 分割线的样式
    /// - Returns: `Self`
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle = .none) -> Self {
        separatorStyle = style
        return self
    }

    /// 设置 `UITableView` 的头部 `tableHeaderView`
    /// - Parameter head: 头部 View
    /// - Returns: `Self`
    @discardableResult
    func tableHeaderView(_ head: UIView?) -> Self {
        tableHeaderView = head
        return self
    }

    /// 设置 `UITableView` 的尾部 `tableFooterView`
    /// - Parameter foot: 尾部 `View`
    /// - Returns: `Self`
    @discardableResult
    func tableFooterView(_ foot: UIView?) -> Self {
        tableFooterView = foot
        return self
    }

    /// 滚动到指定`IndexPath`
    /// - Parameters:
    ///   - indexPath: 要滚动到的`cell``IndexPath`
    ///   - scrollPosition: 滚动的方式
    ///   - animated: 是否要动画
    /// - Returns: `Self`
    @discardableResult
    func scroll(to indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        if indexPath.section < 0 || indexPath.row < 0 || indexPath.section > numberOfSections || indexPath.row > numberOfRows(inSection: indexPath.section) {
            return self
        }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到第几行、第几组
    /// - Parameters:
    ///   - row: 第几行
    ///   - section: 第几组
    ///   - scrollPosition: 滚动的方式
    ///   - animated: 是否要动画
    /// - Returns: `Self`
    @discardableResult
    func scroll(row: Int, section: Int = 0, at scrollPosition: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        return scroll(to: IndexPath(row: row, section: section), at: scrollPosition, animated: animated)
    }

    /// 滚动到最近选中的`cell`(选中的`cell`消失在屏幕中,触发事件可以滚动到选中的`cell`)
    /// - Parameters:
    ///   - scrollPosition: 滚动的方式
    ///   - animated: 是否要动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToNearestSelectedRow(scrollPosition: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
        return self
    }
}
