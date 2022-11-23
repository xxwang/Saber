import UIKit

// MARK: - 属性
public extension SaberEx where Base: UISearchBar {
    /// 搜索栏中的`UITextField`(如果适用)
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.base.searchTextField
        }
        let subViews = base.subviews.flatMap(\.subviews)
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

    /// 返回去除开头与结尾空字符的字符串
    var trimmedText: String? {
        return base.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - 方法
public extension SaberEx where Base: UISearchBar {
    /// 清空内容
    func clear() {
        base.text = ""
    }
}
