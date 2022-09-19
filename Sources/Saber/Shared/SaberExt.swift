import UIKit

// MARK: - 调用对象实体包装类型
public class SaberExt<Base> {
    let base: Base
    init(_ base: Base) { self.base = base }
}

public extension SaberExt {
    /// 获取原始数据
    func baseValue() -> Base { self.base }
    /// 获取原始数据的类型
    func BaseValue() -> Base.Type { return Base.self }
    /// 获取原始数据的类型
    static func BaseValue() -> Base.Type { return Base.self }
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
