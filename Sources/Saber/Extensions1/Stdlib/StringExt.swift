import CoreLocation
import Foundation
#if canImport(UIKit)
    import UIKit
#endif

#if canImport(AppKit)
    import AppKit
#endif

// MARK: - 方法(mutating)
public extension String {}

// MARK: - 方法
public extension String {
    /// 由换行符分隔的字符串数组(获取字符串行数, `\n`分割)
    ///
    ///     "Hello\ntest".lines() -> ["Hello", "test"]
    ///
    /// - Returns:分割后的字符串数组
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }

    /// 字符串中的字数(`word`)
    ///
    ///     "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns:字符串中包含的单词数
    func wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }

    /// 字符串中的数字个数
    func numericCount() -> Int {
        var count = 0
        for c in self where ("0" ... "9").contains(c) {
            count += 1
        }
        return count
    }

    /// 计算字符个数(`英文 = 1`,`数字 = 1`,`汉语 = 2`)
    var countOfChars: Int {
        var count = 0
        guard !isEmpty else {
            return 0
        }
        for i in 0 ... self.count - 1 {
            let c: unichar = (self as NSString).character(at: i)
            if c >= 0x4E00 {
                count += 2
            } else {
                count += 1
            }
        }
        return count
    }

    /// 字符串中所有字符的`unicode`数组
    ///
    ///     "SwifterSwift".unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns:字符串中所有字符的 unicode
    func unicodeArray() -> [Int] {
        return unicodeScalars.map { Int($0.value) }
    }

    /// 字符串中所有单词的数组
    ///
    ///     "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns:字符串中包含的单词
    func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }

    /// 字符串中的子字符串个数
    ///
    ///     "Hello World!".count(of:"o") -> 2
    ///     "Hello World!".count(of:"L", caseSensitive:false) -> 3
    /// - Parameters:
    ///   - string:要搜索的子字符串
    ///   - caseSensitive:是否区分大小写(默认为`true`)
    /// - Returns:子字符串在字符串中出现的计数
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }

    /// 在指定`searchRange`中使用`template`替换与`regex`匹配的内容
    /// - Parameters:
    ///   - regex:进行替换的正则表达式
    ///   - template:替换正则表达式的模板
    ///   - options:要使用的匹配选项
    ///   - searchRange:要搜索的范围
    /// - Returns:一个新字符串,其中接收者的 `searchRange` 中所有出现的正则表达式都被模板替换
    func replacingOccurrences(
        of regex: NSRegularExpression,
        with template: String,
        options: NSRegularExpression.MatchingOptions = [],
        range searchRange: Range<String.Index>? = nil
    ) -> String {
        let range = NSRange(searchRange ?? startIndex ..< endIndex, in: self)
        return regex.stringByReplacingMatches(in: self, options: options, range: range, withTemplate: template)
    }

    /// 使用正则表达式替换
    /// - Parameters:
    ///   - pattern:正则
    ///   - with:用来替换的字符串
    ///   - options:选项
    /// - Returns:返回替换后的字符串
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String
    {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSRange(location: 0, length: count),
                                              withTemplate: with)
    }

    /// 从字符串中删除指定的前缀
    ///
    ///     "Hello, World!".removingPrefix("Hello, ") -> "World!"
    /// - Parameters prefix:要从字符串中删除的前缀
    /// - Returns:去除前缀后的字符串
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// 从字符串中删除给定的后缀
    ///
    ///     "Hello, World!".removingSuffix(", World!") -> "Hello"
    /// - Parameters suffix:要从字符串中删除的后缀
    /// - Returns:删除后缀后的字符串
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// 为字符串添加前缀
    ///
    ///     "www.apple.com".withPrefix("https://") -> "https://www.apple.com"
    /// - Parameters prefix:添加到字符串的前缀
    /// - Returns:带有前缀的字符串
    func withPrefix(_ prefix: String) -> String {
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }

    /// `子字符串``第一次`出现的位置
    /// - Parameter sub:子字符串
    /// - Returns:返回字符串的位置(如果不存在该字符串则返回 `-1`)
    func positionFirst(of sub: String) -> Int {
        return position(of: sub)
    }

    /// `子字符串``最后一次`出现的位置
    /// - Parameter sub:子字符串
    /// - Returns:返回字符串的位置(如果不存在该字符串则返回 `-1`)
    func positionLast(of sub: String) -> Int {
        return position(of: sub, backwards: true)
    }

    /// 返回字符串`第一次/最后一次`出现的`位置索引`,不存在返回`-1`
    /// - Parameters:
    ///   - sub:子字符串
    ///   - backwards:如果`backwards`参数设置为`true`,则返回最后一次出现的位置
    /// - Returns:位置
    func position(of sub: String, backwards: Bool = false) -> Int {
        var pos = -1
        if let range = range(of: sub, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                pos = distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }

    /// 在任意位置插入字符串
    /// - Parameters:
    ///   - content:插入内容
    ///   - locat:插入的位置
    /// - Returns:添加后的字符串
    func insertString(content: String, locat: Int) -> String {
        guard locat < count else {
            return self
        }
        let str1 = sb.subString(to: locat)
        let str2 = sb.subString(from: locat + 1)
        return str1 + content + str2
    }

    /// 替换字符串
    /// - Parameters:
    ///   - string:要替换的字符串
    ///   - withString:要替换成的字符串
    /// - Returns:替换完成的字符串
    func replace(_ string: String, with withString: String) -> String {
        return replacingOccurrences(of: string, with: withString)
    }

    /// 隐藏敏感信息
    ///
    ///     "012345678912".HideSensitiveContent(range:3..<8, replace:"*****") -> "012*****912"
    /// - Parameters:
    ///   - range:要隐藏的内容范围
    ///   - replace:用来替换敏感内容的字符串
    /// - Returns:隐藏敏感信息后的字符串
    func hideSensitiveContent(range: Range<Int>, replace: String = "****") -> String {
        if count < range.upperBound {
            return self
        }
        guard let subStr = self[safe: range] else {
            return self
        }
        return self.replace(subStr, with: replace)
    }

    /// 生成指定数量的重复字符串
    /// - Parameter count:要重复的字符串个数
    /// - Returns:拼接后的字符串
    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }

    /// 移除`self`中指定字符串,并用指定字符串来进行替换
    /// - Parameters:
    ///   - removeString:要移除的字符串
    ///   - replacingString:替换的字符串
    /// - Returns:替换后的整体字符串
    func removeSomeStringUseSomeString(removeString: String, replacingString: String = "") -> String {
        return replacingOccurrences(of: removeString, with: replacingString)
    }

    /// 删除指定的字符
    /// - Parameter characterString:指定的字符
    /// - Returns:返回删除后的字符
    func removeCharacter(characterString: String) -> String {
        let characterSet = CharacterSet(charactersIn: characterString)
        return trimmingCharacters(in: characterSet)
    }

    /// 获取最长相同后缀
    /// - Parameters:
    ///   - aString:用于与`self`比较的对象
    ///   - options:选项
    /// - Returns:最长相同后缀
    func commonSuffix(with aString: String, options: String.CompareOptions = []) -> String {
        return String(zip(reversed(), aString.reversed())
            .lazy
            .prefix(while: { (lhs: Character, rhs: Character) in
                String(lhs).compare(String(rhs), options: options) == .orderedSame
            })
            .map { (lhs: Character, _: Character) in lhs }
            .reversed())
    }
}

