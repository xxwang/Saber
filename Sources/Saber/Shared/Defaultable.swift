import UIKit

// MARK: - 为类型扩展`default`方法
public protocol Defaultable: NSObjectProtocol where Self: NSObject {
    /// 关联类型
    associatedtype Associatedtype

    /// 生成默认对象
    /// - Returns: 对象
    static func `default`() -> Associatedtype
}
