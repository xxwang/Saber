import Foundation

// MARK: - 方法
public extension NSRegularExpression {
    /// 枚举遍历匹配的每个结果,并且为每个结果执行block
    /// - Parameters:
    ///   - string: 用于匹配的字符串
    ///   - options: 要使用的匹配选项.请参阅`NSRegularExpression.MatchingOptions`
    ///   - range: 要搜索的字符串的范围
    ///   - block: 要执行的代码块
    ///   /*
    ///          - result: `NSTextCheckingResult`
    ///          - flags: `NSRegularExpression.MatchingFlags`
    ///          - stop: `stop = true`的时候,结束枚举遍历
    ///   */
    func enumerateMatches(in string: String,
                          options: MatchingOptions = [],
                          range: Range<String.Index>,
                          using block: (_ result: NSTextCheckingResult?, _ flags: MatchingFlags, _ stop: inout Bool)
                              -> Void)
    {
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

    /// 返回一个数组,其中包含字符串中正则表达式的所有匹配项
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 要使用的匹配选项.请参阅`NSRegularExpression.MatchingOptions`
    ///   - range: 要搜索的字符串的范围
    /// - Returns: `NSTextCheckingResult`对象数组.每个结果通过其“`range`”属性给出整体匹配范围,并通过其“`range(at: )`”方法给出每个单独捕获组的范围.如果其中一个捕获组未参与此特定匹配,则返回范围`{NSNotFound,0}`
    func matches(in string: String,
                 options: MatchingOptions = [],
                 range: Range<String.Index>) -> [NSTextCheckingResult]
    {
        return matches(in: string,
                       options: options,
                       range: NSRange(range, in: string))
    }

    /// 返回字符串指定范围内正则表达式的匹配数
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 要使用的匹配选项.请参阅`NSRegularExpression.MatchingOptions`
    ///   - range: 要搜索的字符串的范围
    /// - Returns: 正则表达式的匹配数
    func numberOfMatches(in string: String,
                         options: MatchingOptions = [],
                         range: Range<String.Index>) -> Int
    {
        return numberOfMatches(in: string,
                               options: options,
                               range: NSRange(range, in: string))
    }

    /// 返回字符串指定范围内正则表达式的第一个匹配项
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 要使用的匹配选项.请参阅`NSRegularExpression.MatchingOptions`
    ///   - range: 要搜索的字符串的范围
    /// - Returns: 一个'`NSTextCheckingResult`'对象.该结果通过其“`range`”属性给出整体匹配范围,并通过其“`range(at: )`”方法给出每个单独捕获组的范围.如果其中一个捕获组未参与此特定匹配,则返回范围`{NSNotFound,0}`
    func firstMatch(in string: String,
                    options: MatchingOptions = [],
                    range: Range<String.Index>) -> NSTextCheckingResult?
    {
        return firstMatch(in: string,
                          options: options,
                          range: NSRange(range, in: string))
    }

    /// 返回正则表达式在指定字符串范围内的第一个匹配项的范围
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 要使用的匹配选项.请参阅`NSRegularExpression.MatchingOptions`
    ///   - range: 要搜索的字符串的范围
    /// - Returns: 第一个匹配的范围.如果未找到匹配项,则返回`nil`
    func rangeOfFirstMatch(in string: String,
                           options: MatchingOptions = [],
                           range: Range<String.Index>) -> Range<String.Index>?
    {
        return Range(rangeOfFirstMatch(in: string,
                                       options: options,
                                       range: NSRange(range, in: string)),
                     in: string)
    }

    /// 返回一个新字符串,其中包含替换为模板字符串的匹配正则表达式
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 要使用的匹配选项.请参阅`NSRegularExpression.MatchingOptions`
    ///   - range: 要搜索的字符串的范围
    ///   - templ: 替换匹配实例时使用的替换模板
    /// - Returns: 一个字符串,其中匹配的正则表达式被模板字符串替换
    func stringByReplacingMatches(in string: String,
                                  options: MatchingOptions = [],
                                  range: Range<String.Index>,
                                  withTemplate templ: String) -> String
    {
        return stringByReplacingMatches(in: string,
                                        options: options,
                                        range: NSRange(range, in: string),
                                        withTemplate: templ)
    }

    /// 使用模板字符串替换可变字符串中的正则表达式匹配项
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 要使用的匹配选项.请参阅`NSRegularExpression.MatchingOptions`
    ///   - range: 要搜索的字符串的范围
    ///   - templ: 替换匹配实例时使用的替换模板
    /// - Returns: 匹配的数量
    @discardableResult
    func replaceMatches(in string: inout String,
                        options: MatchingOptions = [],
                        range: Range<String.Index>,
                        withTemplate templ: String) -> Int
    {
        let mutableString = NSMutableString(string: string)
        let matches = replaceMatches(in: mutableString,
                                     options: options,
                                     range: NSRange(range, in: string),
                                     withTemplate: templ)
        string = mutableString.copy() as! String
        return matches
    }
}
