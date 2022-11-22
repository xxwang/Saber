import CoreLocation
import UIKit

// extension String: Saberable {}

// MARK: - 构造方法
public extension String {
    /// 从`base64`字符串创建一个新字符串(`base64`解码)
    ///
    ///     String(base64:"SGVsbG8gV29ybGQh") = "Hello World!"
    ///     String(base64:"hello") = nil
    /// - Parameters base64:`base64`字符串
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }

    /// 创建一个给定长度的新随机字符串
    ///
    ///     String(randomOfLength:10) -> "gY8r3MHvlQ"
    /// - Parameters length:字符串中的字符数
    init(randomOfLength length: Int) {
        guard length > 0 else {
            self.init()
            return
        }
        self = Self.random(ofLength: length)
    }
}

// MARK: - 下标
public extension String {
    /// 使用索引下标安全地获取字符串中对应的字符
    ///
    ///     "Hello World!"[safe:3] -> "l"
    ///     "Hello World!"[safe:20] -> nil
    /// - Parameters index:索引下标
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

    /// 获取某个字符,如果不在范围内,返回`nil`
    subscript(index: Int) -> String? {
        get {
            if index > count - 1 || index < 0 {
                return nil
            }
            return String(self[self.index(startIndex, offsetBy: index)])
        }
        set {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(after: startIndex)
            replaceSubrange(startIndex ..< endIndex, with: "\(newValue ?? "")")
        }
    }

    /// 在给定范围内安全地获取子字符串
    ///
    ///     "Hello World!"[safe:6..<11] -> "World"
    ///     "Hello World!"[safe:21..<110] -> nil
    ///
    ///     "Hello World!"[safe:6...11] -> "World!"
    ///     "Hello World!"[safe:21...110] -> nil
    /// - Parameters range:范围表达式
    subscript<R>(safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min ..< Int.max)
        guard range.lowerBound >= 0,
              let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
              let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex)
        else {
            return nil
        }

        return String(self[lowerIndex ..< upperIndex])
    }

    /// 字符串下标方法 获取指定range字符串/替换指定范围字符串
    subscript(range: Range<Int>) -> String {
        get {
            let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: range.upperBound)
            return String(self[startIndex ..< endIndex])
        } set {
            let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: range.upperBound)
            replaceSubrange(startIndex ..< endIndex, with: newValue)
        }
    }

    /// 获取字符串指定`NSRange`的子字符串
    /// - Parameter bounds:子字符串的范围,范围的边界必须是集合的有效索引
    /// - Returns:字符串的一部分
    subscript(bounds: NSRange) -> Substring {
        guard let range = Range(bounds, in: self) else { fatalError("Failed to find range \(bounds) in \(self)") }
        return self[range]
    }
}

// MARK: - 属性
public extension SaberExt where Base == String {
    /// 字符串的长度
    var length: Int {
        return base.count
    }
}

// MARK: - 类型转换
public extension SaberExt where Base == String {
    /// 字符串转`Int`
    /// - Returns: `Int`
    func toInt() -> Int {
        return Int(base) ?? 0
    }

    /// 字符串转`UInt`
    /// - Returns: `UInt`
    func toUInt() -> UInt {
        return UInt(base) ?? 0
    }

    /// 字符串转`Int64`
    /// - Returns: `Int64`
    func toInt64() -> Int64 {
        return Int64(base) ?? 0
    }

    /// 字符串转`UInt64`
    /// - Returns: `UInt64`
    func toUInt64() -> UInt64 {
        return UInt64(base) ?? 0
    }

    /// 字符串转`Float`
    /// - Returns: `Float`
    func toFloat() -> Float {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        return formatter.number(from: base)?.floatValue ?? 0
    }

    /// 字符串转`Double`
    /// - Returns: `Double`
    func toDouble() -> Double {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        return formatter.number(from: base)?.doubleValue ?? 0
    }

    /// 字符串转`CGFloat`
    /// - Returns: `CGFloat`
    func toCGFloat() -> CGFloat {
        return CGFloat(toDouble())
    }

    /// 字符串转`NSNumber`
    /// - Returns: `NSNumber`
    func toNSNumber() -> NSNumber {
        return NSNumber(value: toDouble())
    }

    /// 字符串转`Character`
    /// - Returns: `Character?`
    func toCharacter() -> Character? {
        guard let n = Int(base),
              let scalar = UnicodeScalar(n)
        else { return nil }
        return Character(scalar)
    }

    /// 字符串的字符数组表示
    /// - Returns: `[Character]`
    func toCharacters() -> [Character] {
        return Array(base)
    }

    /// 字符串转布尔值(其它为`false`)
    ///
    ///     "1".bool -> true
    ///     "False".bool -> false
    ///     "Hello".bool = nil
    ///
    /// - Returns: `Bool`
    func toBool() -> Bool {
        let trimmed = self.trimmed().sb.toUpper()
        switch trimmed {
        case "1",
             "t",
             "true",
             "y",
             "yes":
            return true
        case "0",
             "f",
             "false",
             "n",
             "no":
            return false
        default:
            return false
        }
    }

