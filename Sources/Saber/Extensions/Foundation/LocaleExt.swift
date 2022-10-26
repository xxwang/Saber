import Foundation

// MARK: - 属性

public extension Locale {
    /// 是否是12小时制
    var is12HourSystem: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self
        let dateString = dateFormatter.string(from: Date())
        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }
}

// MARK: - 静态方法

public extension Locale {
    /// 获取给定国家/地区代码的国旗表情符号
    /// - Parameter isoRegionCode: `ISO`区域代码
    /// - Returns: 给定地区代码的标志符号字符串(可选)
    static func flagEmoji(forRegionCode isoRegionCode: String) -> String? {
        return isoRegionCode.unicodeScalars.reduce(into: String()) {
            guard let flagScalar = UnicodeScalar(UInt32(127_397) + $1.value) else { return }
            $0.unicodeScalars.append(flagScalar)
        }
    }
}
