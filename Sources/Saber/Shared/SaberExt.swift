// MARK: - 调用对象实体包装类型
public struct SaberExt<Base> {
    /// 调用对象实体
    let base: Base?
    /// 非可选构造
    init(_ base: Base) { self.base = base }
    /// 可选构造
    init(_ base: Base?) { self.base = base }
}

// MARK: - 需要使用的类型遵守此协议
public protocol Saberable {}
public extension Saberable {
    /// 静态类型
    static var sb: SaberExt<Self>.Type { return SaberExt<Self>.self }
    /// 实例类型
    var sb: SaberExt<Self> { return SaberExt(self) }
}



public extension SaberExt where Base == String {
    
    func test1111() {
        Log.info("info...")
        Log.debug("debug...")
        Log.warning("warning...")
        Log.error("error...")
    }
}

extension String: Saberable {}
extension Int: Saberable {}
extension Float: Saberable {}
extension Double: Saberable {}