    /// 转`NSString`字符串
    /// - Returns: `NSString`
    func toNSString() -> NSString {
        return NSString(string: base)
    }

    /// 字符串转属性字符串
    /// - Returns: `NSMutableAttributedString`
    func toAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: base)
    }

    /// 转`utf8`格式`Data`
    /// - Returns: `Data?`
    func toData() -> Data? {
        return base.data(using: .utf8)
    }

    /// 图片资源名称转图片对象
    /// - Returns: `UIImage?`
    func toImage() -> UIImage? {
        return UIImage(named: base)
    }

    /// 把字符串转为`URL`(失败返回`nil`)
    /// - Returns: `URL?`
    func toUrl() -> URL? {
        if base.hasPrefix("http://") || base.hasPrefix("https://") {
            return URL(string: base)
        }
        return URL(fileURLWithPath: base)
    }

    /// 字符串转`URLRequest`
    /// - Returns: `URLRequest?`
    func toURLRequest() -> URLRequest? {
        guard let url = toUrl() else {
            return nil
        }
        return URLRequest(url: url)
    }

    /// `16进制颜色值`字符串转`UIColor`对象
    /// - Returns: `UIColor`
    func toHexColor() -> UIColor {
        return UIColor(hex: base)
    }

    /// 将`16进制字符串`转为`Int`
    /// - Returns: `Int`
    func toHexInt() -> Int {
        return Int(base, radix: 16) ?? 0
    }

    /// 转换成小写字符串
    /// - Returns: 小写`String`
    func toLower() -> String {
        return base.lowercased()
    }

    /// 转换成大写字符串
    /// - Returns: 大写`String`
    func toUpper() -> String {
        return base.uppercased()
    }

    /// 字符串转换成驼峰命名法(并移除空字符串)
    ///
    ///     "sOme vAriable naMe".camelCased -> "someVariableName"
    /// - Returns: `String`
    func toCamelCase() -> String {
        let source = toLower()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
}

// MARK: - 进制转换
public extension SaberExt where Base == String {
    /// `二进制`转`八进制`
    /// - Returns: `String`
    func b2oString() -> String {
        return b2dString().sb.d2oString()
    }

    /// `二进制`转`十进制`
    /// - Returns: `String`
    func b2dString() -> String {
        var sum = 0
        for c in base {
            let number = c.sb.toString().sb.toInt()
            sum = sum * 2 + number
        }
        return "\(sum)"
    }

    /// `二进制`转`十六进制`
    /// - Returns: `String`
    func b2hString() -> String {
        return b2dString().sb.d2hString()
    }

    /// `八进制`转`二进制`
    /// - Returns: `String`
    func o2bString() -> String {
        return o2dString().sb.d2bString()
    }

    /// `八进制`转`十进制`
    /// - Returns: `String`
    func o2dString() -> String {
        var sum = 0
        for c in base {
            let number = c.sb.toString().sb.toInt()
            sum = sum * 8 + number
        }
        return "\(sum)"
    }

    /// `八进制`转`十六进制`
    /// - Returns: `String`
    func o2hString() -> String {
        return o2dString().sb.d2hString()
    }

    /// `十进制`转`二进制`
    /// - Returns: `String`
    func d2bString() -> String {
        var d = toInt()
        var str = ""
        while d > 0 {
            str = "\(d % 2)" + str
            d /= 2
        }
        return str
    }

    /// `十进制`转`八进制`
    /// - Returns: `String`
    func d2oString() -> String {
        return String(format: "%0O", toInt())
    }

    /// `十进制`转`十六进制`
    /// - Returns: `String`
    func d2hString() -> String {
        return String(format: "%0X", toInt())
    }

    /// `十六进制`转`二进制`
    /// - Returns: `String`
    func h2bString() -> String {
        return h2dString().sb.d2bString()
    }

    /// `十六进制`转`八进制`
    /// - Returns: `String`
    func h2oString() -> String {
        return h2dString().sb.d2oString()
    }

    /// `十六进制`转`十进制`
    /// - Returns: `String`
    func h2dString() -> String {
        let str = toUpper()
        var sum = 0
        for i in str.utf8 {
            // 0-9 从48开始
            sum = sum * 16 + Int(i) - 48
            // A-Z 从65开始,但有初始值10,所以应该是减去55
            if i >= 65 {
                sum -= 7
            }
        }
        return "\(sum)"
    }
}

// MARK: - 转字典/字典数组
public extension SaberExt where Base == String {
    /// 字符串转`字典`
    func toDict() -> [String: Any]? {
        guard let data = toData() else { return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return dict
    }

    /// 字符串转`字典数组`
    func toDicts() -> [[String: Any]]? {
        guard let data = toData() else { return nil }
        guard let dicts = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return nil
        }
        return dicts
    }
}

