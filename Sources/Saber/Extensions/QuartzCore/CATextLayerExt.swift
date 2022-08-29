import QuartzCore
import UIKit

/*
 CATextLayer使用CoreText进行绘制,
 渲染速度比使用WebKit的UILabl快很多.
 而且UILabl主要是管理内容, 而CATextLayer则是绘制内容
 */

    // MARK: - 链式语法
public extension CATextLayer {
        /// 创建默认`CATextLayer`
    static var defaultTextLayer: CATextLayer {
        let layer = CATextLayer()
        return layer
    }
    
        /// 设置文字的内容
        /// - Parameter string: 文字内容
        /// - Returns: `Self`
    @discardableResult
    func string(_ string: String) -> Self {
        self.string = string
        return self
    }
    
        /// 设置 `NSAttributedString` 文字
        /// - Parameter attributedString: `NSAttributedString`文字
        /// - Returns: `Self`
    @discardableResult
    func attributedString(_ attributedString: NSAttributedString) -> Self {
        string = attributedString
        return self
    }
    
        /// 自动换行,默认NO
        /// - Parameter isWrapped: 是否自动换行
        /// - Returns: `Self`
    @discardableResult
    func isWrapped(_ isWrapped: Bool) -> Self {
        self.isWrapped = isWrapped
        return self
    }
    
        /// 当文本显示不全时的裁剪方式
        /// - Parameter truncationMode: 裁剪方式
        /// none 不剪裁,默认
        /// start 剪裁开始部分
        /// end 剪裁结束部分
        /// middle 剪裁中间部分
        /// - Returns: `Self`
    @discardableResult
    func truncationMode(_ truncationMode: CATextLayerTruncationMode) -> Self {
        self.truncationMode = truncationMode
        return self
    }
    
        /// 文本显示模式
        /// - Parameter alignmentMode: 文本显示模式
        /// - Returns: ccc
    @discardableResult
    func alignmentMode(_ alignmentMode: CATextLayerAlignmentMode) -> Self {
        self.alignmentMode = alignmentMode
        return self
    }
    
        /// 设置字体的颜色
        /// - Parameter foregroundColor: 字体的颜色
        /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ foregroundColor: UIColor) -> Self {
        self.foregroundColor = foregroundColor.cgColor
        return self
    }
    
        /// 设置字体的颜色(十六进制)
        /// - Parameter hex: 十六进制字符串颜色
        /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ hex: String) -> Self {
        foregroundColor = UIColor(hex: hex).cgColor
        return self
    }
    
        /// 设置内容缩放
        /// - Parameter scale: 内容缩放(默认:`UIScreen.main.scale`)
        /// - Returns: `Self`
    @discardableResult
    func contentsScale(_ scale: CGFloat = UIScreen.main.scale) -> Self {
        contentsScale = scale
        return self
    }
    
        /// 设置字体的大小
        /// - Parameter fontSize: 字体的大小
        /// - Returns: `Self`
    @discardableResult
    func fontSize(_ fontSize: CGFloat) -> Self {
        self.fontSize = fontSize
        if #available(iOS 9.0, *) {
            self.font = CTFontCreateWithName("PingFangSC-Regular" as CFString, fontSize, nil)
        }
        contentsScale = UIScreen.main.scale
        return self
    }
    
        /// 设置字体
        /// - Parameter font: 字体
        /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        contentsScale = UIScreen.main.scale
        return self
    }
    
        /// 设置字体粗体
        /// - Parameter boldfontSize: 粗体字体大小
        /// - Returns: `Self`
    @discardableResult
    func boldFont(_ boldfontSize: CGFloat) -> Self {
        fontSize = boldfontSize
        if #available(iOS 9.0, *) {
            self.font = CTFontCreateWithName("PingFangSC-Medium" as CFString, boldfontSize, nil)
        } else {
            font = CTFontCreateWithName("Helvetica-bold" as CFString, boldfontSize, nil)
        }
        contentsScale = UIScreen.main.scale
        return self
    }
}
