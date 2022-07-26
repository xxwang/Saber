import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

// MARK: - 属性
public extension String {
    var data: Data? {
        return self.data(using: .utf8)
    }
}

public extension String {
    /// 字典
    var object: [String: Any]? {
        guard let data = data else {
            return nil
        }
        guard let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return object
    }

    /// 字典数组
    var objectArray: [[String: Any]]? {
        guard let data = data else {
            return nil
        }
        guard let object = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return nil
        }
        return object
    }
}