// MARK: - Range
public extension SaberExt where Base == String {
    /// 字符串的完整 `NSRange`
    /// - Returns: `NSRange`
    func fullNSRange() -> NSRange {
        return NSRange(base.startIndex ..< base.endIndex, in: base)
    }

    /// 字符串的完整 `Range`
    /// - Returns: `Range<String.Index>?`
    func fullRange() -> Range<String.Index>? {
        return base.startIndex ..< base.endIndex
    }

    /// 将 `NSRange` 转换为 `Range<String.Index>`
    /// - Parameter NSRange:要转换的`NSRange`
    /// - Returns:在字符串中找到的 `NSRange` 的等效 `Range<String.Index>`
    func range(_ nsRange: NSRange) -> Range<String.Index> {
        guard let range = Range(nsRange, in: base) else { fatalError("Failed to find range \(nsRange) in \(base)") }
        return range
    }

    /// 将 `Range<String.Index>` 转换为 `NSRange`
    /// - Parameter range:要转换的`Range<String.Index>`
    /// - Returns:在字符串中找到的 `Range` 的等效 `NSRange`
    func nsRange(_ range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: base)
    }

    /// 获取指定字符串在属性字符串中的范围
    /// - Parameter subStr:子串
    /// - Returns:某个子串在父串中的范围
    func subNSRange(_ subStr: String) -> NSRange {
        guard let range = base.range(of: subStr) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: base)
    }

    /// 获取某个`子串`在`父串`中的范围->`Range`
    /// - Parameter str:子串
    /// - Returns:某个子串在父串中的范围
    func range(_ subString: String) -> Range<String.Index>? {
        return base.range(of: subString)
    }
}

// MARK: - 常用方法
public extension SaberExt where Base == String {
    ///  字符串的第一个字符
    /// - Returns: `String?`
    func firstCharacter() -> String? {
        guard let first = base.first?.sb.toString() else { return nil }
        return first
    }

    /// 字符串最后一个字符
    /// - Returns: `String?`
    func lastCharacter() -> String? {
        guard let last = base.last?.sb.toString() else { return nil }
        return last
    }

    /// 返回一个本地化的字符串,带有可选的翻译注释
    /// - Parameter comment: 注释
    /// - Returns: `String`
    func toLocalized(comment: String = "") -> String {
        return NSLocalizedString(base, comment: comment)
    }

    /// 将字符串转换为 `slug 字符串`
    ///
    ///     "Swift is amazing".toSlug() -> "swift-is-amazing"
    ///
    /// - Returns:`slug格式`的字符串
    func toSlug() -> String {
        let lowercased = toLower()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.sb.lastCharacter() == "-" {
            filtered = String(filtered.dropLast())
        }

        while filtered.sb.firstCharacter() == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }

    /// 查找字符串中出现最频繁的字符
    ///
    ///     "This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter() -> "e"
    ///
    /// - Returns:出现最频繁的字符
    func mostCommonCharacter() -> Character? {
        let mostCommon = withoutSpacesAndNewLines().reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key
        return mostCommon
    }
}

