import QuartzCore
import UIKit

// MARK: - 链式语法
public extension CATextLayer {
    /// 关联类型
    typealias Associatedtype = CATextLayer

    /// 创建默认`CATextLayer`
    override class func `default`() -> Associatedtype {
        let layer = CATextLayer()
        return layer
    }

    /// 设置文字的内容
    /// - Parameter string:文字内容
    /// - Returns:`Self`
    @discardableResult
    func string(_ string: String) -> Self {
        self.string = string
        return self
    }

    /// 自动换行,默认`NO`
    /// - Parameter isWrapped:是否自动换行
    /// - Returns:`Self`
    @discardableResult
    func isWrapped(_ isWrapped: Bool) -> Self {
        self.isWrapped = isWrapped
        return self
    }

    /// 当文本过长时的裁剪方式
    /// - Parameter truncationMode: 截断方式
    /// - Returns: `Self`
    @discardableResult
    func truncationMode(_ truncationMode: CATextLayerTruncationMode) -> Self {
        self.truncationMode = truncationMode
        return self
    }

    /// 文本对齐模式
    /// - Parameter alignmentMode:对齐模式
    /// - Returns:`Self`
    @discardableResult
    func alignmentMode(_ alignmentMode: CATextLayerAlignmentMode) -> Self {
        self.alignmentMode = alignmentMode
        return self
    }

    /// 设置字体的颜色
    /// - Parameter foregroundColor:字体的颜色
    /// - Returns:`Self`
    @discardableResult
    func foregroundColor(_ foregroundColor: UIColor) -> Self {
        self.foregroundColor = foregroundColor.cgColor
        return self
    }

    /// 设置字体的颜色(十六进制)
    /// - Parameter hex:十六进制字符串颜色
    /// - Returns:`Self`
    @discardableResult
    func foregroundColor(_ hex: String) -> Self {
        foregroundColor = UIColor(hex: hex).cgColor
        return self
    }

    /// 设置内容缩放
    /// - Parameter scale:内容缩放(默认:`UIScreen.main.scale`)
    /// - Returns:`Self`
    @discardableResult
    func contentsScale(_ scale: CGFloat = UIScreen.main.scale) -> Self {
        contentsScale = scale
        return self
    }

    /// 设置字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        return self
    }
}
