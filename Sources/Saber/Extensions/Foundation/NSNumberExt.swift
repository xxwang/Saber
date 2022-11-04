import Foundation

// MARK: - 方法
public extension NSNumber {
    /// 格式化数字
    /// - Parameters:
    ///   - mode:舍入模式
    ///   - minDigits:小数点后最少保留位数
    ///   - maxDigits:小数点后最大保留位数
    ///   - separator:分割符
    ///   - numberStyle:样式
    /// - Returns:字符串
    func numberFormatter(
        with mode: NumberFormatter.RoundingMode = .halfEven,
        minDigits: Int = 0,
        maxDigits: Int = 0,
        separator: String = ",",
        numberStyle: NumberFormatter.Style = .none
    ) -> String? {
        let formater = NumberFormatter()
        // 样式
        formater.numberStyle = numberStyle
        // 分隔符
        formater.groupingSeparator = separator
        // 最小位数
        formater.minimumFractionDigits = minDigits
        // 最大位数
        formater.maximumFractionDigits = maxDigits
        // 舍入模式
        formater.roundingMode = mode

        return formater.string(from: self)
    }
}
