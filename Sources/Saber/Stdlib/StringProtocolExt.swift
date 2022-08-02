import Foundation

    // MARK: - 方法
public extension StringProtocol {
        /// 获取最长相同后缀
        ///   `"Hello world!".commonSuffix(with: "It's cold!") = "ld!"`
        /// - Parameters:
        ///     - Parameter aString: 用于比较的字符串
        ///     - Parameter options: 比较的选项
        /// - Returns: 相同后缀
    func commonSuffix<T: StringProtocol>(with aString: T, options: String.CompareOptions = []) -> String {
        return String(zip(reversed(), aString.reversed())
                        .lazy
                        .prefix(while: { (lhs: Character, rhs: Character) in
            String(lhs).compare(String(rhs), options: options) == .orderedSame
        })
                        .map { (lhs: Character, rhs: Character) in lhs }
                        .reversed())
    }
    
        /// 在`self`中与`pattern`(正则表达式)匹配的内容使用`template`替换
        /// - Parameters:
        ///   - pattern: 正则表达式
        ///   - template: 替换正则表达式的模板
        ///   - options: 匹配正则表达式时使用的选项
        ///   - searchRange: 要搜索的范围
        /// - Returns: 替换之后的新字符串
    func replacingOccurrences<Target, Replacement>(
        ofPattern pattern: Target,
        withTemplate template: Replacement,
        options: String.CompareOptions = [.regularExpression],
        range searchRange: Range<Self.Index>? = nil
    ) -> String where Target: StringProtocol,
                      Replacement: StringProtocol
    {
    assert(
        options.isStrictSubset(of: [.regularExpression, .anchored, .caseInsensitive]),
        "Invalid options for regular expression replacement"
    )
    return replacingOccurrences(
        of: pattern,
        with: template,
        options: options.union(.regularExpression),
        range: searchRange
    )
    }
}
