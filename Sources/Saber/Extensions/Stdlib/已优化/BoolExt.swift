import Foundation

// MARK: - 属性
public extension SaberExt where Base == Bool {
    /// Bool转Int
    var int:Int {
        return self.base ? 1 : 0
    }
    
    /// Bool转字符串
    var string: String {
        return self.base ? "true" : "false"
    }
}
