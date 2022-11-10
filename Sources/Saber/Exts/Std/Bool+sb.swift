import Foundation

extension Bool: Saberable {}

// MARK: - 类型转换
public extension SaberExt where Base == Bool {
    /// `Bool`转`Int`
    /// - Returns: `Int`
    func toInt() -> Int {
        return base ? 1 : 0
    }

    /// `Bool`转`String`
    /// - Returns: `String`
    func toString() -> String {
        return base ? "true" : "false"
    }
}
