
// MARK: - 方法
public extension Bool {
    /// `Bool`转`Int`
    func as_int() -> Int {
        return self ? 1 : 0
    }

    /// `Bool`转`String`
    func as_string() -> String {
        return self ? "true" : "false"
    }
}
