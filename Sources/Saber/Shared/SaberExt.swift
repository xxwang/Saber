import SceneKit
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

// MARK: - 实现扩展的对象列表
extension NSObject: Saberable {}
extension Bool: Saberable {}
extension Character: Saberable {}
extension ClosedRange<Int>: Saberable {}
extension Range<String.Index>: Saberable {}
extension SCNVector3: Saberable {}
extension CGAffineTransform: Saberable {}
extension CGColor: Saberable {}
extension CGImage: Saberable {}
extension CGPoint: Saberable {}
extension CGSize: Saberable {}
extension CGRect: Saberable {}
extension CGVector: Saberable {}

// MARK: - 实现扩展的协议列表
public extension BinaryFloatingPoint { var sb: SaberExt<Self> { SaberExt(self) }}
public extension BinaryInteger { var sb: SaberExt<Self> { SaberExt(self) }}
