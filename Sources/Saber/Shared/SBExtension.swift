import Foundation

// MARK: - SBExtension
open class SBExtension<Base> {
    public let base: Base?

    public init(_ base: Base) {
        self.base = base
    }

    public init(_ base: Base?) {
        self.base = base
    }
}

// MARK: - SBExtensionable
public protocol SBExtensionable {}
public extension SBExtensionable {
    static var sb: SBExtension<Self>.Type {
        return SBExtension<Self>.self
    }

    var sb: SBExtension<Self> {
        return SBExtension(self)
    }
}
