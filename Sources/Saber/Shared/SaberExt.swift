// MARK: - 调用对象实体包装类型
public struct SaberExt<Base> {
    /// 被包装的原始对象
    let base: Base?
    /// 非可选构造方法
    fileprivate init(_ base: Base) { self.base = base }
    /// 可选构造方法
    fileprivate init(_ base: Base?) { self.base = base }
    
    /// 被包装的原始对象
    func unpack() -> Base? {
        return self.base
    }
}

// MARK: - 需要使用的类型遵守此协议
public protocol Saberable {}
public extension Saberable {
    /// 非可选类型
    var sb: SaberExt<Self> { return SaberExt(self) }
    /// 可选类型
    static var sb: SaberExt<Self>.Type { return SaberExt<Self>.self }
}
