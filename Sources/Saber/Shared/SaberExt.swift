// MARK: - 调用对象实体包装类型

import UIKit
public struct SaberExt<Base> {
    fileprivate let base: Base?
    fileprivate init(_ base: Base) {self.base = base; self.isop = false}
    fileprivate init(_ base: Base?) {self.base = base; self.isop = true}
    var isop: Bool = false
    #if isop
    func instance() -> Base {
        return self.base
    }
    #else
    func instance() -> Base? {
        return self.base
    }
    #endif
}


// MARK: - 需要使用的类型遵守此协议
public protocol Saberable {}
public extension Saberable {
    var sb: SaberExt<Self> { return SaberExt(self) }
    static var sb: SaberExt<Self>.Type { return SaberExt<Self>.self }
}

// MARK: - 可使用sb扩展的类型(具体扩展在单独文件中实现)
extension String: Saberable {}

public extension SaberExt where Base == String {
    
    func test1111() {
        Log.info("info...")
        Log.debug("debug...")
        Log.warning("warning...")
        Log.error("error...")
    }
}
