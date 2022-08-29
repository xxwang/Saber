import Foundation

// MARK: - Extension
open class Extension<Base> {
    public let base: Base?

    public init(_ base: Base) {
        self.base = base
    }

    public init(_ base: Base?) {
        self.base = base
    }
}

// MARK: - Extensionable
public protocol Extensionable {}
public extension Extensionable {
    static var ex: Extension<Self>.Type {
        return Extension<Self>.self
    }

    var ex: Extension<Self> {
        return Extension(self)
    }
}
