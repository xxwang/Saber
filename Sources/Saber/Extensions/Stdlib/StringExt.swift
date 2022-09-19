import Foundation
#if canImport(UIKit)
    import UIKit
#endif

#if canImport(AppKit)
    import AppKit
#endif

extension String: Saberable {}

// MARK: - 属性
public extension String {
    /// 字典
    var object: [String: Any]? {
        guard let data = data else {
            return nil
        }
        guard let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return object
    }

    /// 字典数组
    var objectArray: [[String: Any]]? {
        guard let data = data else {
            return nil
        }
        guard let object = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return nil
        }
        return object
    }
}

// MARK: - emoji
public extension SaberExt where Base == String {
    /// 是否为单个emoji表情
    var isSingleEmoji: Bool {
        return self.base.count == 1 && containsEmoji
    }

    /// 包含emoji表情
    var containsEmoji: Bool {
        return self.base.contains { $0.sb.isEmoji }
    }

    /// 只包含emoji表情
    var containsOnlyEmoji: Bool {
        return !self.base.isEmpty && !self.base.contains { !$0.sb.isEmoji }
    }

    /// 提取emoji表情字符串
    var emojiString: String {
        return emojis.map { String($0) }.reduce("",+)
    }

    /// 提取emoji表情数组
    var emojis: [Character] {
        return self.base.filter { $0.sb.isEmoji }
    }

    /// 提取单元编码标量
    var emojiScalars: [UnicodeScalar] {
        return self.base.filter { $0.sb.isEmoji }.flatMap { $0.unicodeScalars }
    }
}

// MARK: - 属性
public extension String {
    /// Int
    var int: Int {
        return Int(self) ?? 0
    }

    /// UInt
    var uInt: UInt {
        return UInt(self) ?? 0
    }

    /// Int64
    var int64: Int64 {
        return Int64(self) ?? 0
    }

    /// Int64
    var uInt64: UInt64 {
        return UInt64(self) ?? 0
    }

    /// Float
    var float: Float {
        return Float(self) ?? 0
    }

    /// Double
    var double: Double {
        return Double(self) ?? 0
    }

    /// CGFloat
    var cgFloat: CGFloat {
        return CGFloat(double)
    }

    /// NSNumber
    var nsNumber: NSNumber {
        return NSNumber(value: double)
    }

    /// Character
    var character: Character? {
        guard let n = Int(self),
              let scalar = UnicodeScalar(n)
        else { return nil }
        return Character(scalar)
    }

    /// String
    var string: String {
        return String(self)
    }

    /// 字符串转布尔值(失败返回nil)
    ///
    ///        "1".bool -> true
    ///        "False".bool -> false
    ///        "Hello".bool = nil
    ///
    var bool: Bool? {
        let trimmed = self.trimmed.lowercased()
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
            return nil
        }
    }

    /// 转`NSString`字符串
    var nsString: NSString {
        return NSString(string: self)
    }

    /// 字符串转属性字符串
    var attributedString: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }

    /// `utf8`格式`Data`
    var data: Data? {
        return asData()
    }

    /// 图片资源名称转图片对象
    var image: UIImage? {
        return UIImage(named: self)
    }

    /// 16进制颜色值字符串转UIColor对象
    var hexColor: UIColor {
        return UIColor(hex: self)
    }

    /// 将16进制字符串转为Int
    var hexAsInt: Int {
        return Int(self, radix: 16) ?? 0
    }

    /// 字符串的字符数组表示
    var characters: [Character] {
        return Array(self)
    }

    /// 字符串转换成驼峰命名法(并移除空字符串)
    ///
    ///        "sOme vAriable naMe".camelCased -> "someVariableName"
    ///
    var camelCased: String {
        let source = lowercased()
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

    /// 拉丁语字符串转当前地区字符串
    ///
    ///        "Hèllö Wórld!".latinized -> "Hello World!"
    ///
    var latinizedAsLocal: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }

    /// 字符串的长度
    var length: Int {
        return count
    }

    /// 检查字符串是否包含一个或多个emoji(表情符号)
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    var containEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600 ... 0x1F64F, // Emoticons
                 0x1F300 ... 0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680 ... 0x1F6FF, // Transport and Map
                 0x1F1E6 ... 0x1F1FF, // Regional country flags
                 0x2600 ... 0x26FF, // Misc symbols
                 0x2700 ... 0x27BF, // Dingbats
                 0xE0020 ... 0xE007F, // Tags
                 0xFE00 ... 0xFE0F, // Variation Selectors
                 0x1F900 ... 0x1F9FF, // Supplemental Symbols and Pictographs
                 127000 ... 127600, // Various asian characters
                 65024 ... 65039, // Variation selector
                 9100 ... 9300, // Misc items
                 8400 ... 8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    /// 移除字符串中的Emoji表情
    var noneEmoji: String {
        do {
            let regex = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive)

            let modifiedString = regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count), withTemplate: "")

            return modifiedString
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }

    /// 字符串的第一个字符(返回可选结果)
    ///
    ///        "Hello".firstCharacterAsString -> Optional("H")
    ///        "".firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }

    /// 字符串的最后一个字符(返回可选类型结果)
    ///
    ///        "Hello".lastCharacterAsString -> Optional("o")
    ///        "".lastCharacterAsString -> nil
    ///
    var lastCharacterAsString: String? {
        guard let last = last else { return nil }
        return String(last)
    }

    /// 检查字符串是否包含一个或多个字母
    ///
    ///        "123abc".hasLetters -> true
    ///        "123".hasLetters -> false
    ///
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// 检查字符串是否只包含字母
    ///
    ///        "abc".isAlphabetic -> true
    ///        "123abc".isAlphabetic -> false
    ///
    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// 检查字符串是否包含一个或多个数字
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// 检查字符串是否至少包含一个字母和一个数字
    ///
    ///        // useful for passwords
    ///        "123abc".isAlphaNumeric -> true
    ///        "abc".isAlphaNumeric -> false
    ///
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    // FIXME: - 待完善
    /// 检查字符串是否为有效的Swift数字
    ///
    ///     "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///     "abc".isNumeric -> false
    ///