// MARK: - 判断
public extension SaberExt where Base == String {
    /// 检查字符串是否包含一个或多个字母
    ///
    ///     "123abc".hasLetters -> true
    ///     "123".hasLetters -> false
    /// - Returns: `Bool`
    func hasLetters() -> Bool {
        return base.rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// 检查字符串是否只包含字母
    ///
    ///     "abc".isAlphabetic -> true
    ///     "123abc".isAlphabetic -> false
    ///
    /// - Returns: `Bool`
    func isAlphabetic() -> Bool {
        let hasLetters = base.rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = base.rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// 检查字符串是否包含一个或多个数字
    ///
    ///     "abcd".hasNumbers -> false
    ///     "123abc".hasNumbers -> true
    ///
    /// - Returns: `Bool`
    func hasNumbers() -> Bool {
        return base.rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// 检查字符串是否至少包含一个字母和一个数字
    ///
    ///     "123abc".isAlphaNumeric -> true
    ///     "abc".isAlphaNumeric -> false
    ///
    /// - Returns: `Bool`
    func isAlphaNumeric() -> Bool {
        let hasLetters = base.rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = base.rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = base.components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    /// 检查字符串是否为有效的`Swift`数字
    ///
    ///     "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///     "abc".isNumeric -> false
    ///
    /// - Returns: `Bool`
    func isSwiftNumeric() -> Bool {
        let scanner = Scanner(string: base)
        scanner.locale = NSLocale.current
        if #available(iOS 13.0, *) {
            return scanner.scanDecimal() != nil && scanner.isAtEnd
        } else {
            return scanner.scanDecimal(nil) && scanner.isAtEnd
        }
    }

    /// 判断是否是整数
    /// - Returns: `Bool`
    func isPureInt() -> Bool {
        let scan = Scanner(string: base)
        if #available(iOS 13.0, *) {
            return (scan.scanInt() != nil) && scan.isAtEnd
        } else {
            return scan.scanInt(nil) && scan.isAtEnd
        }
    }

    /// 检查字符串是否只包含数字
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    /// - Returns: `Bool`
    func isDigits() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: base))
    }

    /// 检查给定的字符串是否只包含空格
    /// - Returns: `Bool`
    func isWhitespace() -> Bool {
        return base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 检查给定的字符串是否拼写正确
    /// - Returns: `Bool`
    func isSpelledCorrectly() -> Bool {
        let checker = UITextChecker()
        let range = NSRange(base.startIndex ..< base.endIndex, in: base)

        let misspelledRange = checker.rangeOfMisspelledWord(
            in: base,
            range: range,
            startingAt: 0,
            wrap: false,
            language: Locale.preferredLanguages.first ?? "en"
        )
        return misspelledRange.location == NSNotFound
    }

    /// 检查字符串是否为回文
    ///
    ///     "abcdcba".isPalindrome -> true
    ///     "Mom".isPalindrome -> true
    ///     "A man a plan a canal, Panama!".isPalindrome -> true
    ///     "Mama".isPalindrome -> false
    ///
    /// - Returns: `Bool`
    func isPalindrome() -> Bool {
        let letters = base.filter { $0.isLetter }
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex ..< midIndex]
        let secondHalf = letters[midIndex ..< letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    /// 检查字符串是否只包含唯一字符(没有重复字符)
    /// - Returns: `Bool`
    func hasUniqueCharacters() -> Bool {
        guard base.count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in base {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    /// 判断是不是九宫格键盘
    /// - Returns: `Bool`
    func isNineKeyBoard() -> Bool {
        let other: NSString = "➋➌➍➎➏➐➑➒"
        let len = base.count
        for _ in 0 ..< len {
            if !(other.range(of: base).location != NSNotFound) {
                return false
            }
        }
        return true
    }

    /// 利用正则表达式判断是否是手机号码
    /// - Returns: `Bool`
    func isTelNumber() -> Bool {
        let pattern = "^1[3456789]\\d{9}$"
        return regexp(pattern)
    }

    /// 是否是字母数字(指定范围)
    /// - Returns: `Bool`
    func isAlphanueric(minLen: Int, maxLen: Int) -> Bool {
        let pattern = "^[0-9a-zA-Z_]{\(minLen),\(maxLen)}$"
        return regexp(pattern)
    }

    /// 是否是字母与数字
    /// - Returns: `Bool`
    func isAlphanueric() -> Bool {
        let pattern = "^[A-Za-z0-9]+$"
        return isMatchRegexp(pattern)
    }

    /// 是否是纯汉字
    /// - Returns: `Bool`
    func isChinese() -> Bool {
        let pattern = "(^[\u{4e00}-\u{9fef}]+$)"
        return regexp(pattern)
    }

    /// 是否是邮箱格式
    /// - Returns: `Bool`
    func isEmail2() -> Bool {
        //     let pattern = "^([a-z0-9A-Z]+[-_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$"
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        return regexp(pattern)
    }

    /// 检查字符串是否为有效的电子邮件格式
    ///
    /// - Note:请注意,此属性不会针对电子邮件服务器验证电子邮件地址.它只是试图确定其格式是否适合电子邮件地址
    ///
    ///     "john@doe.com".isValidEmail -> true
    ///
    /// - Returns: `Bool`
    func isEmail() -> Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 是否是有效昵称,即允许`中文`、`英文`、`数字`
    /// - Returns: `Bool`
    func isNickName() -> Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return regexp(rgex)
    }

    /// 是否为合法用户名
    func validateUserName() -> Bool {
        let rgex = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        return regexp(rgex)
    }

    /// 设置密码必须符合由`数字`、`大写字母`、`小写字母`、`特殊符`
    /// - Parameter complex:是否复杂密码 至少其中(两种/三种)组成密码
    /// - Returns: `Bool`
    func password(_ complex: Bool = false) -> Bool {
        var pattern = "^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{8,20}$"
        if complex {
            pattern = "^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{8,20}$"
        }
        return regexp(pattern)
    }

    /// 是否为`0-9`之间的数字(字符串的组成是:`0-9`之间的`数字`)
    /// - Returns:返回结果
    func isNumberValue() -> Bool {
        guard !base.isEmpty else {
            return false
        }
        let rgex = "^[\\d]*$"
        return regexp(rgex)
    }

    /// 是否为`数字`或者`小数点`(字符串的组成是:`0-9之间`的`数字`或者`小数点`即可)
    /// - Returns:返回结果
    func isValidNumberAndDecimalPoint() -> Bool {
        guard !base.isEmpty else {
            return false
        }
        let rgex = "^[\\d.]*$"
        return regexp(rgex)
    }

    /// 正则匹配用户身份证号15或18位
    /// - Returns:返回结果
    func isIDNumber() -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        return regexp(pattern)
    }

    /// 严格判断是否有效的身份证号码,检验了省份,生日,校验位,不过没检查市县的编码
    var isValidIDNumber: Bool {
        let str = base.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.sb.isIDNumber() {
            return false
        }
        // 省份代码
        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        if !areaArray.contains(str.subString(to: 2)) {
            return false
        }
        var regex = NSRegularExpression()
        var numberOfMatch = 0
        var year = 0
        switch len {
        case 15:
            // 15位身份证
            // 这里年份只有两位,00被处理为闰年了,对2000年是正确的,对1900年是错误的,不过身份证是1900年的应该很少了
            year = Int(str.subString(from: 6, length: 2))!
            if isLeapYear(year: year) { // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: len))

            if numberOfMatch > 0 {
                return true
            } else {
                return false
            }
        case 18:
            // 18位身份证
            year = Int(str.subString(from: 6, length: 4))!
            if isLeapYear(year: year) {
                // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: len))
            if numberOfMatch > 0 {
                var s = 0
                let jiaoYan = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3]
                for i in 0 ..< 17 {
                    if let d = Int(str.slice(i ..< (i + 1))) {
                        s += d * jiaoYan[i % 10]
                    } else {
                        return false
                    }
                }
                let Y = s % 11
                let JYM = "10X98765432"
                let M = JYM.subString(from: Y, length: 1)
                if M == str.subString(from: 17, length: 1) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        default:
            return false
        }
    }

    /// 检查字符串是否是有效的URL
    ///
    ///     "https://google.com".isValidURL -> true
    ///
    /// - Returns: `Bool`
    func isURL() -> Bool {
        return URL(string: base) != nil
    }

    /// 检查字符串是否是有效带协议头的URL
    ///
    ///     "https://google.com".isValidSchemedURL -> true
    ///     "google.com".isValidSchemedURL -> false
    ///
    /// - Returns: `Bool`
    func isSchemedURL() -> Bool {
        guard let url = URL(string: base) else { return false }
        return url.scheme != nil
    }

    /// 检查字符串是否是有效的https URL
    ///
    ///     "https://google.com".isValidHttpsURL -> true
    ///
    /// - Returns: `Bool`
    func isHTTPSURL() -> Bool {
        guard let url = URL(string: base) else { return false }
        return url.scheme == "https"
    }

    /// 检查字符串是否是有效的http URL
    ///
    ///     "http://google.com".isValidHttpURL -> true
    ///
    /// - Returns: `Bool`
    func isHTTPURL() -> Bool {
        guard let url = URL(string: base) else { return false }
        return url.scheme == "http"
    }

    /// 检查字符串是否是有效的文件URL
    ///
    ///     "file://Documents/file.txt".isValidFileURL -> true
    ///
    /// - Returns: `Bool`
    func isFileURL() -> Bool {
        return URL(string: base)?.isFileURL ?? false
    }

    /// 判断是否包含某个子串`区分大小写`
    /// - Parameter find:子串
    /// - Returns:`Bool`
    func contains(find: String) -> Bool {
        return contains(find, caseSensitive: true)
    }

    /// 检查字符串是否包含子字符串的一个或多个实例
    ///
    ///     "Hello World!".contain("O") -> false
    ///     "Hello World!".contain("o", caseSensitive:false) -> true
    /// - Parameters:
    ///   - string:要搜索的子字符串
    ///   - caseSensitive:是否区分大小写(默认值为`true`)
    /// - Returns:如果字符串包含一个或多个子字符串实例,则为`true`
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return base.range(of: string, options: .caseInsensitive) != nil
        }
        return base.range(of: string) != nil
    }

    ///  判断是否包含某个子串`忽略大小写`
    /// - Parameter find:子串
    /// - Returns:`Bool`
    func containsIgnoringCase(find: String) -> Bool {
        return contains(find, caseSensitive: false)
    }

    /// 检查字符串是否以子字符串开头
    ///
    ///     "hello World".starts(with:"h") -> true
    ///     "hello World".starts(with:"H", caseSensitive:false) -> true
    /// - Parameters:
    ///   - suffix:搜索字符串是否以开头的子字符串
    ///   - caseSensitive:是否区分大小写(默认为`true`)
    /// - Returns:`true`
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return toLower().hasPrefix(prefix.sb.toLower())
        }
        return base.hasPrefix(prefix)
    }

    /// 检查字符串是否以子字符串结尾
    ///
    ///     "Hello World!".ends(with:"!") -> true
    ///     "Hello World!".ends(with:"WoRld!", caseSensitive:false) -> true
    /// - Parameters:
    ///   - suffix:用于搜索字符串是否以结尾的子字符串
    ///   - caseSensitive:是否区分大小写(默认为`true`)
    /// - Returns:`Bool`
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return toLower().hasSuffix(suffix.sb.toLower())
        }
        return base.hasSuffix(suffix)
    }
}

