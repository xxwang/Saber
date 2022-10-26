import Foundation

// MARK: - 下标
public extension UserDefaults {
    /// 使用下标从`UserDefaults`获取对象
    /// - Parameters:
    /// - key:输入当前用户的默认数据库
    subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

// MARK: - 基本数据类型
public extension UserDefaults {
    /// 保存数据到`UserDefaults`中
    /// - Parameters:
    ///   - value:要保存的值
    ///   - key:对应的键
    /// - Returns:是否成功
    @discardableResult
    static func setValue(value: Any?, for key: String?) -> Bool {
        guard let value = value,
              let key = key
        else {
            return false
        }

        standard.set(value, forKey: key)
        standard.synchronize()
        return true
    }

    /// 读取保存`UserDefaults`的数据
    /// - Parameter key:读取值所用的键
    /// - Returns:返回读取结果
    static func value(for key: String?) -> Any? {
        guard let key = key else {
            return nil
        }
        return standard.value(forKey: key)
    }

    /// 从`UserDefaults`中移除单个保存的值
    /// - Parameter key:要移除值对应的键
    /// - Returns:是否移除成功
    @discardableResult
    static func remove(for key: String?) -> Bool {
        guard let key = key else {
            return false
        }
        standard.removeObject(forKey: key)
        return true
    }

    /// 从`UserDefaults`中移除当前应用存储的所有值
    @discardableResult
    static func removeAll() -> Bool {
        guard let bundleID = Bundle.appBundleIdentifier else {
            return false
        }
        standard.removePersistentDomain(forName: bundleID)
        return true
    }
}

// MARK: - 模型持久化
public extension UserDefaults {
    /// 保存遵守`Codable`协议的对象到`UserDefaults`
    /// - Parameters:
    ///   - object:要存储的对象
    ///   - key:保存对象的键
    ///   - encoder:编码器
    /// - Returns:是否保存成功
    static func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) -> Bool {
        guard let data = try? encoder.encode(object) else {
            return false
        }
        setValue(value: data, for: key)
        standard.synchronize()
        return true
    }

    /// 从`UserDefaults`检索遵守`Codable`的对象
    /// - Parameters:
    ///   - type:对象类型
    ///   - key:存储对象的键
    ///   - decoder:解码器
    /// - Returns:遵守`Codable`的对象
    static func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = value(forKey: key) as? Data else {
            return nil
        }
        let result = try? decoder.decode(type.self, from: data)
        return result
    }
}