//    var isNumeric: Bool {
//        let scanner = Scanner(string: self)
//        scanner.locale = NSLocale.current
//        if #available(iOS 13.0, *) {
//            return scanner.scanDecimal() != nil && scanner.isAtEnd
//        } else {
//            return scanner.scanDecimal(nil) && scanner.isAtEnd
//        }
//    }
//
//        /// 判断是否是整数
//    var isPureInt: Bool {
//        let scan = Scanner(string: self)
//        if #available(iOS 13.0, *) {
//            return (scan.scanInt() != nil) && scan.isAtEnd
//        } else {
//            return scan.scanInt(nil) && scan.isAtEnd
//        }
//    }

    /// 检查字符串是否只包含数字
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    /// 检查给定的字符串是否只包含空格
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // FIXME: - 待完善
//        /// 检查给定的字符串是否拼写正确
//    var isSpelledCorrectly: Bool {
//        let checker = UITextChecker()
//        let range = NSRange(startIndex ..< endIndex, in: self)
//
//        let misspelledRange = checker.rangeOfMisspelledWord(
//            in: self,
//            range: range,
//            startingAt: 0,
//            wrap: false,
//            language: Locale.preferredLanguages.first ?? "en"
//        )
//        return misspelledRange.location == NSNotFound
//    }

    /// 检查字符串是否为回文
    ///
    ///     "abcdcba".isPalindrome -> true
    ///     "Mom".isPalindrome -> true
    ///     "A man a plan a canal, Panama!".isPalindrome -> true
    ///     "Mama".isPalindrome -> false
    ///
    var isPalindrome: Bool {
        let letters = filter { $0.isLetter }
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex ..< midIndex]
        let secondHalf = letters[midIndex ..< letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    /// 检查字符串是否只包含唯一字符
    var hasUniqueCharacters: Bool {
        guard count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in self {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    /// 判断是不是九宫格键盘
    var isNineKeyBoard: Bool {
        let other: NSString = "➋➌➍➎➏➐➑➒"
        let len = count
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        return true
    }

    /// 检查字符串是否为有效的电子邮件格式
    ///
    /// - Note: 请注意,此属性不会针对电子邮件服务器验证电子邮件地址.它只是试图确定其格式是否适合电子邮件地址
    ///
    ///        "john@doe.com".isValidEmail -> true
    ///
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 检查字符串是否是有效的URL
    ///
    ///        "https://google.com".isValidURL -> true
    ///
    var isValidURL: Bool {
        return URL(string: self) != nil
    }

    /// 检查字符串是否是有效带协议头的URL
    ///
    ///        "https://google.com".isValidSchemedURL -> true
    ///        "google.com".isValidSchemedURL -> false
    ///
    var isValidSchemedURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 检查字符串是否是有效的https URL
    ///
    ///        "https://google.com".isValidHttpsURL -> true
    ///
    var isValidHttpsURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }

    /// 检查字符串是否是有效的http URL
    ///
    ///        "http://google.com".isValidHttpURL -> true
    ///
    var isValidHttpURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }

    /// 检查字符串是否是有效的文件URL
    ///
    ///        "file://Documents/file.txt".isValidFileURL -> true
    ///
    var isValidFileURL: Bool {
        return URL(string: self)?.isFileURL ?? false
    }

    /// 去除字符串前后的空格
    var trimmedSpace: String {
        let resultString = trimmingCharacters(in: CharacterSet.whitespaces)
        return resultString
    }

    /// 去除字符串前后的换行
    var trimmedNewLines: String {
        let resultString = trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }

    /// 移除字符串开头和结尾处的空格及换行符
    ///
    ///        "   hello  \n".trimmed -> "hello"
    ///
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 移除字符串中的空格
    var withoutSpaces: String {
        return replacingOccurrences(of: " ", with: "")
    }

    /// 移除字符串中的换行符
    var withoutNewLines: String {
        return replacingOccurrences(of: "\n", with: "")
    }

    /// 移除字符串中的空格及换行符
    ///
    ///        "   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "SwifterSwift"
    ///
    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    /// 将正则表达式加上"\"进行保护,将元字符转化成字面值
    ///
    /// "hello ^$ there" -> "hello \\^\\$ there"
    ///
    var regexEscaped: String {
        return NSRegularExpression.escapedPattern(for: self)
    }
}

// MARK: - Range
public extension String {
    /// 字符串的完整 `NSRange`
    var fullNSRange: NSRange {
        return NSRange(startIndex ..< endIndex, in: self)
    }

    /// 字符串的完整 `Range`
    var fullRange: Range<String.Index>? {
        return startIndex ..< endIndex
    }

    /// 将 `NSRange` 转换为 `Range<String.Index>`
    /// - Parameter NSRange: 要转换的`NSRange`
    /// - Returns: 在字符串中找到的 `NSRange` 的等效 `Range<String.Index>`
    func range(_ nsRange: NSRange) -> Range<Index> {
        guard let range = Range(nsRange, in: self) else { fatalError("Failed to find range \(nsRange) in \(self)") }
        return range
    }

    /// 将 `Range<String.Index>` 转换为 `NSRange`
    /// - Parameter range: 要转换的`Range<String.Index>`
    /// - Returns: 在字符串中找到的 `Range` 的等效 `NSRange`
    func nsRange(_ range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// 获取指定字符串在属性字符串中的范围
    /// - Parameter subStr: 子串
    /// - Returns: 某个子串在父串中的范围
    func subNSRange(_ subStr: String) -> NSRange {
        guard let range = range(of: subStr) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: self)
    }

    /// 获取某个子串在父串中的范围->Range
    /// - Parameter str: 子串
    /// - Returns: 某个子串在父串中的范围
    func range(_ subString: String) -> Range<String.Index>? {
        return range(of: subString)
    }
}

// MARK: - NSAttributedString
public extension String {
    // FIXME: - 待完善
//        /// 加粗字符串
//    var bold: NSAttributedString {
//        return NSMutableAttributedString(
//            string: self,
//            attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]
//        )
//    }

    /// 下划线字符串
    var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    /// 删除线字符串
    var strikethrough: NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)]
        )
    }
    // FIXME: - 待完善
//        /// 斜体字符串
//    var italic: NSAttributedString {
//        return NSMutableAttributedString(
//            string: self,
//            attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)]
//        )
//    }
//
//        /// 为字符串添加颜色
//        /// - Parameters color: 文本颜色
//        /// - Returns: 使用给定颜色着色的字符串的 NSAttributedString 版本
//    func colored(with color: UIColor) -> NSAttributedString {
//        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
//    }
}

// MARK: - 构造方法
public extension String {
    /// 从 base64 字符串创建一个新字符串(base64解码)
    ///
    ///        String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
    ///        String(base64: "hello") = nil
    /// - Parameters base64: base64字符串
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }

    /// 创建一个给定长度的新随机字符串
    ///
    ///        String(randomOfLength: 10) -> "gY8r3MHvlQ"
    /// - Parameters length: 字符串中的字符数
    init(randomOfLength length: Int) {
        guard length > 0 else {
            self.init()
            return
        }

        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1 ... length {
            randomString.append(base.randomElement()!)
        }
        self = randomString
    }
}

// MARK: - 下标
public extension String {
    /// 使用索引下标安全地获取字符串中对应的字符
    ///
    ///        "Hello World!"[safe: 3] -> "l"
    ///        "Hello World!"[safe: 20] -> nil
    /// - Parameters index: 索引下标
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

