import UIKit

// MARK: - SaberExt
public class SaberExt<Base> {
    var base: Base
    init(_ base: Base) { self.base = base }
}

// MARK: - SaberExt方法
public extension SaberExt {
    func rawBase() -> Base.Type { Base.self }
    func rawbase() -> Base { base }
    static func rawBase() -> Base.Type { Base.self }
}

// MARK: - Saberable
public protocol Saberable {}

// MARK: - Saberable属性
public extension Saberable {
    var sb: SaberExt<Self> { SaberExt(self) }
    static var sb: SaberExt<Self>.Type { SaberExt<Self>.self }
}
