
// MARK: - ClosedRange<Int>
public extension ClosedRange<Int> {
    /// 转换为索引数组
    /// - Returns:索引数组
    func indexs() -> [Int] {
        var indexs: [Int] = []
        forEach { index in
            indexs.append(index)
        }
        return indexs
    }
}