    /// 获取某个字符,如果不在范围内,返回nil
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
    ///        "Hello World!"[safe: 6..<11] -> "World"
    ///        "Hello World!"[safe: 21..<110] -> nil
    ///
    ///        "Hello World!"[safe: 6...11] -> "World!"
    ///        "Hello World!"[safe: 21...110] -> nil
    /// - Parameters range: 范围表达式
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

    /// 获取字符串指定NSRange的子字符串
    /// - Parameter bounds: 子字符串的范围,范围的边界必须是集合的有效索引
    /// - Returns: 字符串的一部分
    subscript(bounds: NSRange) -> Substring {
        guard let range = Range(bounds, in: self) else { fatalError("Failed to find range \(bounds) in \(self)") }
        return self[range]
    }
}

// MARK: - URL
public extension String {
    /// 把字符串转为URL(失败返回nil)
    ///
    ///        "https://google.com".url -> URL(string: "https://google.com")
    ///        "not url".url -> nil
    ///
    var url: URL? {
        if hasPrefix("http://") || hasPrefix("https://") {
            return URL(string: self)
        }
        return URL(fileURLWithPath: self)
    }

    /// 字符串转URLRequest
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        return URLRequest(url: url)
    }

    /// 提取出字符串中所有的URL链接
    var URLs: [String]? {
        var urls = [String]()
        // 创建一个正则表达式对象
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) else {
            return nil
        }
        // 匹配字符串,返回结果集
        let res = dataDetector.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count))
        // 取出结果
        for checkingRes in res {
            urls.append(nsString.substring(with: checkingRes.range))
        }
        return urls
    }

    /// 截取参数列表
    var urlParamters: [String: Any] {
        guard let urlComponents = NSURLComponents(string: self),
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
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    /// 路径的扩展名
    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    /// 返回删除最后一个路径组件之后字符串
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }

    /// 返回删除路径扩展之后的字符串
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }

    /// 获取路径组件数组
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    /// 添加路径组件类似`NSString appendingPathComponent(str: String)`
    ///
    /// - Note: 此方法仅适用于文件路径(例如,URL 的字符串表示形式
    /// - Parameter str: 要添加的路径组件(如果需要可以在前面添加分隔符`/`)
    /// - Returns: 添加路径组件后而生成的新字符串
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    /// 添加路径扩展类似`NSString appendingPathExtension(str: String)`
    /// - Parameters str: 要添加的扩展
    /// - Returns: 添加路径扩展后而生成的新字符串
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
}

// MARK: - 沙盒
public extension String {
    /// Support 追加后的目录 / 文件地址 `备份在 iCloud`
    var appendBySupport: String {
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// Documents 追加后的目录／文件地址
    var appendByDocument: String {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// Cachees 追加后的目录／文件地址
    var appendByCache: String {
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// tmp 追加后的目录／文件地址
    var appendByTemp: String {
        let directory = NSTemporaryDirectory()
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// Support 追加后的目录／文件地址 `备份在 iCloud`
    var urlBySupport: URL {
        var fileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        _ = appendByDocument
        fileURL = fileURL.appendingPathComponent(self)
        return fileURL
    }

    /// Documents 追加后的目录／文件地址
    var urlByDocument: URL {
        var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        _ = appendByDocument
        fileURL = fileURL.appendingPathComponent(self)
        return fileURL
    }

    /// Cachees 追加后的目录／文件地址
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
    /// 如 cache/；以`/`结束代表是目录
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

// MARK: - Date
public extension String {
    /// 格式化日期字符串成日期对象
    ///
    ///        "2017-01-15".date(withFormat: "yyyy-MM-dd") -> Date set to Jan 15, 2017
    ///        "not date string".date(withFormat: "yyyy-MM-dd") -> nil
    /// - Parameters format: 日期格式
    /// - Returns: 来自字符串的日期对象
    func date(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    /// 日期格式字符串转时间戳(秒)
    /// - Parameter format: 日期格式
    /// - Returns: 时间戳(秒)
    func timeStamp(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Double {
        let date = self.date(withFormat: format)
        return date?.timeIntervalSince1970 ?? 0
    }
}

// MARK: - 静态方法
public extension String {
    /// 给定长度的`乱数假文`字符串
    /// - Parameters length: 限制`乱数假文`字符数(默认为 445 - 完整的`乱数假文`)
    /// - Returns: 指定长度的`乱数假文`字符串
    static func loremIpsum(ofLength length: Int = 445) -> String {
        guard length > 0 else { return "" }

        // https://www.lipsum.com/
        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex ..< loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }

    /// 给定长度的随机字符串
    ///
    ///        String.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    /// - Parameters length: 字符串中的字符数
    /// - Returns: 给定长度的随机字符串
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1 ... length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }
}

// MARK: - 方法(类型转换)
public extension String {
    /// 将字符串转为浮点值(失败返回nil)
    /// - Parameters locale: 语言环境(默认为 Locale.current)
    /// - Returns: 给定字符串的可选浮点值
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }

    /// 将字符串转为双精度值(失败返回nil)
    /// - Parameters locale: 语言环境(默认为 Locale.current)
    /// - Returns: 给定字符串的可选双精度值
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }

    /// 将字符串转为CGFloat(失败返回nil)
    /// - Parameters locale: 语言环境(默认为 Locale.current)
    /// - Returns: 给定字符串的可选CGFloat
    func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }

    /// 字符串转Data?
    /// - Parameter encoding: 编码格式
    /// - Returns: Data?
    func asData(using encoding: String.Encoding = .utf8) -> Data? {
        return data(using: encoding)
    }

    /// 字符串转换成Double(存在精度损失)
    func stringAsDouble() -> Double? {
        guard let decimal = Decimal(string: self) else {
            return nil
        }
        return NSDecimalNumber(decimal: decimal).doubleValue
    }

    /// 汉字字符串转成拼音
    /// - Parameter isLatin: true：带声调,false：不带声调,默认 false
    /// - Returns: 拼音
    func pinYin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString

        // 将汉字转换为拼音(带音标)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        if !isTone {
            // 去掉拼音的音标
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        }
        let pinyin = mutableString as String

        return pinyin
    }

    /// 提取首字母, "爱国" --> AG
    /// - Parameter isUpper:  true：大写首字母,false: 小写首字母,默认 true
    /// - Returns: 字符串的首字母
    func pinYinInitials(_ isUpper: Bool = true) -> String {
        let pinYin = pinYin(false).components(separatedBy: " ")
        let initials = pinYin.compactMap { String(format: "%c", $0.cString(using: .utf8)![0]) }
        let result = isUpper ? initials.joined().uppercased() : initials.joined()

        return result
    }

    // FIXME: - 待完善
//        /// 字符串转 UIViewController
//    func asViewController() -> UIViewController? {
//        guard let controller = asObject() as? UIViewController else {
//            return nil
//        }
//        return controller
//    }

    /// 类名字符串转类实例(类需要是继承自NSObject)
    func asObject() -> NSObject? {
        guard let Class: AnyClass = asClass() else {
            return nil
        }

        let ClassType = Class as! NSObject.Type
        let instance = ClassType.init()

        return instance
    }

    /// 字符串转 AnyClass
    func asClass() -> AnyClass? {
        guard let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            return nil
        }

        let ClassNameString = "\(namespace.removeSomeStringUseSomeString(removeString: " ", replacingString: "_")).\(self)"
        guard let Class: AnyClass = NSClassFromString(ClassNameString) else {
            return nil
        }
        return Class
    }
}

