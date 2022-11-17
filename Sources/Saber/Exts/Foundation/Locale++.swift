import Foundation

extension Locale: Saberable {}

// MARK: - 方法
public extension SaberExt where Base == Locale {
    /// 是否是12小时制
    /// - Returns: `Bool`
    func is12hour() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = base

        let dateString = dateFormatter.string(from: Date())

        // 判断是否包含"am/pm"
        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }
}
