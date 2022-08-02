import Foundation

// MARK: - 排序
public extension MutableCollection where Self: RandomAccessCollection {
    /// 根据keyPath和compare函数对集合进行排序
    /// - Parameters keyPath: 路径
    /// - Parameter compare: 比较函数
    mutating func sort<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) {
        sort { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// 根据keyPath对集合进行排序
    /// - Parameters keyPath: 路径
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T>) {
        sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// 根据两个路径对集合进行排序
    /// - Parameters:
    ///     - keyPath1:  要排序的路径 需要遵守Comparable协议
    ///     - keyPath2:  当keyPath1比较结果相等时, 使用keyPath2进行操作, 需要遵守Comparable协议
    mutating func sort<T: Comparable, U: Comparable>(by keyPath1: KeyPath<Element, T>,
                                                     and keyPath2: KeyPath<Element, U>)
    {
        sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    /// 根据三个路径对集合进行排序
    /// - Parameters:
    ///     - keyPath1:要排序的路径 需要遵守Comparable协议
    ///     - keyPath2: keyPath1结果相等 使用keyPath2 需要遵守Comparable协议
    ///     - keyPath3: keyPath2结果相等 使用keyPath3 需要遵守Comparable协议
    mutating func sort<T: Comparable, U: Comparable, V: Comparable>(by keyPath1: KeyPath<Element, T>,
                                                                    and keyPath2: KeyPath<Element, U>,
                                                                    and keyPath3: KeyPath<Element, V>)
    {
        sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }
}

// MARK: - 方法
public extension MutableCollection {
    /// 为集合中所有元素的指定keyPath赋一个值
    /// - Parameters:
    ///   - value: 要赋的值
    ///   - keyPath: 路径
    mutating func assignToAll<Value>(value: Value, by keyPath: WritableKeyPath<Element, Value>) {
        for idx in indices {
            self[idx][keyPath: keyPath] = value
        }
    }
}