// MARK: - 字符串处理
public extension SaberExt where Base == String {
    /// 从字符串中提取链接和文本
    /// - Returns: `(link: String, text: String)?`
    func hrefText() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\"(.*?)>(.*?)</a>"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: base, options: [], range: NSRange(location: 0, length: base.count))
        else {
            return nil
        }
        let link = toNSString().substring(with: result.range(at: 1))
        let text = toNSString().substring(with: result.range(at: 3))
        return (link, text)
    }

    /// 返回当前字符窜中的 `link range`数组
    /// - Returns: `[NSRange]?`
    func linkRanges() -> [NSRange]? {
        // url, ##, 中文字母数字
        let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
        // 遍历数组,生成range的数组
        var ranges = [NSRange]()

        for pattern in patterns {
            guard let regx = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
                return nil
            }
            let matches = regx.matches(in: base, options: [], range: NSRange(location: 0, length: base.count))
            for m in matches {
                ranges.append(m.range(at: 0))
            }
        }
        return ranges
    }

    /// 去除字符串前后的空格
    /// - Returns: `String`
    func trimmedSpace() -> String {
        let resultString = base.trimmingCharacters(in: CharacterSet.whitespaces)
        return resultString
    }

    /// 去除字符串前后的换行
    /// - Returns: `String`
    func trimmedNewLines() -> String {
        let resultString = base.trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }

    /// 移除字符串开头和结尾处的空格及换行符
    ///
    ///     "   hello  \n".trimmed -> "hello"
    ///
    /// - Returns: `String`
    func trimmed() -> String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 移除字符串中的空格
    /// - Returns: `String`
    func withoutSpaces() -> String {
        return base.replacingOccurrences(of: " ", with: "")
    }

    /// 移除字符串中的换行符
    /// - Returns: `String`
    func withoutNewLines() -> String {
        return base.replacingOccurrences(of: "\n", with: "")
    }

    /// 移除字符串中的空格及换行符
    ///
    ///     "   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "SwifterSwift"
    ///
    /// - Returns: `String`
    func withoutSpacesAndNewLines() -> String {
        return base.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    /// 将正则表达式加上`"\"`进行保护,将元字符转化成字面值
    ///
    ///     "hello ^$ there" -> "hello \\^\\$ there"
    ///
    /// - Returns: `String`
    func regexEscaped() -> String {
        return NSRegularExpression.escapedPattern(for: base)
    }
}

