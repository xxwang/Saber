import MJRefresh
import UIKit

// MARK: - 属性
public extension UICollectionView {
    /// `UICollectionView`中最后一项的`IndexPath`
    var indexPathForLastItem: IndexPath? {
        return self.indexPathForLastItem(inSection: lastSection)
    }

    /// `UICollectionView`中最后一组的索引
    var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
}

// MARK: - MJRefresh
public extension UICollectionView {
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

// MARK: - 移动
public extension UICollectionView {
    /// 添加长按手势
    func allowsMoveItem() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGestureHandler))
        addGestureRecognizer(longPressGesture)
    }

    /// 移除长按手势
    func disableMoveItem() {
        let longPressGesture = gestureRecognizers?.filter { gestureRecognizer in
            gestureRecognizer is UILongPressGestureRecognizer
        }.first as? UILongPressGestureRecognizer

        guard let longPGR = longPressGesture else {
            return
        }
        removeGestureRecognizer(longPGR)
    }

    /// 长按手势处理
    @objc private func longGestureHandler(_ longPressGR: UILongPressGestureRecognizer) {
        switch longPressGR.state {
        // 开始移动
        case UIGestureRecognizer.State.began:
            let point = longPressGR.location(in: longPressGR.view!)
            if let selectedIndexPath = indexPathForItem(at: point) {
                // 开始移动
                beginInteractiveMovementForItem(at: selectedIndexPath)
            }
        case UIGestureRecognizer.State.changed:
            // 移动中
            let point = longPressGR.location(in: longPressGR.view!)
            updateInteractiveMovementTargetPosition(point)
        case UIGestureRecognizer.State.ended:
            // 结束移动
            endInteractiveMovement()
        default:
            // 取消移动
            cancelInteractiveMovement()
        }
    }
}

// MARK: - 方法
public extension UICollectionView {
    /// `UICollectionView`所有组中的`item`总数量
    /// - Returns:`item`总数量
    func numberOfItems() -> Int {
        var section = 0
        var itemsCount = 0
        while section < numberOfSections {
            itemsCount += numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }

    /// 获取指定`Section`中的最后一个`item`的`IndexPath`
    /// - Parameter section:要获取最后一个Item的组
    /// - Returns:指定Section中的最后一个item的IndexPath
    func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < numberOfSections else {
            return nil
        }
        guard numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: numberOfItems(inSection: section) - 1, section: section)
    }

    /// 检查`IndexPath`在`UICollectionView`中是否存在
    /// - Parameter indexPath:要检查的`IndexPath`
    /// - Returns:是否存在
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.item >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.item < numberOfItems(inSection: indexPath.section)
    }

    /// 安全地滚动到指定的`IndexPath`
    /// - Parameters:
    ///   - indexPath:要滚动到的目标`indexPath`
    ///   - scrollPosition:滚动位置
    ///   - animated:是否设置动画
    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item >= 0,
              indexPath.section >= 0,
              indexPath.section < numberOfSections,
              indexPath.item < numberOfItems(inSection: indexPath.section)
        else {
            return
        }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }

    /// 是否滚动到顶部
    /// - Parameter animated:是否要动画
    func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }

    /// 是否滚动到底部
    /// - Parameter animated:是否要动画
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }

    /// 滚动到什么位置(`CGPoint`)
    /// - Parameter animated:是否要动画
    func scrollToOffset(offsetX: CGFloat = 0, offsetY: CGFloat = 0, animated: Bool) {
        setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: animated)
    }

    /// 刷新`UICollectionView`的数据,刷新后调用回调
    /// - Parameter completion:完成回调
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    /// 使用类名注册`UICollectionViewCell`
    /// - Parameter name:`UICollectionViewCell`类型
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册`UICollectionView`
    /// - Parameters:
    ///   - nib:用于创建`collectionView`单元格的`nib`文件
    ///   - name:`UICollectionViewCell`类型
    func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }

    /// 向注册`UICollectionViewCell`.仅使用其对应类的`xib`文件
    /// 假设xib文件名称和`cell`类具有相同的名称
    /// - Parameters:
    ///   - name:`UICollectionViewCell`类型
    ///   - bundleClass:`Bundle`实例将基于的类
    func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    /// 使用类名和索引获取可重用`UICollectionViewCell`
    /// - Parameters:
    ///   - name:`UICollectionViewCell`类型
    ///   - indexPath:`UICollectionView`中单元格的位置
    /// - Returns:类名关联的`UICollectionViewCell`对象
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }

    /// 使用类名注册`UICollectionReusableView`
    /// - Parameters:
    ///   - kind:要检索的补充视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册`UICollectionReusableView`
    /// - Parameters:
    ///   - nib:用于创建可重用视图的`nib`文件
    ///   - kind:要检索的视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    func register<T: UICollectionReusableView>(
        nib: UINib?,
        forSupplementaryViewOfKind kind: String,
        withClass name: T.Type
    ) {
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// 使用类名和类型获取可重用`UICollectionReusableView`
    /// - Parameters:
    ///   - kind:要检索的视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    ///   - indexPath:单元格在`UICollectionView`中的位置
    /// - Returns:类名关联的`UICollectionReusableView`对象
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withClass name: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: name),
            for: indexPath
        ) as? T else {
            fatalError(
                "Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return cell
    }
}

// MARK: - 链式语法
public extension UICollectionView {
    /// 创建默认`UICollectionView`
    static var defaultCollectionView: UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }

    /// 设置 `delegate` 代理
    /// - Parameter delegate:`delegate`
    /// - Returns:`Self`
    @discardableResult
    func delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 dataSource 代理
    /// - Parameter dataSource:`dataSource`
    /// - Returns:`Self`
    @discardableResult
    func dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 设置`Layout`
    /// - Parameters:
    ///   - layout:布局
    ///   - animated:是否动画
    ///   - completion:完成回调
    /// - Returns:`Self`
    @discardableResult
    func layout(
        _ layout: UICollectionViewLayout,
        animated: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) -> Self {
        setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    /// 注册`UICollectionViewCell`
    /// - Returns:`Self`
    @discardableResult
    func register<T: UICollectionViewCell>(_ cell: T.Type) -> Self {
        register(cellWithClass: T.self)
        return self
    }

    /// 滚动到指定`IndexPath`
    /// - Parameters:
    ///   - indexPath:第几个IndexPath
    ///   - scrollPosition:滚动的方式
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func scroll(to indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition = .top, animated: Bool = true) -> Self {
        if indexPath.section < 0 || indexPath.item < 0 || indexPath.section > numberOfSections || indexPath.row > numberOfItems(inSection: indexPath.section) {
            return self
        }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到指定`row`和`section`
    /// - Parameters:
    ///   - row:第几个Cell
    ///   - section:第几组
    ///   - scrollPosition:滚动的方式
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func scroll(row: Int, section: Int = 0, at scrollPosition: UICollectionView.ScrollPosition = .top, animated: Bool = true) -> Self {
        return scroll(to: IndexPath(row: row, section: section), at: scrollPosition, animated: animated)
    }
}
