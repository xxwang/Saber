import Foundation

// MARK: - 基本数据类型
public extension SaberEx where Base: UserDefaults {
    /// 保存数据到`UserDefaults`中
    /// - Parameters:
    ///   - value: 要保存的数据
    ///   - key: 存取数据使用的`关键字`
    /// - Returns: 操作是否成功
    @discardableResult
    static func save(_ value: Any?, for key: String?) -> Bool {
        guard let value, let key else { return false }
        Base.standard.setValue(value, forKey: key)
        Base.standard.synchronize()
        return true
    }

    /// 根据`key`读取保存`UserDefaults`的数据
    /// - Parameter key: 存取数据使用的`关键字`
    /// - Returns: `Any?`
    @discardableResult
    static func fetch(for key: String?) -> Any? {
        guard let key else { return nil }
        return Base.standard.value(forKey: key)
    }

    /// 从`UserDefaults`中移除某个保存的值
    /// - Parameter key: 要移除数据对应的`关键字`
    /// - Returns: 是否成功
    @discardableResult
    static func remove(for key: String?) -> Bool {
        guard let key else { return false }
        Base.standard.removeObject(forKey: key)
        return true
    }

    /// 从`UserDefaults`中移除当前应用存储的所有数据
    /// - Returns: 是否成功
    @discardableResult
    static func clear() -> Bool {
        guard let bundleID = Bundle.sb.bundleIdentifier else {
            return false
        }
        Base.standard.removePersistentDomain(forName: bundleID)
        return true
    }
}

// MARK: - 模型持久化
public extension SaberEx where Base: UserDefaults {
    /// 保存遵守`Codable`协议的对象到`UserDefaults`
    /// - Parameters:
    ///   - object: 要存储的对象
    ///   - key: 存取数据使用的`关键字`
    ///   - encoder: 编码器
    /// - Returns: 操作是否成功
    @discardableResult
    static func saveObject<T: Codable>(
        _ object: T?,
        for key: String?,
        using encoder: JSONEncoder = JSONEncoder()
    ) -> Bool {
        guard let object,
              let key,
              let data = try? encoder.encode(object)
        else {
            return false
        }
        return save(data, for: key)
    }

    /// 从`UserDefaults`检索遵守`Codable`的对象
    /// - Parameters:
    ///   - type: 对象类型
    ///   - key: 存取数据使用的`关键字`
    ///   - decoder: 解码器
    /// - Returns: 遵守`Codable`的对象
    @discardableResult
    static func fetchObject<T: Codable>(
        _ type: T.Type,
        for key: String?,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> T? {
        guard let key,
              let data = fetch(for: key) as? Data
        else {
            return nil
        }
        return try? decoder.decode(type.self, from: data)
    }
}

// MARK: - 下标
public extension UserDefaults {
    /// 使用`下标`从`UserDefaults`存取数据
    /// - Parameter key: 对应`value`的`key`
    static subscript(key: String) -> Any? {
        get { return UserDefaults.sb.fetch(for: key) }
        set { UserDefaults.sb.save(newValue, for: key) }
    }
}
