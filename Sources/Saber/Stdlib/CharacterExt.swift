import Foundation

// MARK: - 属性
public extension Character {
    /// Int
    var int: Int {
        var intValue = 0
        for scalar in String(self).unicodeScalars {
            intValue = Int(scalar.value)
        }
        return intValue
    }

    /// String
    var string: String {
        return String(self)
    }

    /// 小写
    var lowercased: Character {
        return String(self).lowercased().first!
    }

    /// 大写
    var uppercased: Character {
        return String(self).uppercased().first!
    }

    /// 判断字符是否是Emoji表情
    var isEmoji: Bool {
        let scalarValue = String(self).unicodeScalars.first!.value
        switch scalarValue {
        case 0x1F600 ... 0x1F64F, // Emoticons
             0x1F300 ... 0x1F5FF, // Misc Symbols and Pictographs
             0x1F680 ... 0x1F6FF, // Transport and Map
             0x1F1E6 ... 0x1F1FF, // Regional country flags
             0x2600 ... 0x26FF, // Misc symbols
             0x2700 ... 0x27BF, // Dingbats
             0xE0020 ... 0xE007F, // Tags
             0xFE00 ... 0xFE0F, // Variation Selectors
             0x1F900 ... 0x1F9FF, // Supplemental Symbols and Pictographs
             127_000 ... 127_600, // Various asian characters
             65024 ... 65039, // Variation selector
             9100 ... 9300, // Misc items
             8400 ... 8447: // Combining Diacritical Marks for Symbols
            return true
        default:
            return false
        }
    }
}

// MARK: - 静态属性
public extension Character {
    /// 产生随机字符(a-z A-Z 0-9)
    static var randomAlphanumeric: Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}

// MARK: - 运算符
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
