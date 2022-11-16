import Foundation

// MARK: - 类型转换
public extension SaberExt where Base == Character {
    /// `Character`转`Int`
    /// - Returns: `Int`
    func toInt() -> Int {
        var intValue = 0
        for scalar in String(base).unicodeScalars {
            intValue = Int(scalar.value)
        }
        return intValue
    }

    /// `Character`转`String`
    /// - Returns: `String`
    func toString() -> String {
        return String(base)
    }
}

// MARK: - 方法
public extension SaberExt where Base == Character {
    /// 转换成小写字符
    /// - Returns: 小写`Character`
    func toLower() -> Character {
        return String(base).lowercased().first!
    }

    /// 转换成大写字符
    /// - Returns: 大写`Character`
    func toUpper() -> Character {
        return String(base).uppercased().first!
    }

    /// 生成重复`字符`字符串
    /// - Parameter count:字符个数
    /// - Returns:字符串
    func `repeat`(_ count: Int) -> String {
        return base * count
    }
}

// MARK: - 静态方法
public extension SaberExt where Base == Character {
    /// 随机产生一个字符`(a-z A-Z 0-9)`
    /// - Returns: 随机`Character`
    static func random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}

// MARK: - Emoji
public extension SaberExt where Base == Character {
    /// 简单的`emoji`是一个`标量`，以`emoji`的形式呈现给用户
    /// - Returns: `Bool`
    private func isSimpleEmoji() -> Bool {
        guard let firstProperties = base.unicodeScalars.first?.properties else {
            return false
        }

        return base.unicodeScalars.count > 1
            && (firstProperties.isEmojiPresentation
                || firstProperties.generalCategory == .otherSymbol)
    }

    /// 检查`标量`是否将合并到`emoji`中
    /// - Returns: `Bool`
    private func isCombinedIntoEmoji() -> Bool {
        return base.unicodeScalars.count > 1
            && base.unicodeScalars.contains {
                $0.properties.isJoinControl || $0.properties.isVariationSelector
            }
    }

    /// 是否是表情字符
    /// - Note:http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    /// - Returns: `Bool`
    func isEmoji() -> Bool {
        return isSimpleEmoji() || isCombinedIntoEmoji()
    }
}

// MARK: - 运算符重载
public extension Character {
    /// 生成重复字符字符串
    /// - Parameters:
    ///   - lhs:要重复的字符
    ///   - rhs:字符重复数量
    /// - Returns:字符串
    static func * (lhs: Character, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: String(lhs), count: rhs)
    }

    /// 生成重复字符字符串
    /// - Parameters:
    ///   - lhs:字符重复数量
    ///   - rhs:要重复的字符
    /// - Returns:字符串
    static func * (lhs: Int, rhs: Character) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: String(rhs), count: lhs)
    }
}
