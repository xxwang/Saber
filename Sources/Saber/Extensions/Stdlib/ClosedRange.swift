import Foundation

extension ClosedRange<Int>: Saberable {}

// MARK: - ClosedRange<Int>
public extension SaberExt where Base == ClosedRange<Int> {
    /// 转换为索引数组
    /// - Returns:索引数组
    func indexs() -> [Int] {
        var indexs: [Int] = []
        base.forEach { index in
            indexs.append(index)
        }
        return indexs
    }
}
