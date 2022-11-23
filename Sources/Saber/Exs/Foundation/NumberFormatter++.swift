import Foundation

// MARK: - 静态方法
public extension SaberEx where Base: NumberFormatter {
    /// `Float`格式化为本地字符串
    /// - Parameters:
    ///   - value:`Float`数值
    ///   - style:格式
    /// - Returns:`String`
    static func numberFormatting(
        value: Float,
        style: NumberFormatter.Style = .none
    ) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    /// `Double`格式化为本地字符串
    /// - Parameters:
    ///   - value:`Double`数值
    ///   - style:格式
    /// - Returns:`String`
    static func numberFormatting(
        value: Double,
        style: NumberFormatter.Style = .none
    ) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    /// `String`数值格式化为本地字符串
    /// - Parameters:
    ///   - value:`String`数值
    ///   - style:格式
    /// - Returns:`String?`
    static func stringFormattingNumber(
        value: String,
        style: NumberFormatter.Style = .none
    ) -> String? {
        guard let number = NumberFormatter().number(from: value) else {
            return nil
        }
        return NumberFormatter.localizedString(from: number, number: style)
    }

    /// 自定义`NumberFormatter`参数格式化`String`数值
    /// - Parameters:
    ///   - value:`String`数值
    ///   - numberFormatter:格式化对象
    /// - Returns:`String?`
    static func customFormatter(
        value: String,
        numberFormatter: NumberFormatter
    ) -> String? {
        guard let number = NumberFormatter().number(from: value) else {
            return nil
        }
        guard let formatValue = numberFormatter.string(from: number) else {
            return nil
        }
        return formatValue
    }

    /// 为`String`数值设置`分割符`及`分割位数`
    /// - Parameters:
    ///   - value:`String`数值
    ///   - separator:分割符
    ///   - size:分割位数
    ///   - style:格式
    /// - Returns:`String?`
    static func setGroupingSeparatorAndSize(
        value: String,
        separator: String,
        size: Int,
        style: NumberFormatter.Style = .none
    ) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = separator
        numberFormatter.groupingSize = size

        return customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为`String`数值设置`格式宽度`及`填充符`和`填充位置`
    /// - Parameters:
    ///   - value:`String`数值
    ///   - formatWidth:格式宽度
    ///   - paddingCharacter:填充符号
    ///   - paddingPosition:填充的位置
    ///   - style:格式
    /// - Returns:`String?`
    static func setFormatWidthPaddingCharacterAndPosition(
        value: String,
        formatWidth: Int,
        paddingCharacter: String,
        paddingPosition: NumberFormatter.PadPosition = .beforePrefix,
        style: NumberFormatter.Style = .none
    ) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.formatWidth = formatWidth
        numberFormatter.paddingCharacter = paddingCharacter
        numberFormatter.paddingPosition = paddingPosition
        return customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为`String`数值设置`最大整数位数`和`最小整数位数`
    /// - Parameters:
    ///   - value:`String`数值
    ///   - maximumIntegerDigits:最大整数位数
    ///   - minimumIntegerDigits:最小整数位数
    ///   - style:格式
    /// - Returns:`String?`
    static func setMaximumIntegerDigitsAndMinimumIntegerDigits(
        value: String,
        maximumIntegerDigits: Int,
        minimumIntegerDigits: Int,
        style: NumberFormatter.Style = .none
    ) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.maximumIntegerDigits = maximumIntegerDigits
        numberFormatter.minimumIntegerDigits = minimumIntegerDigits
        return customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为`String`数值设置`最大小数位数`和`最小小数位数`
    /// - Parameters:
    ///   - value:`String`数值
    ///   - maximumFractionDigits:最大小数位数
    ///   - minimumFractionDigits:最小小数位数
    /// - Returns:`String?`
    static func setmMximumFractionDigitsAndMinimumFractionDigits(
        value: String,
        maximumFractionDigits: Int,
        minimumFractionDigits: Int
    ) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        return customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为`String`数值设置`前缀`和`后缀`
    /// - Parameters:
    ///   - value:`String`数值
    ///   - positivePrefix:自定义前缀
    ///   - positiveSuffix:自定义后缀
    ///   - style:格式
    /// - Returns:`String?`
    static func setMaximumIntegerDigitsAndMinimumIntegerDigits(
        value: String,
        positivePrefix: String,
        positiveSuffix: String,
        style: NumberFormatter.Style = .none
    ) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positivePrefix = positivePrefix
        numberFormatter.positiveSuffix = positiveSuffix
        return customFormatter(value: value, numberFormatter: numberFormatter)
    }

    /// 为`String`数值设置`自定义格式化样式`
    /// - Parameters:
    ///   - value:`String`数值
    ///   - positiveFormat:自定义格式化样式`###,###.##`
    ///   - style:格式
    /// - Returns:`String?`
    static func setPositiveFormat(
        value: String,
        positiveFormat: String,
        style: NumberFormatter.Style = .none
    ) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positiveFormat = positiveFormat
        return customFormatter(value: value, numberFormatter: numberFormatter)
    }
}