// MARK: - URL编解码(属性)
public extension SaberExt where Base == String {
    /// 编码`URL`字符串(`URL`转义字符串)
    ///
    ///     "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    /// - Returns: `String`
    func urlEncoded() -> String {
        return base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    /// 把编码过的`URL`字符串解码成可读格式(`URL`字符串解码)
    ///
    ///     "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    /// - Returns: `String`
    func urlDecoded() -> String {
        return base.removingPercentEncoding ?? base
    }

    /// 转义字符串(`URL`编码)
    ///
    ///     var str = "it's easy to encode strings"
    ///     str.urlEncode()
    ///     print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    /// - Returns: `String`
    @discardableResult
    func urlEncode() -> String {
        if let encoded = base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            base = encoded
        }
        return base
    }

    /// `URL`字符串转换为可读字符串(`URL`转义字符串解码)
    ///
    ///     var str = "it's%20easy%20to%20decode%20strings"
    ///     str.urlDecode()
    ///     print(str) // prints "it's easy to decode strings"
    ///
    /// - Returns: `String`
    @discardableResult
    func urlDecode() -> String {
        if let decoded = base.removingPercentEncoding {
            base = decoded
        }
        return base
    }
}

// MARK: - base64(属性)
public extension SaberExt where Base == String {
    /// `Base64` 编解码
    /// - Parameter encode:`true`:编码 `false`:解码
    /// - Returns: 编解码结果
    func base64String(encode: Bool) -> String? {
        if encode {
            return base64Encoded()
        } else {
            return base64Decoded()
        }
    }

    /// `base64`加密
    ///
    ///     "Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    func base64Encoded() -> String? {
        let plainData = toData()
        return plainData?.base64EncodedString()
    }

    /// `base64`解密
    ///
    ///     "SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
    ///
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }

        let remainder = base.count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: base + padding, options: .ignoreUnknownCharacters) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

// MARK: - unicode编码和解码
public extension SaberExt where Base == String {
    /// `Unicode`编码
    /// - Returns:`unicode`编码后的字符串
    func unicodeEncode() -> String {
        var tempStr = String()
        for v in base.utf16 {
            if v < 128 {
                tempStr.append(Unicode.Scalar(v)!.escaped(asASCII: true))
                continue
            }
            let codeStr = String(v, radix: 16, uppercase: false)
            tempStr.append("\\u" + codeStr)
        }

        return tempStr
    }

