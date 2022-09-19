import UIKit

// MARK: - 调用对象实体包装类型
public class SaberExt<Base> {
    let base: Base
    init(_ base: Base) { self.base = base }
}

public extension SaberExt {
    /// 获取原始数据
    func unpack() -> Base { self.base }
    func untype() -> Base.Type { return Base.self }
    static func untype1() -> Base.Type { return Base.self }
}

// MARK: - 需要使用的类型遵守此协议
public protocol Saberable {}
public extension Saberable {
    var sb: SaberExt<Self> { SaberExt(self) }
    static var sb: SaberExt<Self>.Type { SaberExt<Self>.self }
}

// MARK: - 已扩展.sb.属性的类
extension NSObject: Saberable {}
extension Bool: Saberable{}
extension Character: Saberable {}
