
// MARK: - 方法
public extension Character {
    /// `Character`转`Int`
    func as_int() -> Int {
        var intValue = 0
        for scalar in String(self).unicodeScalars {
            intValue = Int(scalar.value)
        }
        return intValue
    }

    /// `Character`转`String`
    func as_string() -> String {
        return String(self)
    }

    /// 转换成小写字符
    func as_lowercase() -> Character {
        return String(self).lowercased().first!
    }

    /// 转换成大写字符
    func as_uppercase() -> Character {
        return String(self).uppercased().first!
    }

    /// 生成重复`字符`字符串
    /// - Parameter count:字符个数
    /// - Returns:字符串
    func `repeat`(_ count: Int) -> String {
        return self * count
    }
}

// MARK: - 静态方法
public extension Character {
    /// 随机产生一个字符`(a-z A-Z 0-9)`
    /// - Returns: 随机`Character`
    static func random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
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
