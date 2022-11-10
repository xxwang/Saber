import Foundation

extension Bool: Saberable {}

// MARK: - 类型转换
public extension SaberExt where Base == Bool {
    /// `Bool`转`Int`
    func toInt() -> Int {
        return self.base ? 1 : 0
    }

    /// `Bool`转`String`
    func toString() -> String {
        return self.base ? "true" : "false"
    }
}
