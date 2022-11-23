import UIKit

// MARK: - 属性
public extension UIDatePicker {
    /// `UIDatePicker`的文本颜色
    var textColor: UIColor? {
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
    }
}

// MARK: - 链式语法
public extension UIDatePicker {
    /// 创建默认`UIDatePicker`
    static var defaultDatePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        return datePicker
    }

    /// 设置时区
    /// - Parameter timeZone:时区
    /// - Returns:`Self`
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置模式
    /// - Parameter datePickerMode:模式
    /// - Returns:`Self`
    @discardableResult
    func datePickerMode(_ datePickerMode: Mode) -> Self {
        self.datePickerMode = datePickerMode
        return self
    }

    /// 设置样式
    /// - Parameter preferredDatePickerStyle:样式
    /// - Returns:`Self`
    @discardableResult
    @available(iOS 13.4, *)
    func preferredDatePickerStyle(_ preferredDatePickerStyle: UIDatePickerStyle) -> Self {
        self.preferredDatePickerStyle = preferredDatePickerStyle
        return self
    }

    /// 是否高亮今天
    /// - Parameter highlightsToday:是否高亮今天
    /// - Returns:`Self`
    @discardableResult
    func highlightsToday(_ highlightsToday: Bool) -> Self {
        setValue(highlightsToday, forKey: "highlightsToday")
        return self
    }

    /// 设置文字颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        setValue(textColor, forKeyPath: "textColor")
        return self
    }
}