    /// `Unicode`解码
    /// - Returns:`unicode`解码后的字符串
    func unicodeDecode() -> String {
        let tempStr1 = base.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print("😭出错啦! \(error.localizedDescription)")
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

// MARK: - Notification.Name
public extension SaberExt where Base == String {
    /// 通知名称
    var toNotificationName: Notification.Name {
        return Notification.Name(base)
    }
}

// MARK: - 位置
public extension SaberExt where Base == String {
    /// 地理编码(`地址转坐标`)
    /// - Parameter completionHandler: 回调函数
    func locationEncode(completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(base, completionHandler: completionHandler)
    }
}

// MARK: - emoji
public extension SaberExt where Base == String {
    /// 是否为单个`emoji`表情
    /// - Returns: `Bool`
    func isSingleEmoji() -> Bool {
        return base.count == 1 && containsEmoji()
    }

    /// 包含`emoji`表情
    /// - Returns: `Bool`
    func containsEmoji() -> Bool {
        return base.contains { $0.sb.isEmoji() }
    }

    /// 只包含`emoji`表情
    /// - Returns: `Bool`
    func containsOnlyEmoji() -> Bool {
        return !base.isEmpty && !base.contains { !$0.sb.isEmoji() }
    }

    /// 提取`emoji`表情字符串
    /// - Returns: `String`
    func emojiString() -> String {
        return emojis().map { String($0) }.reduce("",+)
    }

    /// 提取`emoji`表情数组
    /// - Returns: `[Character]`
    func emojis() -> [Character] {
        return base.filter { $0.sb.isEmoji() }
    }

    /// 提取单元编码标量
    /// - Returns: `[UnicodeScalar]`
    func emojiScalars() -> [UnicodeScalar] {
        return base.filter { $0.sb.isEmoji() }.flatMap { $0.unicodeScalars }
    }

    /// 移除字符串中的`emoji`表情
    /// - Returns: `String`
    func noneEmoji() -> String {
        var chars: [Character] = []
        base.forEach { char in
            if !char.sb.isEmoji() {
                chars.append(char)
            }
        }
        return String(chars)
    }
}

// MARK: - URL
public extension SaberExt where Base == String {
    /// 提取出字符串中所有的`URL`链接
    /// - Returns: `[String]?`
    func urls() -> [String]? {
        var urls = [String]()
        // 创建一个正则表达式对象
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) else {
            return nil
        }
        // 匹配字符串,返回结果集
        let res = dataDetector.matches(in: base, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: base.count))
        // 取出结果
        for checkingRes in res {
            urls.append(toNSString().substring(with: checkingRes.range))
        }
        return urls
    }

    /// 截取参数列表
    /// - Returns: `[String: Any]`
    func urlParamters() -> [String: Any] {
        guard
            let urlComponents = NSURLComponents(string: base),
            let queryItems = urlComponents.queryItems
        else {
            return [:]
        }

        var parameters = [String: Any]()
        for item in queryItems {
            guard let value = item.value else {
                continue
            }
            if let exist = parameters[item.name] {
                if var exist = exist as? [String] {
                    exist.append(value)
                } else {
                    parameters[item.name] = [exist as! String, value]
                }
            } else {
                parameters[item.name] = value
            }
        }
        return parameters
    }
}

// MARK: - Path
public extension String {
    /// 路径字符串的最后一个路径组件
    /// - Returns: `String`
    func lastPathComponent() -> String {
        return (self as NSString).lastPathComponent
    }

    /// 路径的扩展名
    /// - Returns: `String`
    func pathExtension() -> String {
        return (self as NSString).pathExtension
    }

    /// 返回删除了最后一个路径组件之后的字符串
    /// - Returns: `String`
    func deletingLastPathComponent() -> String {
        return (self as NSString).deletingLastPathComponent
    }

    /// 返回删除了路径扩展之后的字符串
    /// - Returns: `String`
    func deletingPathExtension() -> String {
        return (self as NSString).deletingPathExtension
    }

    /// 获取路径组件数组
    /// - Returns: `[String]`
    func pathComponents() -> [String] {
        return (self as NSString).pathComponents
    }

    /// 添加路径组件类似`NSString=>appendingPathComponent(str:String)`
    ///
    /// - Note:此方法仅适用于文件路径(例如,URL 的字符串表示形式
    /// - Parameter str:要添加的路径组件(如果需要可以在前面添加分隔符`/`)
    /// - Returns:添加路径组件后而生成的新字符串
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    /// 添加路径扩展类似`NSString=>appendingPathExtension(str:String)`
    /// - Parameters str:要添加的扩展
    /// - Returns:添加路径扩展后而生成的新字符串
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
}

