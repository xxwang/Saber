import UIKit

extension Data: Saberable {}

// MARK: - 方法
public extension SaberEx where Base == Data {
    /// `Data`转`UIImage`
    /// - Returns: `UIImage?`
    func toImage() -> UIImage? {
        return UIImage(data: base)
    }

    /// 以字节数组的形式返回数据
    /// - Returns: `[UInt8]`
    func toBytes() -> [UInt8] {
        return [UInt8](base)
    }

    /// 将`Data`转为`指定编码的字符串`
    /// - Parameter encoding:编码格式
    /// - Returns:对应字符串
    func toString(encoding: String.Encoding = .utf8) -> String? {
        return String(data: base, encoding: encoding)
    }

    /// `Data`转`十六进制字符串`
    /// - Returns: `String`
    func toHexString() -> String {
        let result = base.withUnsafeBytes { rawPointer -> String in
            let unsafeBufferPointer = rawPointer.bindMemory(to: UInt8.self)
            let bytes = unsafeBufferPointer.baseAddress!
            let buffer = UnsafeBufferPointer(start: bytes, count: base.count)
            return buffer.map { String(format: "%02hhx", $0) }.reduce("") { $0 + $1 }.uppercased()
        }
        return result
    }

    /// `Data`转指定`Foundation`对象(`数组, 字典...`)
    /// - Parameters:
    ///   - name:要转换的目标类型`[String:Any].self`
    ///   - options:读取`JSON`数据和创建`Foundation`对象的选项
    /// - Returns:失败返回`nil`
    func toObject<T>(for name: T.Type = Any.self, options: JSONSerialization.ReadingOptions = []) -> T? {
        guard let obj = try? JSONSerialization.jsonObject(with: base, options: options) else {
            return nil
        }
        guard let classObj = obj as? T else {
            return nil
        }
        return classObj
    }

    /// 截取指定长度`Data`
    /// - Parameters:
    ///   - from:开始位置
    ///   - len:截取长度
    /// - Returns:截取的`Data`
    func subData(from: Int, len: Int) -> Data? {
        guard from >= 0, len >= 0 else { return nil }
        guard base.count >= from + len else { return nil }

        let startIndex = base.index(base.startIndex, offsetBy: from)
        let endIndex = base.index(base.startIndex, offsetBy: from + len)
        let range = startIndex ..< endIndex
        return base[range]
    }
}

// MARK: - base64
public extension SaberEx where Base == Data {
    /// `Data base64`编码
    /// - Returns: `Data?`
    func base64Encoded() -> Data? {
        return base.base64EncodedData()
    }

    /// `Data base64`解码
    /// - Returns: `Data?`
    func base64Decoded() -> Data? {
        return Data(base64Encoded: base)
    }
}
