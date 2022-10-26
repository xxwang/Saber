import Foundation

// MARK: - 方法
public extension NSNumber {
    /*
     NumberFormatter.Style.decimal格式的意思是:
     整数部分从右往左每三位添加一个逗号,数据最多保留三位小数,和上述@"#,###.##
     和效果相似,没有小数的话会直接显示成整数,但是默认小数最多三位
     */
    /// 格式化数字
    /// - Parameters:
    ///   - mode: 舍入模式
    ///   - minDigits: 小数点后最少保留位数
    ///   - maxDigits: 小数点后最大保留位数
    ///   - numberStyle: 样式
    /// - Returns: 字符串
    func numberFormatter(with mode: NumberFormatter.RoundingMode = .halfEven, minDigits: Int = 0, maxDigits: Int = 0, numberStyle: NumberFormatter.Style = .none) -> String? {
        let formater = NumberFormatter()
        // 样式
        formater.numberStyle = numberStyle
        // 分隔符
        formater.groupingSeparator = ","
        // 最小位数
        formater.minimumFractionDigits = minDigits
        // 最大位数
        formater.maximumFractionDigits = maxDigits
        // 舍入模式
        formater.roundingMode = mode

        return formater.string(from: self)
    }
}
