// MARK: - 调用对象实体包装类型
public struct SaberExt<Base> {
    /// 被包装的原始对象
    public let base: Base
    
    fileprivate init(_ base: Base) { self.base = base }
//    fileprivate init(_ base: Base?) { self.base = base }
    
    /// 被包装的原始对象
    public func unpack() -> Base {
        return self.base
    }
}

// MARK: - 需要使用的类型遵守此协议
public protocol Saberable {}
public extension Saberable {
    var sb: SaberExt<Self> { return SaberExt(self) }
    static var sb: SaberExt<Self>.Type { return SaberExt<Self>.self }
}

public extension SaberExt where Base == String {
    func test1() -> Self {
        Log.info("1111")
        return self
    }
    
    func test2() -> Self {
        Log.info("1111")
        return self
    }
    
    func test3() -> Self {
        Log.info("3333")
        return self
    }
}