// MARK: - 方法(mutating)
public extension String {
    /// 拉丁语字符串本地化
    ///
    ///        var str = "Hèllö Wórld!"
    ///        str.latinize()
    ///        print(str) // prints "Hello World!"
    ///
    @discardableResult
    mutating func latinize() -> String {
        self = folding(options: .diacriticInsensitive, locale: Locale.current)
        return self
    }

    /// 将字符串格式转换为驼峰命名法(`CamelCase`)
    ///
    ///        var str = "sOme vaRiabLe Name"
    ///        str.camelize()
    ///        print(str) // prints "someVariableName"
    ///
    @discardableResult
    mutating func camelize() -> String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            self = first + rest
            return self
        }
        let rest = String(source.dropFirst())

        self = first + rest
        return self
    }

    /// 字符串的首字符大写,其它字符保持原样
    ///
    ///        "hello world".firstCharacterUppercased() -> "Hello world"
    ///        "".firstCharacterUppercased() -> ""
    ///
    mutating func firstCharacterUppercased() {
        guard let first = first else { return }
        self = String(first).uppercased() + dropFirst()
    }

    /// 翻转字符串
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    /// 使用指定开始索引和长度切片字符串并赋值给`self`
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, length: 5)
    ///        print(str) // prints "World"
    /// - Parameters:
    ///   - index: 给定索引后要切片的字符数
    ///   - length: 给定索引后要切片的字符数
    @discardableResult
    mutating func slice(from index: Int, length: Int) -> String {
        if let str = slicing(from: index, length: length) {
            self = String(str)
        }
        return self
    }

    /// 将给定的字符串从开始索引切片到结束索引(如果适用)
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, to: 11)
    ///        print(str) // prints "World"
    /// - Parameters:
    ///   - start: 切片应该从的字符串索引
    ///   - end: 切片应该结束的字符串索引
    @discardableResult
    mutating func slice(from start: Int, to end: Int) -> String {
        guard end >= start else { return self }
        if let str = self[safe: start ..< end] {
            self = str
        }
        return self
    }

    /// 从指定起始索引切片到字符串结束
    ///
    ///        var str = "Hello World"
    ///        str.slice(at: 6)
    ///        print(str) // prints "World"
    /// - Parameters index: 切片应该开始的字符串索引
    @discardableResult
    mutating func slice(at index: Int) -> String {
        guard index < count else { return self }
        if let str = self[safe: index ..< count] {
            self = str
        }
        return self
    }

    /// 删除字符串开头和结尾的空格和换行符
    ///
    ///        var str = "  \n Hello World \n\n\n"
    ///        str.trim()
    ///        print(str) // prints "Hello World"
    ///
    @discardableResult
    mutating func trim() -> String {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return self
    }

    /// 截断字符串(将其剪切为给定数量的字符)
    ///
    ///        var str = "This is a very long sentence"
    ///        str.truncate(toLength: 14)
    ///        print(str) // prints "This is a very..."
    /// - Parameters:
    ///   - toLength: 切割前的最大字符数(从字符开头要保留的字符数量)
    ///   - trailing: 要添加到截断字符串末尾的字符串(默认为“...”)
    @discardableResult
    mutating func truncate(toLength length: Int, trailing: String? = "...") -> String {
        guard length > 0 else { return self }
        if count > length {
            self = self[startIndex ..< index(startIndex, offsetBy: length)] + (trailing ?? "")
        }
        return self
    }

    /// 转义字符串(URL编码)
    ///
    ///        var str = "it's easy to encode strings"
    ///        str.urlEncode()
    ///        print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    @discardableResult
    mutating func urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
        return self
    }

    /// URL字符串转换为可读字符串(URL转义字符串解码)
    ///
    ///        var str = "it's%20easy%20to%20decode%20strings"
    ///        str.urlDecode()
    ///        print(str) // prints "it's easy to decode strings"
    ///
    @discardableResult
    mutating func urlDecode() -> String {
        if let decoded = removingPercentEncoding {
            self = decoded
        }
        return self
    }

    /// 在开始时用另一个字符串填充字符串以适应长度参数大小
    ///
    ///   "hue".padStart(10) -> "       hue"
    ///   "hue".padStart(10, with: "br") -> "brbrbrbhue"
    /// - Parameters:
    ///   - length: 要填充的目标长度
    ///   - string: 填充字符串. 默认为`“ ”`
    @discardableResult
    mutating func padStart(_ length: Int, with string: String = " ") -> String {
        self = paddingStart(length, with: string)
        return self
    }

    /// 在开始时用另一个字符串填充字符串以适应长度参数大小
    ///
    ///   "hue".padEnd(10) -> "hue       "
    ///   "hue".padEnd(10, with: "br") -> "huebrbrbrb"
    /// - Parameters:
    ///   - length: 要填充的目标长度
    ///   - string: 填充字符串. 默认为`“ ”`
    @discardableResult
    mutating func padEnd(_ length: Int, with string: String = " ") -> String {
        self = paddingEnd(length, with: string)
        return self
    }
}

