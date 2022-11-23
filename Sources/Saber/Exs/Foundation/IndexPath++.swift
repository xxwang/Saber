import Foundation

extension IndexPath: Saberable {}

// MARK: - 属性
public extension SaberEx where Base == IndexPath {
    /// 字符串描述{`section`, `row`}
    /// - Returns: `String`
    func toString() -> String {
        return String(format: "{%d, %d}", base.section, base.row)
    }

    /// 前一行索引
    /// - Returns: `IndexPath`
    func previousRow() -> IndexPath {
        if base.row == 0 {
            return base
        }
        return IndexPath(row: base.row - 1, section: base.section)
    }

    /// 下一行索引
    /// - Returns: `IndexPath`
    func nextRow() -> IndexPath {
        return IndexPath(row: base.row + 1, section: base.section)
    }

    /// 前一组索引
    /// - Returns: `IndexPath`
    func previousSection() -> IndexPath {
        if base.section == 0 {
            return base
        }
        return IndexPath(row: base.row, section: base.section - 1)
    }

    /// 下一组索引
    /// - Returns: `IndexPath`
    func nextSection() -> IndexPath {
        return IndexPath(row: base.row, section: base.section + 1)
    }
}
