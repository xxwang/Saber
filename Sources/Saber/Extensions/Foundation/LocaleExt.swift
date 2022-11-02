import Foundation

// MARK: - 属性
public extension Locale {
    /// 是否是12小时制
    var is12hour: Bool {
        // 日期格式化对象
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self

        // 当前日期字符串
        let dateString = dateFormatter.string(from: Date())

        // 判断是否包含"am/pm"
        let is12hour = dateString.contains(dateFormatter.amSymbol)
            || dateString.contains(dateFormatter.pmSymbol)

        return is12hour
    }
}