// MARK: - 方法
public extension String {
    /// 由换行符分隔的字符串数组(获取字符串行数, `\n`分割)
    ///
    ///        "Hello\ntest".lines() -> ["Hello", "test"]
    ///
    /// - Returns: 分割后的字符串数组
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }

    /// 获取文字的每一行字符串 空字符串为空数组(⚠️不适用于属性文本)
    /// - Parameters:
    ///   - maxWidth: 最大宽度
    ///   - font: 字体
    /// - Returns: 行字符串数组
    func lines(_ maxWidth: CGFloat, font: UIFont) -> [String] {
        // 段落样式
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping

        // UIFont字体转CFFont
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)

        // 属性字符串
        let attStr = NSMutableAttributedString(string: self)
        attStr.addAttributes([
            .paragraphStyle: style,
            NSAttributedString.Key(kCTFontAttributeName as String): cfFont,
        ], range: NSRange(location: 0, length: attStr.length))

        let frameSetter = CTFramesetterCreateWithAttributedString(attStr)

        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: maxWidth, height: 100000), transform: .identity)

        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(CFIndex(0), CFIndex(0)), path, nil)
        let lines = CTFrameGetLines(frame) as? [AnyHashable]
        var linesArray: [String] = []

        for line in lines ?? [] {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let range = NSRange(location: lineRange.location, length: lineRange.length)

            let lineString = (self as NSString).substring(with: range)
            CFAttributedStringSetAttribute(attStr, lineRange, kCTKernAttributeName, NSNumber(value: 0.0))
            linesArray.append(lineString)
        }
        return linesArray
    }

    /// 字符串中的字数(word)
    ///
    ///        "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: 字符串中包含的单词数
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

    /// 计算字符个数(英文 = 1,数字 = 1,汉语 = 2)
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
    ///        "SwifterSwift".unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns: 字符串中所有字符的 unicode
    func unicodeArray() -> [Int] {
        return unicodeScalars.map { Int($0.value) }
    }

    /// 字符串中所有单词的数组
    ///
    ///        "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: 字符串中包含的单词
    func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }

    /// 返回一个本地化的字符串,带有可选的翻译注释
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// 查找字符串中出现最频繁的字符
    ///
    ///        "This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter() -> "e"
    ///
    /// - Returns: 出现最频繁的字符
    func mostCommonCharacter() -> Character? {
        let mostCommon = withoutSpacesAndNewLines.reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key

        return mostCommon
    }

    /// 将字符串转换为 slug 字符串
    ///
    ///        "Swift is amazing".toSlug() -> "swift-is-amazing"
    ///
    /// - Returns: slug格式的字符串
    func toSlug() -> String {
        let lowercased = self.lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.lastCharacterAsString == "-" {
            filtered = String(filtered.dropLast())
        }

        while filtered.firstCharacterAsString == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }

    /// 检查字符串是否包含子字符串的一个或多个实例
    ///
    ///        "Hello World!".contain("O") -> false
    ///        "Hello World!".contain("o", caseSensitive: false) -> true
    /// - Parameters:
    ///   - string: 要搜索的子字符串
    ///   - caseSensitive: 为区分大小写的搜索设置true(默认值为true)
    /// - Returns: 如果字符串包含一个或多个子字符串实例,则为true
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }

    /// 判断是否包含某个子串
    /// - Parameter find: 子串
    /// - Returns: Bool
    func contains(find: String) -> Bool {
        return range(of: find) != nil
    }

    ///  判断是否包含某个子串 -- 忽略大小写
    /// - Parameter find: 子串
    /// - Returns: Bool
    func containsIgnoringCase(find: String) -> Bool {
        return range(of: find, options: .caseInsensitive) != nil
    }

    /// 符串中的子字符串计数
    ///
    ///        "Hello World!".count(of: "o") -> 2
    ///        "Hello World!".count(of: "L", caseSensitive: false) -> 3
    /// - Parameters:
    ///   - string: 要搜索的子字符串
    ///   - caseSensitive: 为区分大小写的搜索设置true(默认为true)
    /// - Returns: 子字符串在字符串中出现的计数
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }

    /// 检查字符串是否以子字符串结尾
    ///
    ///        "Hello World!".ends(with: "!") -> true
    ///        "Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
    /// - Parameters:
    ///   - suffix: 用于搜索字符串是否以结尾的子字符串
    ///   - caseSensitive: 为区分大小写的搜索设置true(默认为true)
    /// - Returns: 如果字符串以子字符串结尾,则返回true
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }

    /// 从字符串中获取指定开始位置到指定长度的子字符串
    ///
    ///        "Hello World".slicing(from: 6, length: 5) -> "World"
    /// - Parameters:
    ///   - index: 字符串索引开始
    ///   - length: 给定索引后要切片的字符数
    /// - Returns: 长度为字符数的切片子字符串
    func slicing(from index: Int, length: Int) -> String? {
        guard length >= 0, index >= 0, index < count else { return nil }
        guard index.advanced(by: length) <= count else {
            return self[safe: index ..< count]
        }
        guard length > 0 else { return "" }
        return self[safe: index ..< index.advanced(by: length)]
    }

    /// 检查字符串是否以子字符串开头
    ///
    ///        "hello World".starts(with: "h") -> true
    ///        "hello World".starts(with: "H", caseSensitive: false) -> true
    /// - Parameters:
    ///   - suffix: 搜索字符串是否以开头的子字符串
    ///   - caseSensitive: 为区分大小写的搜索设置为真(默认为真)
    /// - Returns: 如果字符串以子字符串开头,则返回 true
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }

    /// 截断的字符串(限于给定数量的字符)
    ///
    ///        "This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
    ///        "Short sentence".truncated(toLength: 14) -> "Short sentence"
    /// - Parameters:
    ///   - toLength: 切割前的最大字符数(从字符开头要保留的字符数量)
    ///   - trailing: 要添加到截断字符串末尾的字符串(默认为“...”)
    /// - Returns: 截断的字符串+尾巴
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 0 ..< count ~= length else { return self }
        return self[startIndex ..< index(startIndex, offsetBy: length)] + (trailing ?? "")
    }

    /// 省略字符串
    /// - Parameters:
    ///   - length: 开始省略长度(保留长度)
    ///   - suffix: 后缀
    func truncate(_ length: Int, suffix: String = "...") -> String {
        return count > length ? self[0 ..< length] + suffix : self
    }

    /// 分割字符串
    /// - Parameters:
    ///   - length: 每段长度
    ///   - separator: 分隔符
    func truncate(_ length: Int, separator: String = "-") -> String {
        var newValue = ""
        for (i, char) in enumerated() {
            if i > (count - length) {
                newValue += "\(char)"
            } else {
                newValue += (((i % length) == (length - 1)) ? "\(char)\(separator)" : "\(char)")
            }
        }
        return newValue
    }

    /// 分割字符串
    /// - Parameter delimiter: 分割根据
    /// - Returns: 分割结果数组
    func split(with char: String) -> [String] {
        let components = self.components(separatedBy: char)
        return components != [""] ? components : []
    }

    /// 验证字符串是否匹配正则表达式模式
    /// - Parameters pattern: 要验证的模式
    /// - Returns: 如果字符串与模式匹配,则返回：`true`
    func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 验证字符串是否与正则表达式匹配
    /// - Parameters:
    ///   - regex: 进行验证的正则表达式
    ///   - options: 要使用的匹配选项
    /// - Returns: 如果字符串与正则表达式匹配,则返回：`true`
    func matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(startIndex ..< endIndex, in: self)
        return regex.firstMatch(in: self, options: options, range: range) != nil
    }

    /// 返回一个新字符串,其中接收者指定范围内所有出现的正则表达式都被模板替换
    /// - Parameters:
    ///   - regex: 进行替换的正则表达式
    ///   - template: 替换正则表达式的模板
    ///   - options: 要使用的匹配选项
    ///   - searchRange: 要搜索的范围
    /// - Returns: 一个新字符串,其中接收者的 searchRange 中所有出现的正则表达式都被模板替换
    func replacingOccurrences(
        of regex: NSRegularExpression,
        with template: String,
        options: NSRegularExpression.MatchingOptions = [],
        range searchRange: Range<String.Index>? = nil
    ) -> String {
        let range = NSRange(searchRange ?? startIndex ..< endIndex, in: self)
        return regex.stringByReplacingMatches(in: self, options: options, range: range, withTemplate: template)
    }

    /// 通过填充返回一个字符串,以适应长度参数大小,并在开始时使用另一个字符串
    ///
    ///   "hue".paddingStart(10) -> "       hue"
    ///   "hue".paddingStart(10, with: "br") -> "brbrbrbhue"
    /// - Parameters:
    ///   - length: 要填充的目标长度
    ///   - string: 填充字符串. 默认为`“ ”`
    /// - Returns: 开头有填充的字符串
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex ..< string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex ..< padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }

    /// 通过填充返回一个字符串,以使长度参数大小与最后的另一个字符串相匹配
    ///
    ///   "hue".paddingEnd(10) -> "hue       "
    ///   "hue".paddingEnd(10, with: "br") -> "huebrbrbrb"
    /// - Parameters:
    ///   - length: 要填充的目标长度
    ///   - string: 填充字符串. 默认为`“ ”`
    /// - Returns: 末尾有填充的字符串
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex ..< string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex ..< padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    /// 从字符串中删除给定的前缀
    ///
    ///   "Hello, World!".removingPrefix("Hello, ") -> "World!"
    /// - Parameters prefix: 要从字符串中删除的前缀
    /// - Returns: 去除前缀后的字符串
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// 从字符串中删除给定的后缀
    ///
    ///   "Hello, World!".removingSuffix(", World!") -> "Hello"
    /// - Parameters suffix: 要从字符串中删除的后缀
    /// - Returns: 删除后缀后的字符串
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// 为字符串添加前缀
    ///
    ///     "www.apple.com".withPrefix("https://") -> "https://www.apple.com"
    /// - Parameters prefix: 添加到字符串的前缀
    /// - Returns: 带有前缀的字符串
    func withPrefix(_ prefix: String) -> String {
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }

    /// 子字符串最后一次出现的位置
    /// - Parameter sub: 子字符串
    /// - Returns: 返回字符串的位置(如果内部不存在该字符串则返回 -1)
    func positionFirst(of sub: String) -> Int {
        return position(of: sub)
    }

    /// 子字符串第一次出现的位置
    /// - Parameter sub: 子字符串
    /// - Returns: 返回字符串的位置(如果内部不存在该字符串则返回 -1)
    func positionLast(of sub: String) -> Int {
        return position(of: sub, backwards: true)
    }

    /// 返回(第一次/最后一次)出现的指定子字符串在此字符串中的索引,如果内部不存在该字符串则返回 -1
    /// - Parameters:
    ///   - sub: 子字符串
    ///   - backwards: 如果backwards参数设置为true,则返回最后出现的位置
    /// - Returns: 位置
    func position(of sub: String, backwards: Bool = false) -> Int {
        var pos = -1
        if let range = range(of: sub, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                pos = distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }

    /// 截取子字符串(从from开始到字符串结尾)
    /// - Parameter from: 开始位置
    /// - Returns: 子字符串
    func subString(from: Int) -> String {
        let end = count
        return self[from ..< end]
    }

    /// 截取子字符串(从开头到to)
    /// - Parameter to: 停止位置
    /// - Returns: 子字符串
    func subString(to: Int) -> String {
        return self[0 ..< to]
    }

    /// 截取子字符串(从from开始截取length个字符)
    /// - Parameters:
    ///   - from: 开始截取位置
    ///   - length: 长度
    /// - Returns: 子字符串
    func subString(from: Int, length: Int) -> String {
        let end = from + length
        return self[from ..< end]
    }

    /// 截取子字符串(从from开始截取到to)
    /// - Parameters:
    ///   - from: 开始位置
    ///   - to: 结束位置
    /// - Returns: 子字符串
    func subString(from: Int, to: Int) -> String {
        return self[from ..< to]
    }

    /// 根据`NSRange`截取子字符串
    /// - Parameter range: `NSRange`
    /// - Returns: 子字符串
    func subString(range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }

    /// 根据`Range`截取子字符串
    /// - Parameter range: `Range<Int>`
    /// - Returns: 子字符串
    func subString(range: Range<Int>) -> String {
        return self[range]
    }

    /// 根据`Range`截取子字符串
    /// - Parameter range: `Range<String.Index>`
    /// - Returns: 子字符串
    func subString(range: Range<String.Index>) -> String {
        let subString = self[range]
        return String(subString)
    }

    /// 获取某个位置的字符串
    /// - Parameter index: 位置
    /// - Returns: 某个位置的字符串
    func indexString(index: Int) -> String {
        return slice(index ..< index + 1)
    }

    /// 切割字符串(区间范围 前闭后开)
    ///     CountableClosedRange：可数的闭区间,如 0...2
    ///     CountableRange：可数的开区间,如 0..<2
    ///     ClosedRange：不可数的闭区间,如 0.1...2.1
    ///     Range：不可数的开居间,如 0.1..<2.1
    /// - Parameter range: 范围
    /// - Returns: 切割后的字符串
    func slice(_ range: CountableRange<Int>) -> String {
        // 如 slice(2..<6)
        /// upperBound(上界)
        /// lowerBound(下界)
        let startIndex = validIndex(original: range.lowerBound)
        let endIndex = validIndex(original: range.upperBound)
        guard startIndex < endIndex else {
            return ""
        }
        return String(self[startIndex ..< endIndex])
    }

    /// 在任意位置插入字符串
    /// - Parameters:
    ///   - content: 插入内容
    ///   - locat: 插入的位置
    /// - Returns: 添加后的字符串
    func insertString(content: String, locat: Int) -> String {
        guard locat < count else {
            return self
        }
        let str1 = subString(to: locat)
        let str2 = subString(from: locat + 1)
        return str1 + content + str2
    }

    /// 替换字符串
    /// - Parameters:
    ///   - string: 要替换的字符串
    ///   - withString: 要替换成的字符串
    /// - Returns: 替换完成的字符串
    func replace(_ string: String, with withString: String) -> String {
        return replacingOccurrences(of: string, with: withString)
    }

    /// 隐藏敏感信息
    /// - Parameters:
    ///   - range: 要隐藏的内容范围
    ///   - replace: 用来替换敏感内容的字符串
    /// - Returns: 隐藏敏感信息后的字符串
    func HideSensitiveContent(range: Range<Int>, replace: String = "****") -> String {
        if count < range.upperBound {
            return self
        }
        guard let subStr = self[safe: range] else {
            return self
        }
        return self.replace(subStr, with: replace)
    }

    /// 重复字符串
    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }

    /// 校验字符串位置是否合理,并返回String.Index
    /// - Parameter original: 位置
    /// - Returns: String.Index
    func validIndex(original: Int) -> String.Index {
        switch original {
        case ...startIndex.utf16Offset(in: self):
            return startIndex
        case endIndex.utf16Offset(in: self)...:
            return endIndex
        default:
            return index(startIndex, offsetBy: original)
        }
    }

    /// 某个字符使用某个字符替换掉
    /// - Parameters:
    ///   - removeString: 原始字符
    ///   - replacingString: 替换后的字符
    /// - Returns: 替换后的整体字符串
    func removeSomeStringUseSomeString(removeString: String, replacingString: String = "") -> String {
        return replacingOccurrences(of: removeString, with: replacingString)
    }

    /// 使用正则表达式替换
    /// - Parameters:
    ///   - pattern: 正则
    ///   - with: 用来替换的字符串
    ///   - options: 策略
    /// - Returns: 返回替换后的字符串
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String
    {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSRange(location: 0, length: count),
                                              withTemplate: with)
    }

    /// 删除指定的字符
    /// - Parameter characterString: 指定的字符
    /// - Returns: 返回删除后的字符
    func removeCharacter(characterString: String) -> String {
        let characterSet = CharacterSet(charactersIn: characterString)
        return trimmingCharacters(in: characterSet)
    }
}

