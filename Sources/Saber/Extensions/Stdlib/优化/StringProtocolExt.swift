import Foundation

// MARK: - 方法
public extension StringProtocol {

    /// 获取最长相同后缀
    /// - Parameters:
    ///   - aString: 用于与self比较的对象
    ///   - options: 选项
    /// - Returns: 最长相同后缀
    func commonSuffix<T: StringProtocol>(with aString: T, options: String.CompareOptions = []) -> String {
        return String(zip(reversed(), aString.reversed())
            .lazy
            .prefix(while: { (lhs: Character, rhs: Character) in
                String(lhs).compare(String(rhs), options: options) == .orderedSame
            })
            .map { (lhs: Character, _: Character) in lhs }
            .reversed())
    }
}
