import Foundation

// MARK: - 方法
public extension SaberExt where Base: NSPredicate {
    /// 谓词取反
    /// - Returns: `NSCompoundPredicate`
    func not() -> NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: base)
    }

    /// 返回一个新的谓词,该谓词由参数构成,并将参数赋给谓词
    ///
    /// - Parameter predicate:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`.
    func and(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [base, predicate])
    }

    /// 返回一个新的谓词,该谓词由参数或将参数赋给谓词构成
    ///
    /// - Parameter predicate:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`.
    func or(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [base, predicate])
    }
}

// MARK: - 运算符
public extension NSPredicate {
    /// 返回一个新的谓词,该谓词由不匹配谓词而形成
    /// - Parameters:rhs:`NSPredicate`
    /// - Returns:`NSCompoundPredicate`
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.sb.not()
    }

    /// 返回一个新的谓词,该谓词由并将参数赋给谓词构成
    ///
    /// - Parameters:
    ///   - lhs:`NSPredicate`.
    ///   - rhs:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`
    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.sb.and(rhs)
    }

    /// 返回一个新的谓词,该谓词由参数构成,或将参数赋给谓词
    ///
    /// - Parameters:
    ///   - lhs:`NSPredicate`.
    ///   - rhs:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`
    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.sb.or(rhs)
    }

    /// 返回一个新的谓词,该谓词是通过将参数移除到谓词而形成的
    ///
    /// - Parameters:
    ///   - lhs:`NSPredicate`.
    ///   - rhs:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`
    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }
}
