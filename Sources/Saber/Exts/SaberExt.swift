import UIKit

// MARK: - SaberExt
public class SaberExt<Base> {
    var base: Base
    init(_ base: Base) { self.base = base }

    func rawBase() -> Base.Type { Base.self }
    func rawbase() -> Base { base }
    static func rawBase() -> Base.Type { Base.self }
}

// MARK: - Saberable
public protocol Saberable {}
public extension Saberable {
    var sb: SaberExt<Self> { SaberExt(self) }
    static var sb: SaberExt<Self>.Type { SaberExt<Self>.self }
}