// MARK: - HTML字符引用
public extension String {
    /// 字符串转为HTML字符引用
    /// - Returns: 字符引用
    func stringAsHtmlCharacterEntityReferences() -> String {
        var result = ""
        for scalar in utf16 {
            // 将十进制转成十六进制,不足4位前面补0
            let tem = String().appendingFormat("%04x", scalar)
            result += "&#x\(tem);"
        }
        return result
    }

    /// HTML字符引用转字符串
    /// - Returns: 普通字符串
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
    /// HTML源码转属性字符串
    /// - Parameters:
    ///   - font: 字体
    ///   - lineSpacing: 行间距
    /// - Returns: 属性字符串
    func htmlCodeAsAttributedString(
        font: UIFont? = UIFont.systemFont(ofSize: 16),
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
    ///   - keyword: 要高亮的关键词
    ///   - keywordCololor: 关键高亮字颜色
    ///   - otherColor: 非高亮文字颜色
    ///   - options: 匹配选项
    /// - Returns: 返回匹配后的属性字符串
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
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: otherColor], range: fullString.fullNSRange)

        // 与关键词匹配的range数组
        let ranges = fullString.matchRange(keyword)

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
    ///   - maxWidth: 最大宽度
    ///   - font: 文字字体
    /// - Returns: 返回计算好的size
    func textSize(
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
    ///   - maxWidth: 最大宽度
    ///   - font: 字体
    ///   - lineSpaceing: 行间距
    ///   - wordSpacing: 字间距
    /// - Returns: size
    func attributedSize(
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
    ///        "SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
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

// --------------------------------------
// Binary：      二进制
// Octal：       八进制
// Decimal：     十进制
// Hexadecimal： 十六进制
// --------------------------------------

// MARK: - 进制转换
public extension ExpressibleByStringLiteral {
    /// 二进制转八进制
    var binaryAsOctal: String {
        // 二进制
        let binary = self
        // 十进制
        let decimal = binary.binaryAsDecimal
        // 八进制
        return decimal.binaryAsDecimal
    }

    /// 二进制转十进制
    var binaryAsDecimal: String {
        let binary = self as! String
        var sum = 0
        for c in binary {
            let number = "\(c)".int
            sum = sum * 2 + number
        }
        return "\(sum)"
    }

    /// 二进制转十六进制
    var binaryAsHexadecimal: String {
        // 二进制
        let binary = self
        // 十进制
        let decimal = binary.binaryAsDecimal
        // 十六进制
        return decimal.decimalAsHexadecimal
    }

    /// 八进制转二进制
    var octalAsBinary: String {
        // 八进制
        let octal = self
        // 十进制
        let decimal = octal.octalAsDecimal
        // 二进制
        return decimal.decimalAsBinary
    }

    /// 八进制转十进制
    var octalAsDecimal: String {
        let binary = self as! String
        var sum = 0
        for c in binary {
            let number = "\(c)".int
            sum = sum * 8 + number
        }
        return "\(sum)"
    }

    /// 八进制转十六进制
    var octalToHexadecimal: String {
        // 八进制
        let octal = self as! String
        // 十进制
        let decimal = octal.octalAsDecimal
        // 十六进制
        return decimal.decimalAsHexadecimal
    }

    /// 十进制转二进制
    var decimalAsBinary: String {
        var decimal = (self as! String).int
        var str = ""
        while decimal > 0 {
            str = "\(decimal % 2)" + str
            decimal /= 2
        }
        return str
    }

    /// 十进制转八进制
    var decimalAsOctal: String {
        let decimal = (self as! String).int
        return String(format: "%0O", decimal)
    }

    /// 十进制转十六进制
    var decimalAsHexadecimal: String {
        let decimal = (self as! String).int
        return String(format: "%0X", decimal)
    }

    /// 十六进制转二进制
    var hexadecimalAsBinary: String {
        // 十六进制
        let hexadecimal = self
        // 十进制
        let decimal = hexadecimal.hexadecimalAsDecimal
        // 二进制
        return decimal.decimalAsBinary
    }

    /// 十六进制转八进制
    var hexadecimalAsOctal: String {
        // 十六进制
        let hexadecimal = self
        // 十进制
        let decimal = hexadecimal.hexadecimalAsDecimal
        // 八进制
        return decimal.decimalAsOctal
    }

    /// 十六进制转十进制
    var hexadecimalAsDecimal: String {
        let str = (self as! String).uppercased()
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

// MARK: - `NSDecimalNumber`苹果针对浮点类型计算精度问题提供出来的计算类
public extension String {
    /// ＋ 加法运算
    /// - Parameter strNumber: strNumber description
    /// - Returns: description
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

    /// － 减法运算
    /// - Parameter strNumber: strNumber description
    /// - Returns: description
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

    /// x 乘法运算
    /// - Parameter strNumber: strNumber description
    /// - Returns: description
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

    /// / 除法运算
    /// - Parameter strNumber: strNumber description
    /// - Returns: description
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

// MARK: - 运算符
public extension String {
    /// 重载 Swift 的“包含”运算符以匹配正则表达式模式
    /// - Parameters:
    ///   - lhs: 检查正则表达式模式的字符串
    ///   - rhs: 要匹配的正则表达式模式
    /// - Returns: 如果字符串与模式匹配,则返回 true
    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression) != nil
    }

    /// 重载 Swift 的“包含”运算符以匹配正则表达式
    /// - Parameters:
    ///   - lhs: 检查正则表达式的字符串
    ///   - rhs: 要匹配的正则表达式
    /// - Returns: 如果字符串中的正则表达式至少有一个匹配项,则返回：`true`
    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let range = NSRange(lhs.startIndex ..< lhs.endIndex, in: lhs)
        return rhs.firstMatch(in: lhs, range: range) != nil
    }

    /// 生成重复字符串
    ///
    ///        'bar' * 3 -> "barbarbar"
    /// - Parameters:
    ///   - lhs: 要重复的字符串
    ///   - rhs: 重复字符串的次数
    /// - Returns: 给定字符串重复 n 次的新字符串
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// 多次重复字符串
    ///
    ///        3 * 'bar' -> "barbarbar"
    /// - Parameters:
    ///   - lhs: 重复字符的次数
    ///   - rhs: 要重复的字符串
    /// - Returns: 给定字符串重复 n 次的新字符串
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}

// MARK: - 数字字符串
public extension String {
    /// 金额字符串转化为带逗号的金额, 按照千分位表示
    /// "1234567" => 1,234,567
    /// "1234567.56" => 1,234,567.56
    /// - Returns: 千分位表示字符串
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
    /// - Returns: 删除小数点后多余0的数字字符串
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
    ///   - numberDecimal: 保留几位小数
    ///   - mode: 模式
    /// - Returns: 返回保留后的小数(非数字字符串,返回0或0.0)
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
    return lhs.regexp(rhs)
}

// MARK: - 正则
public extension String {
    /// 正则校验
    func regexp(_ pattern: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

    /// 返回指定表达式的值
    /// - Parameters:
    ///   - pattern: 正则表达式
    ///   - count: 匹配数量
    func regexpText(_ pattern: String, count: Int = 1) -> [String]? {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
        else {
            return nil
        }
        var texts = [String]()
        for idx in 1 ... count {
            let text = (self as NSString).substring(with: result.range(at: idx))
            texts.append(text)
        }
        return texts
    }

    /// 是否有与正则匹配的项
    /// - Parameter pattern: 正则表达式
    /// - Returns: 是否匹配
    func isMatchRegexp(_ pattern: String) -> Bool {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let result = regx.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: utf16.count))
        return (!result.isEmpty)
    }

    /// 获取匹配的Range
    /// - Parameters:
    ///   - pattern: 匹配规则
    /// - Returns: 返回匹配的[NSRange]结果
    func matchRange(_ pattern: String) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return []
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
        guard !matches.isEmpty else {
            return []
        }
        return matches.map { value in
            value.range
        }
    }

    /// 利用正则表达式判断是否是手机号码
    var isTelNumber: Bool {
        let pattern = "^1[3456789]\\d{9}$"
        return regexp(pattern)
    }

    /// 是否是字母数字(指定范围)
    func isAlphanueric(minLen: Int, maxLen: Int) -> Bool {
        let pattern = "^[0-9a-zA-Z_]{\(minLen),\(maxLen)}$"
        return regexp(pattern)
    }

    /// 是否是字母与数字
    var isAlphanueric: Bool {
        let pattern = "^[A-Za-z0-9]+$"
        return isMatchRegexp(pattern)
    }

    /// 是否是纯汉字
    var isChinese: Bool {
        let pattern = "(^[\u{4e00}-\u{9fef}]+$)"
        return regexp(pattern)
    }

    var isEmail: Bool {
        //        let pattern = "^([a-z0-9A-Z]+[-_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$"
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        return regexp(pattern)
    }

    /// 是否是有效昵称,即允许“中文”、“英文”、“数字”
    var isValidNickName: Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return regexp(rgex)
    }

    /// 是否为合法用户名
    var validateUserName: Bool {
        let rgex = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        return regexp(rgex)
    }

    /// 设置密码必须符合由数字,大写字母,小写字母,特殊符
    /// - Parameter complex: 是否复杂密码 至少其中(两种/三种)组成密码
    func password(_ complex: Bool = false) -> Bool {
        var pattern = "^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{8,20}$"
        if complex {
            pattern = "^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{8,20}$"
        }
        return regexp(pattern)
    }

    /// 是否为0-9之间的数字(字符串的组成是：0-9之间的数字)
    /// - Returns: 返回结果
    func isValidNumberValue() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d]*$"
        return regexp(rgex)
    }

    /// 是否为数字或者小数点(字符串的组成是：0-9之间的数字或者小数点即可)
    /// - Returns: 返回结果
    func isValidNumberAndDecimalPoint() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d.]*$"
        return regexp(rgex)
    }

    /// 正则匹配用户身份证号15或18位
    var isIDNumber: Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        return regexp(pattern)
    }

    /// 严格判断是否有效的身份证号码,检验了省份,生日,校验位,不过没检查市县的编码
    var isValidIDNumber: Bool {
        let str = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.isIDNumber {
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

    /// 从字符串中提取链接和文本
    var hrefText: (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\"(.*?)>(.*?)</a>"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count))
        else {
            return nil
        }
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 3))
        return (link, text)
    }

    /// 返回当前字符窜中的 link range数组
    var linkRanges: [NSRange]? {
        // url, ##, 中文字母数字
        let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
        // 遍历数组,生成range的数组
        var ranges = [NSRange]()

        for pattern in patterns {
            guard let regx = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
                return nil
            }
            let matches = regx.matches(in: self, options: [], range: NSRange(location: 0, length: count))
            for m in matches {
                ranges.append(m.range(at: 0))
            }
        }
        return ranges
    }
}

