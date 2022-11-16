import Foundation

// MARK: - 方法
public extension NSRegularExpression {
    /// 为每个符合`正则表达式`的匹配项执行`block`闭包
    /// - Parameters:
    ///   - string:用于匹配的字符串
    ///   - options:的匹配选项
    ///   - range:字符串的搜索范围
    ///   - block:要执行的代码块
    func enumerateMatches(
        in string: String,
        options: MatchingOptions = [],
        range: Range<String.Index>,
        using block: (_ result: NSTextCheckingResult?,
                      _ flags: MatchingFlags,
                      _ stop: inout Bool) -> Void
    ) {
        enumerateMatches(in: string,
                         options: options,
                         range: NSRange(range, in: string)) { result, flags, stop in
            var shouldStop = false
            block(result, flags, &shouldStop)
            if shouldStop {
                stop.pointee = true
            }
        }
    }

    /// 返回所有符合`正则表达式`的匹配项
    /// - Parameters:
    ///   - string:用于匹配的字符串
    ///   - options:匹配选项
    ///   - range:字符串的搜索范围
    /// - Returns:匹配项数组
    func matches(
        in string: String,
        options: MatchingOptions = [],
        range: Range<String.Index>
    ) -> [NSTextCheckingResult] {
        return matches(in: string,
                       options: options,
                       range: NSRange(range, in: string))
    }

    /// 获取指定范围内符合`正则表达式`的匹配项数量
    ///
    /// - Parameters:
    ///   - string:要搜索的字符串
    ///   - options:匹配选项
    ///   - range:字符串的搜索范围
    /// - Returns:正则表达式的匹配项数量
    func numberOfMatches(
        in string: String,
        options: MatchingOptions = [],
        range: Range<String.Index>
    ) -> Int {
        return numberOfMatches(in: string,
                               options: options,
                               range: NSRange(range, in: string))
    }

    /// 返回符合`正则表达式`的`第一个`匹配项
    /// - Parameters:
    ///   - string:要搜索的字符串
    ///   - options:匹配选项
    ///   - range:字符串的搜索范围
    /// - Returns:`NSTextCheckingResult`
    func firstMatch(
        in string: String,
        options: MatchingOptions = [],
        range: Range<String.Index>
    ) -> NSTextCheckingResult? {
        return firstMatch(in: string,
                          options: options,
                          range: NSRange(range, in: string))
    }

    /// 获取符合`正则表达式`的第一个匹配项的`Range`
    /// - Parameters:
    ///   - string:要搜索的字符串
    ///   - options:匹配选项
    ///   - range:字符串的搜索范围
    /// - Returns:`Range`
    func rangeOfFirstMatch(
        in string: String,
        options: MatchingOptions = [],
        range: Range<String.Index>
    ) -> Range<String.Index>? {
        return Range(rangeOfFirstMatch(in: string,
                                       options: options,
                                       range: NSRange(range, in: string)),
                     in: string)
    }

    /// 使用`templ`替换符合`正则表达式`的匹配项
    /// - Parameters:
    ///   - string:要搜索的字符串
    ///   - options:匹配选项
    ///   - range:字符串的搜索范围
    ///   - templ:要替换的字符串
    /// - Returns:替换后的字符串
    func stringByReplacingMatches(
        in string: String,
        options: MatchingOptions = [],
        range: Range<String.Index>,
        withTemplate templ: String
    ) -> String {
        return stringByReplacingMatches(in: string,
                                        options: options,
                                        range: NSRange(range, in: string),
                                        withTemplate: templ)
    }

    /// 使用`templ`替换符合`正则表达式`的匹配项,并返回匹配项数量
    /// - Parameters:
    ///   - string:要搜索的字符串
    ///   - options:匹配选项
    ///   - range:字符串的搜索范围
    ///   - templ:要替换的字符串
    /// - Returns:匹配项数量
    @discardableResult
    func replaceMatches(
        in string: inout String,
        options: MatchingOptions = [],
        range: Range<String.Index>,
        withTemplate templ: String
    ) -> Int {
        let mutableString = NSMutableString(string: string)
        let matches = replaceMatches(in: mutableString,
                                     options: options,
                                     range: NSRange(range, in: string),
                                     withTemplate: templ)
        string = mutableString.copy() as! String
        return matches
    }
}
