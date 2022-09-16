// MARK: - 调用对象实体包装类型
public struct SaberExt<Base> {
    /// 调用对象实体
    let base: Base
    /// 非可选构造
    fileprivate init(_ base: Base) {self.base = base}
//    /// 可选构造
//    fileprivate init(_ base: Base?) {self.base = base}
}
// MARK: - 开放方法/属性
public extension SaberExt {
    func instance() -> Base {
        return self.base
    }
}

// MARK: - 需要使用的类型遵守此协议
public protocol Saberable {}
// MARK: - 开放方法/属性
public extension Saberable {
    /// 实例类型
    var sb: SaberExt<Self> { return SaberExt(self) }
    /// 静态类型
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
    
    func test2222() {
        Log.info("info...")
        Log.debug("debug...")
        Log.warning("warning...")
        Log.error("error...")
    }
}

public extension SaberExt where Base == Int {
    
    func test1111() {
        Log.info("info...")
        Log.debug("debug...")
        Log.warning("warning...")
        Log.error("error...")
    }
}

public extension SaberExt where Base == Float {
    
    func test1111() {
        Log.info("info...")
        Log.debug("debug...")
        Log.warning("warning...")
        Log.error("error...")
    }
}

public extension SaberExt where Base == Double {
    
    func test1111() {
        Log.info("info...")
        Log.debug("debug...")
        Log.warning("warning...")
        Log.error("error...")
    }
}
