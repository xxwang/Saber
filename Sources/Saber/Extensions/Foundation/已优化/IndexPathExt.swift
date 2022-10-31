import Foundation

// MARK: - 属性
public extension IndexPath {
    /// 字符串描述{`section`, `row`}
    var string: String {
        return String(format: "{%d, %d}", section, row)
    }

    /// 前一行索引
    var previousRow: IndexPath {
        if row == 0 {
            return self
        }
        return IndexPath(row: row - 1, section: section)
    }

    /// 下一行索引
    var nextRow: IndexPath {
        return IndexPath(row: row + 1, section: section)
    }

    /// 前一组索引
    var previousSection: IndexPath {
        if section == 0 {
            return self
        }
        return IndexPath(row: row, section: section - 1)
    }

    /// 下一组索引
    var nextSection: IndexPath {
        return IndexPath(row: row, section: section + 1)
    }
}
