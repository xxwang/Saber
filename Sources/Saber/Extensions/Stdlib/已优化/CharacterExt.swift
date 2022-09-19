import Foundation

// MARK: - 属性
public extension SaberExt where Base == Character {
    /// Character转Int
    var intValue: Int {
        var intValue = 0
        for scalar in String(self.base).unicodeScalars {
            intValue = Int(scalar.value)
        }
        return intValue
    }

    /// Character转String
    var stringValue: String {
        return String(self.base)
    }

    /// 转换成小写字符
    var lowercase: Character {
        return String(self.base).lowercased().first!
    }

    /// 转换成大写字符
    var uppercase: Character {
        return String(self.base).uppercased().first!
    }
}

// MARK: - emoji
public extension SaberExt where Base == Character {
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    private var isSimpleEmoji: Bool {
        guard let firstProperties = self.base.unicodeScalars.first?.properties else {
            return false
        }
        return self.base.unicodeScalars.count > 1 && (firstProperties.isEmojiPresentation || firstProperties.generalCategory == .otherSymbol)
    }

    /// 检查标量是否将合并到emoji中
    private var isCombinedIntoEmoji: Bool {
        return self.base.unicodeScalars.count > 1 &&
            self.base.unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    /// 是否为emoji表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji: Bool {
        isSimpleEmoji || isCombinedIntoEmoji
    }
}

// MARK: - 静态属性
public extension SaberExt where Base == Character {
    /// 产生随机一个字符(a-z A-Z 0-9)
    static var random: Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}

// MARK: - 方法
public extension SaberExt where Base == Character {
    /// 生成指定数量重复字符的字符串
    /// - Parameter count: 字符个数
    /// - Returns: 字符串
    func `repeat`(_ count: Int) -> String {
        return self.base * count
    }
}

// MARK: - 运算符重载
public extension Character {
    /// 生成重复字符字符串
    /// `Character("-") * 10 -> "----------"`
    /// - Parameters:
    ///   - lhs: 要重复的字符
    ///   - rhs: 字符重复数量
    /// - Returns: 字符串
    static func * (lhs: Character, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: String(lhs), count: rhs)
    }

    /// 生成重复字符字符串
    /// `10 * Character("-") -> "----------"`
    /// - Parameters:
    ///   - lhs: 字符重复数量
    ///   - rhs: 要重复的字符
    /// - Returns: 字符串
    static func * (lhs: Int, rhs: Character) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: String(rhs), count: lhs)
    }
}