// MARK: - HTML字符引用
public extension String {
    /// `字符串`转为`HTML字符引用`
    /// - Returns:字符引用
    func stringAsHtmlCharacterEntityReferences() -> String {
        var result = ""
        for scalar in utf16 {
            // 将十进制转成十六进制,不足4位前面补0
            let tem = String().appendingFormat("%04x", scalar)
            result += "&#x\(tem);"
        }
        return result
    }

    /// `HTML字符引用`转`字符串`
    /// - Returns:普通字符串
    func htmlCharacterEntityReferencesAsString() -> String? {
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                                                     NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        guard let encodedData = data(using: String.Encoding.utf8), let attributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil) else {
            return nil
        }
        return attributedString.string
    }
}

// MARK: - 属性字符串相关
public extension String {
    /// `HTML源码`转`属性字符串`
    /// - Parameters:
    ///   - font:字体
    ///   - lineSpacing:行间距
    /// - Returns:属性字符串
    func htmlCodeToAttributedString(
        font: UIFont? = UIFont.systemFont(ofSize: 12),
        lineSpacing: CGFloat? = 10
    ) -> NSMutableAttributedString {
        var htmlString: NSMutableAttributedString?
        do {
            if let data = replacingOccurrences(of: "\n", with: "<br/>").data(using: .utf8) {
                htmlString = try NSMutableAttributedString(data: data, options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue),
                ], documentAttributes: nil)
                let wrapHtmlString = NSMutableAttributedString(string: "\n")
                // 判断尾部是否是换行符
                if let weakHtmlString = htmlString, weakHtmlString.string.hasSuffix("\n") {
                    htmlString?.deleteCharacters(in: NSRange(location: weakHtmlString.length - wrapHtmlString.length, length: wrapHtmlString.length))
                }
            }
        } catch {}
        // 设置属性字符串字体的大小
        if let font = font {
            htmlString?.addAttributes([
                NSAttributedString.Key.font: font,
            ], range: NSRange(location: 0, length: htmlString?.length ?? 0))
        }

        // 设置行间距
        if let weakLineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = weakLineSpacing
            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: htmlString?.length ?? 0))
        }
        return htmlString ?? NSMutableAttributedString(string: self)
    }

    /// 高亮显示关键字(返回属性字符串)
    /// - Parameters:
    ///   - keyword:要高亮的关键词
    ///   - keywordCololor:关键高亮字颜色
    ///   - otherColor:非高亮文字颜色
    ///   - options:匹配选项
    /// - Returns:返回匹配后的属性字符串
    func highlightSubString(
        keyword: String,
        keywordCololor: UIColor,
        otherColor: UIColor,
        options: NSRegularExpression.Options = []
    ) -> NSMutableAttributedString {
        // 整体字符串
        let fullString = self
        // 整体属性字符串
        let attributedString = NSMutableAttributedString(string: fullString)
        // 整体颜色
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: otherColor], range: fullString.sb.fullNSRange())

        // 与关键词匹配的range数组
        let ranges = fullString.sb.matchRange(keyword)

        // 设置高亮颜色
        for range in ranges {
            attributedString.addAttributes([.foregroundColor: keywordCololor], range: range)
        }
        return attributedString
    }
}

