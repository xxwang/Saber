// MARK: - 调用对象实体包装类型

import UIKit
public struct SaberExt<Base> {
    let base: Base
    fileprivate init(_ base: Base) {self.base = base}
//    fileprivate init(_ base: Base?) {self.base = base}
    
    func instance() -> Base {
        return self.base
    }
}


// MARK: - 需要使用的类型遵守此协议
public protocol Saberable {}
public extension Saberable {
    var sb: SaberExt<Self> { return SaberExt(self) }
    static var sb: SaberExt<Self>.Type { return SaberExt<Self>.self }
}

// MARK: - 可使用sb扩展的类型(具体扩展在单独文件中实现)
extension String: Saberable {}
extension Int: Saberable {}
extension Float: Saberable {}
extension Double: Saberable {}


public extension SaberExt where Base == String {
    
    func test1111() {
        Log.info("info...")
        Log.debug("debug...")
        Log.warning("warning...")
        Log.error("error...")
    }
}

public extension SaberExt where Base == String? {
    
    func test1111() {
        Log.info("info...111")
        Log.debug("debug...111")
        Log.warning("warning...111")
        Log.error("error...111")
    }
}

