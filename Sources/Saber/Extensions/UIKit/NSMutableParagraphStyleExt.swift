import UIKit

// MARK: - 链式语法
public extension NSMutableParagraphStyle {
    /// 创建默认`NSMutableParagraphStyle`
    static var defaultStyle: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.hyphenationFactor = 1.0
        style.firstLineHeadIndent = 0.0
        style.paragraphSpacingBefore = 0.0
        style.headIndent = 0
        style.tailIndent = 0
        return style
    }

    /// 设置对齐方式
    /// - Parameter alignment: 对方方式
    /// - Returns: `Self`
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 设置换行方式
    /// - Parameter lineBreakMode: 换行方式
    /// - Returns: `Self`
    @discardableResult
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }

    /// 设置行间距
    /// - Parameter lineSpacing: 行间距
    /// - Returns: `Self`
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }

    /// 设置段落间距
    /// - Parameter paragraphSpacing: 段落间距
    /// - Returns: `Self`
    @discardableResult
    func paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        self.paragraphSpacing = paragraphSpacing
        return self
    }
}
