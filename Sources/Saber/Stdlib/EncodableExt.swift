import Foundation

// MARK: - Encodable
public extension Encodable {
    /// 编码(遵守Encodable的对象)
    /// - Parameter encoder: 编码器
    /// - Returns: Data
    func encode(encoder: JSONEncoder = .init()) -> Data? {
        let result = try? encoder.encode(self)
        return result
    }

    /// 转Data?
    /// - Returns: Data?
    func data() -> Data? {
        return encode()
    }

    /// 转JSON字符串
    /// - Returns: JSON字符串
    func string() -> String? {
        guard let jsonData = data() else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    /// 转[String: Any]
    /// - Returns: [String: Any]
    func object() -> [String: Any]? {
        guard let data = data(),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return nil
        }
        return dict
    }
}

// MARK: - Array<Encodable>
public extension Array where Element: Encodable {
    /// 数组转Data?
    /// - Returns: Data?
    func data() -> Data? {
        return string()?.data()
    }

    /// 数组转JSON字符串
    /// - Returns: JSON字符串
    func string() -> String? {
        var objects: [[String: Any]] = []
        for mappable in self {
            if let object = mappable.object() {
                objects.append(object)
            }
        }
        return objects.string(prettify: true)
    }
}
