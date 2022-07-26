import Foundation

// MARK: - Dictionary
public extension Dictionary {
    /// 字典JSON格式的Data
    /// - Parameters prettify: 是否美化格式
    /// - Returns: JSON格式的Data(可选类型)
    func data(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options: JSONSerialization.WritingOptions = (prettify == true) ? .prettyPrinted : .init()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }

    /// 字典转成JSON字符串
    /// - Parameters prettify: 是否美化格式
    /// - Returns: JSON字符串(可选类型)
    func string(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options: JSONSerialization.WritingOptions = (prettify == true) ? .prettyPrinted : .init()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }

        return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive, range: nil)
    }
}