// MARK: - 字符串尺寸计算
public extension String {
    /// 计算字符串大小
    /// - Parameters:
    ///   - maxWidth:最大宽度
    ///   - font:文字字体
    /// - Returns:结果`CGSize`
    func strSize(
        _ maxWidth: CGFloat = UIScreen.main.bounds.width,
        font: UIFont
    ) -> CGSize {
        let constraint = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = (self as NSString).boundingRect(with: constraint,
                                                   options: [
                                                       .usesLineFragmentOrigin,
                                                       .usesFontLeading,
                                                       .truncatesLastVisibleLine,
                                                   ],
                                                   attributes: [
                                                       .font: font,
                                                   ],
                                                   context: nil)

        return CGSize(width: Foundation.ceil(rect.width), height: Foundation.ceil(rect.height))
    }

    /// 以属性字符串的方式计算字符串大小
    /// - Parameters:
    ///   - maxWidth:最大宽度
    ///   - font:字体
    ///   - lineSpaceing:行间距
    ///   - wordSpacing:字间距
    /// - Returns:结果`CGSize`
    func attributeSize(
        _ maxWidth: CGFloat = UIScreen.main.bounds.width,
        font: UIFont,
        lineSpacing: CGFloat = 0,
        wordSpacing: CGFloat = 0
    ) -> CGSize {
        // 段落样式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = lineSpacing

        // 设置行间距
        paragraphStyle.hyphenationFactor = 1.0
        paragraphStyle.firstLineHeadIndent = 0.0
        paragraphStyle.paragraphSpacingBefore = 0.0
        paragraphStyle.headIndent = 0
        paragraphStyle.tailIndent = 0

        // 属性字符串
        let attString = NSMutableAttributedString(string: self)
        attString.addAttributes([
            .font: font,
            .kern: wordSpacing,
            .paragraphStyle: paragraphStyle,
        ], range: NSRange(location: 0, length: count))

        let constraint = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let textSize = attString.boundingRect(with: constraint,
                                              options: [
                                                  .usesLineFragmentOrigin,
                                                  .usesFontLeading,
                                                  .truncatesLastVisibleLine,
                                              ],
                                              context: nil).size

        // 向上取整(由于计算结果小数问题, 导致界面字符串显示不完整)
        return CGSize(width: Foundation.ceil(textSize.width), height: Foundation.ceil(textSize.height))
    }
}

