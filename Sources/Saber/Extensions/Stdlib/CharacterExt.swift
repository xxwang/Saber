import Foundation

// MARK: - 属性
public extension Character {
    /// `Character`转`Int`
    var int: Int {
        var intValue = 0
        for scalar in String(self).unicodeScalars {
            intValue = Int(scalar.value)
        }
        return intValue
    }

    /// `Character`转`String`
    var string: String {
        return String(self)
    }
}

// MARK: - Emoji
public extension Character {
    /// 简单的`emoji`是一个`标量`，以`emoji`的形式呈现给用户
    private var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        return unicodeScalars.count > 1 && (firstProperties.isEmojiPresentation || firstProperties.generalCategory == .otherSymbol)
    }

    /// 检查`标量`是否将合并到`emoji`中
    private var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 &&
            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    /// 是否是表情字符
    /// - Note:http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji: Bool {
        isSimpleEmoji || isCombinedIntoEmoji
    }
}

// MARK: - 静态属性
public extension Character {
    /// 随机产生一个字符`(a-z A-Z 0-9)`
    static var random: Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}

// MARK: - 方法
public extension Character {
    /// 转换成小写字符
    func lowercase() -> Character {
        return String(self).lowercased().first!
    }

    /// 转换成大写字符
    func uppercase() -> Character {
        return String(self).uppercased().first!
    }

    /// 生成重复`字符`字符串
    /// - Parameter count:字符个数
    /// - Returns:字符串
    func `repeat`(_ count: Int) -> String {
        return self * count
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
