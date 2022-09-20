import UIKit

// MARK: - 包装类型
public class SaberExt<Base> {
    let base: Base
    init(_ base: Base) { self.base = base }
}

// MARK: - SaberExt方法
public extension SaberExt {
    func rawBase() -> Base.Type { Base.self }
    func rawbase() -> Base { base }
    static func rawBase() -> Base.Type { Base.self }
}

// MARK: - .sb.扩展协议
public protocol Saberable {}
public extension Saberable {
    var sb: SaberExt<Self> { SaberExt(self) }
    static var sb: SaberExt<Self>.Type { SaberExt<Self>.self }
}
