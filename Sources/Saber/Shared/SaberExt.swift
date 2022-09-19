import UIKit

// MARK: - 调用对象实体包装类型
public class SaberExt<Base> {
    let base: Base
    init(_ base: Base) { self.base = base }
}

public extension SaberExt {
    /// 获取原始数据的类型
    func rawType() -> Base.Type { Base.self }
    /// 获取原始数据
    func rawValue() -> Base { self.base }
    /// 获取原始数据
    static func rawValue() -> Base.Type { Base.self }
}

// MARK: - 需要使用的类型遵守此协议
public protocol Saberable {}
public extension Saberable {
    var sb: SaberExt<Self> { SaberExt(self) }
    static var sb: SaberExt<Self>.Type { SaberExt<Self>.self }
}

// MARK: - 已扩展.sb.属性的类
extension Int: Saberable {}
extension Int8: Saberable {}
extension Int16: Saberable {}
extension Int32: Saberable {}
extension Int64: Saberable {}

extension Bool: Saberable {}
extension Character: Saberable {}

extension NSObject: Saberable {}