// MARK: - 沙盒
public extension String {
    /// `Support` 追加后的`目录 / 文件地址` `备份在 iCloud`
    var appendBySupport: String {
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// `Documents` 追加后的`目录／文件地址`
    var appendByDocument: String {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// `Cachees` 追加后的`目录／文件地址`
    var appendByCache: String {
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// `tmp` 追加后的`目录／文件地址`
    var appendByTemp: String {
        let directory = NSTemporaryDirectory()
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// `Support` 追加后的`目录／文件地址` `备份在 iCloud`
    var urlBySupport: URL {
        var fileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        _ = appendByDocument
        fileURL = fileURL.appendingPathComponent(self)
        return fileURL
    }

    /// `Documents` 追加后的`目录／文件地址`
    var urlByDocument: URL {
        var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        _ = appendByDocument
        fileURL = fileURL.appendingPathComponent(self)
        return fileURL
    }

    /// `Cachees` 追加后的`目录／文件地址`
    var urlByCache: URL {
        var fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        _ = appendByCache
        fileURL = fileURL.appendingPathComponent(self)
        return fileURL
    }

    /// 删除文件
    func removeFile() {
        if FileManager.default.fileExists(atPath: self) {
            do {
                try FileManager.default.removeItem(atPath: self)
            } catch {
                debugPrint("文件删除失败!")
            }
        }
    }

    /// 创建目录
    /// 如 `cache/`；以`/`结束代表是`目录`
    func createDirs(_ directory: String = NSHomeDirectory()) {
        let path = contains(NSHomeDirectory()) ? self : "\(directory)/\(self)"
        let dirs = path.components(separatedBy: "/")
        let dir = dirs[0 ..< dirs.count - 1].joined(separator: "/")
        if !FileManager.default.fileExists(atPath: dir) {
            do {
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - 正则相关运算符
/// 定义操作符
infix operator =~: RegPrecedence
precedencegroup RegPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

/// 正则匹配操作符
public func =~ (lhs: String, rhs: String) -> Bool {
    return lhs.sb.regexp(rhs)
}

// MARK: - 正则
public extension SaberExt where Base == String {
    /// 验证`字符串`是否匹配`正则表达式`匹配
    /// - Parameters pattern:正则表达式
    /// - Returns:如果字符串与模式匹配,则返回:`true`
    func matches(pattern: String) -> Bool {
        return base.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 验证`字符串`是否与`正则表达式`匹配
    /// - Parameters:
    ///   - regex:进行验证的正则表达式
    ///   - options:要使用的匹配选项
    /// - Returns:如果字符串与正则表达式匹配,则返回:`true`
    func matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(base.startIndex ..< base.endIndex, in: base)
        return regex.firstMatch(in: base, options: options, range: range) != nil
    }

    /// 正则校验
    /// - Parameter pattern:要校验的正则表达式
    /// - Returns:是否通过
    func regexp(_ pattern: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

    /// 返回指定表达式的值
    /// - Parameters:
    ///   - pattern:正则表达式
    ///   - count:匹配数量
    func regexpText(_ pattern: String, count: Int = 1) -> [String]? {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: base, options: [], range: NSRange(location: 0, length: base.count))
        else {
            return nil
        }
        var texts = [String]()
        for idx in 1 ... count {
            let text = toNSString().substring(with: result.range(at: idx))
            texts.append(text)
        }
        return texts
    }

    /// 是否有与正则匹配的项
    /// - Parameter pattern:正则表达式
    /// - Returns:是否匹配
    func isMatchRegexp(_ pattern: String) -> Bool {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let result = regx.matches(in: base, options: .reportProgress, range: NSRange(location: 0, length: base.utf16.count))
        return (!result.isEmpty)
    }

    /// 获取匹配的`NSRange`
    /// - Parameters:
    ///   - pattern:匹配规则
    /// - Returns:返回匹配的[NSRange]结果
    func matchRange(_ pattern: String) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return []
        }
        let matches = regex.matches(in: base, options: [], range: NSRange(location: 0, length: base.utf16.count))
        guard !matches.isEmpty else {
            return []
        }
        return matches.map { value in
            value.range
        }
    }
}

// MARK: - 运算符
public extension String {
    /// 重载 `Swift` 的`包含运算符`以匹配正则表达式模式
    /// - Parameters:
    ///   - lhs:检查正则表达式模式的字符串
    ///   - rhs:要匹配的正则表达式模式
    /// - Returns:如果字符串与模式匹配,则返回 true
    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression) != nil
    }

    /// 重载 `Swift` 的`包含运算符`以匹配正则表达式
    /// - Parameters:
    ///   - lhs:检查正则表达式的字符串
    ///   - rhs:要匹配的正则表达式
    /// - Returns:如果字符串中的正则表达式至少有一个匹配项,则返回:`true`
    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let range = NSRange(lhs.startIndex ..< lhs.endIndex, in: lhs)
        return rhs.firstMatch(in: lhs, range: range) != nil
    }

    /// 生成重复字符串
    ///
    ///     'bar' * 3 -> "barbarbar"
    /// - Parameters:
    ///   - lhs:要重复的字符串
    ///   - rhs:重复字符串的次数
    /// - Returns:给定字符串重复 n 次的新字符串
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// 生成重复字符串
    ///
    ///     3 * 'bar' -> "barbarbar"
    /// - Parameters:
    ///   - lhs:重复字符的次数
    ///   - rhs:要重复的字符串
    /// - Returns:给定字符串重复 n 次的新字符串
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}

// MARK: - 私有
private extension SaberExt where Base == String {
    /// 是否是闰年
    /// - Parameter year:年份
    /// - Returns:返回是否是闰年
    func isLeapYear(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else if year % 4 == 0 {
            return true
        } else {
            return false
        }
    }
}
