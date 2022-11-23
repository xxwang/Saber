import UIKit

// MARK: - SaberEx
public class SaberEx<Base> {
    var base: Base
    init(_ base: Base) { self.base = base }

    func rawBase() -> Base.Type { Base.self }
    func rawbase() -> Base { base }
    static func rawBase() -> Base.Type { Base.self }
}

// MARK: - Saberable
public protocol Saberable {}
public extension Saberable {
    var sb: SaberEx<Self> { SaberEx(self) }
    static var sb: SaberEx<Self>.Type { SaberEx<Self>.self }
}