// MARK: - 其它
public extension String {
    /// 将字符串复制到全局粘贴板
    ///
    ///     "SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func copyToPasteboard() {
        #if os(iOS)
            UIPasteboard.general.string = self
        #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(self, forType: .string)
        #endif
    }
}

// MARK: - `NSDecimalNumber`苹果针对浮点类型计算精度问题提供出来的计算类
public extension String {
    /// `＋` 加法运算
    /// - Parameter strNumber:加数字符串
    /// - Returns:结果数字串
    func adding(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN {
            ln = NSDecimalNumber.zero
        }
        if rn.doubleValue.isNaN {
            rn = NSDecimalNumber.zero
        }
        let final = ln.adding(rn)
        return final.stringValue
    }

    /// `－` 减法运算
    /// - Parameter strNumber:减数字符串
    /// - Returns:结果
    func subtracting(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN {
            ln = NSDecimalNumber.zero
        }
        if rn.doubleValue.isNaN {
            rn = NSDecimalNumber.zero
        }
        let final = ln.subtracting(rn)
        return final.stringValue
    }

    /// `*` 乘法运算
    /// - Parameter strNumber:乘数字符串
    /// - Returns:结果
    func multiplying(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN {
            ln = NSDecimalNumber.zero
        }
        if rn.doubleValue.isNaN {
            rn = NSDecimalNumber.zero
        }
        let final = ln.multiplying(by: rn)
        return final.stringValue
    }

    /// `/`除法运算
    /// - Parameter strNumber:除数
    /// - Returns:结果
    func dividing(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN {
            ln = NSDecimalNumber.zero
        }
        if rn.doubleValue.isNaN {
            rn = NSDecimalNumber.one
        }
        if rn.doubleValue == 0 {
            rn = NSDecimalNumber.one
        }
        let final = ln.dividing(by: rn)
        return final.stringValue
    }
}

// MARK: - 数字字符串
public extension String {
    /// 金额字符串转化为带逗号的金额, 按照千分位表示
    /// "1234567" => 1,234,567
    /// "1234567.56" => 1,234,567.56
    /// - Returns:千分位表示字符串
    func amountAsThousands() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        if contains(".") {
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.minimumIntegerDigits = 1
        }
        var num = NSDecimalNumber(string: self)
        if num.doubleValue.isNaN {
            num = NSDecimalNumber(string: "0")
        }
        let result = formatter.string(from: num)
        return result
    }

    /// 删除小数点后面多余的0
    /// - Returns:删除小数点后多余0的数字字符串
    func deleteMoreThanZeroFromAfterDecimalPoint() -> String {
        var rst = self
        var i = 1
        if contains(".") {
            while i < count {
                if rst.hasSuffix("0") {
                    rst.removeLast()
                    i = i + 1
                } else {
                    break
                }
            }
            if rst.hasSuffix(".") {
                rst.removeLast()
            }
            return rst
        } else {
            return self
        }
    }

    /// 保留小数点后面指定位数
    /// - Parameters:
    ///   - numberDecimal:保留几位小数
    ///   - mode:模式
    /// - Returns:返回保留后的小数(非数字字符串,返回0或0.0)
    func keepDecimalPlaces(decimalPlaces: Int = 0, mode: NumberFormatter.RoundingMode = .floor) -> String {
        // 转为小数对象
        var decimalNumber = NSDecimalNumber(string: self)

        // 如果不是数字,设置为0值
        if decimalNumber.doubleValue.isNaN {
            decimalNumber = NSDecimalNumber.zero
        }
        // 数字格式化对象
        let formatter = NumberFormatter()
        // 模式
        formatter.roundingMode = mode
        // 小数位最多位数
        formatter.maximumFractionDigits = decimalPlaces
        // 小数位最少位数
        formatter.minimumFractionDigits = decimalPlaces
        // 整数位最少位数
        formatter.minimumIntegerDigits = 1
        // 整数位最多位数
        formatter.maximumIntegerDigits = 100

        // 获取结果
        guard let result = formatter.string(from: decimalNumber) else {
            // 异常处理
            if decimalPlaces == 0 {
                return "0"
            } else {
                var zero = ""
                for _ in 0 ..< decimalPlaces {
                    zero += zero
                }
                return "0." + zero
            }
        }
        return result
    }
}
