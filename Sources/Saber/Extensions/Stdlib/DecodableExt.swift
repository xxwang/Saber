import Foundation

// MARK: - 方法
public extension Decodable {
    /// 解码(遵守Decodable类型的Data)
    /// - Parameters:
    ///   - data: Data
    ///   - decoder: JSONDecoder
    /// - Returns: Base类型的对象
    static func decode(from data: Data, decoder: JSONDecoder = .init()) -> Self? {
        guard let result = try? decoder.decode(Self.self, from: data) else {
            return nil
        }
        return result
    }
}

// MARK: - Decodable
public extension Decodable {
    /// JSON String?转模型
    /// - Parameter string: JSON字符串
    /// - Returns: Self
    static func model(_ string: String?) -> Self? where Self: Decodable {
        guard let data = string?.data else {
            return nil
        }
        return model(data)
    }

    /// JSON Data?转模型
    /// - Parameter data: JSON Data
    /// - Returns: Self
    static func model(_ data: Data?) -> Self? where Self: Decodable {
        guard let data = data else {
            return nil
        }
        return decode(from: data)
    }

    /// [String: Any]? 转模型
    /// - Parameter jsonDictionary: JSON字典
    /// - Returns: SBMappable
    static func model(_ dict: [String: Any]?) -> Self? where Self: Decodable {
        guard let data = dict?.data() else {
            return nil
        }
        return decode(from: data)
    }

    /// [Any]? 转模型
    /// - Parameter jsonArray: JSON数组
    /// - Returns: SBMappable
    static func models(_ array: [Self]?) -> [Self]? where Self: Decodable {
        guard let data = array?.data() else {
            return nil
        }
        return [Self].decode(from: data)
    }
}