// MARK: - 私有
public extension String {
    /// 是否是闰年
    /// - Parameter year: 年份
    /// - Returns: 返回是否是闰年
    private func isLeapYear(year: Int) -> Bool {
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

// MARK: - URL编解码(属性)
public extension String {
    /// 编码URL字符串(URL转义字符串)
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    /// 把编码过的URL字符串解码成可读格式(URL字符串解码)
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
}

// MARK: - base64(属性)
public extension String {
    /// Base64 编解码
    /// - Parameter encode: true:编码 false:解码
    /// - Returns: 编解码结果
    func base64String(encode: Bool) -> String? {
        if encode {
            return base64Encoded
        } else {
            return base64Decoded
        }
    }

    /// base64加密
    ///
    ///        "Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }

    /// base64解密
    ///
    ///        "SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
    ///
    var base64Decoded: String? {
        if let data = Data(base64Encoded: self,
                           options: .ignoreUnknownCharacters)
        {
            return String(data: data, encoding: .utf8)
        }

        let remainder = count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: self + padding,
                              options: .ignoreUnknownCharacters) else { return nil }

        return String(data: data, encoding: .utf8)
    }
}

// MARK: - unicode编码和解码
public extension String {
    /// Unicode编码
    /// - Returns: unicode编码后的字符串
    func unicodeEncode() -> String {
        var tempStr = String()
        for v in utf16 {
            if v < 128 {
                tempStr.append(Unicode.Scalar(v)!.escaped(asASCII: true))
                continue
            }
            let codeStr = String(v, radix: 16, uppercase: false)
            tempStr.append("\\u" + codeStr)
        }

        return tempStr
    }

    /// Unicode解码
    /// - Returns: unicode解码后的字符串
    func unicodeDecode() -> String {
        let tempStr1 = replacingOccurrences(of: "\\u", with: "\\U")
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
