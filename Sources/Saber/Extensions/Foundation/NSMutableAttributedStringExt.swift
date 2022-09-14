import UIKit

// MARK: - 富文本属性介绍
/*
 NSFontAttributeName                设置字体属性,默认值：字体：Helvetica(Neue) 字号：12
 NSForegroundColorAttributeNam      设置字体颜色,取值为 UIColor对象,默认值为黑色
 NSBackgroundColorAttributeName     设置字体所在区域背景颜色,取值为 UIColor对象,默认值为nil, 透明色
 NSLigatureAttributeName            设置连体属性,取值为NSNumber 对象(整数),0 表示没有连体字符,1 表示使用默认的连体字符
 NSKernAttributeName                设定字符间距,取值为 NSNumber 对象(整数),正值间距加宽,负值间距变窄
 NSStrikethroughStyleAttributeName  设置删除线,取值为 NSNumber 对象(整数)
 NSStrikethroughColorAttributeName  设置删除线颜色,取值为 UIColor 对象,默认值为黑色
 NSUnderlineStyleAttributeName      设置下划线,取值为 NSNumber 对象(整数),枚举常量 NSUnderlineStyle中的值,与删除线类似
 NSUnderlineColorAttributeName      设置下划线颜色,取值为 UIColor 对象,默认值为黑色
 NSStrokeWidth AttributeName         设置笔画宽度,取值为 NSNumber 对象(整数),负值填充效果,正值中空效果
 NSStrokeColorAttributeName         填充部分颜色,不是字体颜色,取值为 UIColor 对象
 NSShadowAttributeName              设置阴影属性,取值为 NSShadow 对象
 NSTextEffectAttributeName          设置文本特殊效果,取值为 NSString 对象,目前只有图版印刷效果可用：
 NSBaselineOffsetAttributeName      设置基线偏移值,取值为 NSNumber (float),正值上偏,负值下偏
 NSObliquenessAttributeName         设置字形倾斜度,取值为 NSNumber (float),正值右倾,负值左倾
 NSExpansionAttributeName           设置文本横向拉伸属性,取值为 NSNumber (float),正值横向拉伸文本,负值横向压缩文本
 NSWritingDirectionAttributeName    设置文字书写方向,从左向右书写或者从右向左书写
 NSVerticalGlyphFormAttributeName   设置文字排版方向,取值为 NSNumber 对象(整数),0 表示横排文本,1 表示竖排文本
 NSLinkAttributeName                设置链接属性,点击后调用浏览器打开指定URL地址
 NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
 NSParagraphStyleAttributeName      设置文本段落排版格式,取值为 NSParagraphStyle 对象
 */

// MARK: - 链式语法
public extension NSMutableAttributedString {
    /// 设置富文本文字的 字间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func wordSpacing(_ wordSpacing: CGFloat) -> Self {
        addAttributes([.kern: wordSpacing], range: fullNSRange)
        return self
    }

    /// 设置删除线
    /// - Parameter style: 删除线样式
    /// - Returns: `Self`
    @discardableResult
    func strikethrough(_ style: NSUnderlineStyle = .single) -> Self {
        addAttributes([.strikethroughStyle: style.rawValue], range: fullNSRange)
        return self
    }

    /// 添加特定范围的字体
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 范围
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont, for range: NSRange) -> Self {
        return addAttributes([NSAttributedString.Key.font: font], for: range)
    }

    /// 添加特定文字的字体
    /// - Parameters:
    ///   - font: 字体
    ///   - text: 特定文字
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont, for text: String) -> Self {
        return addAttributes([NSAttributedString.Key.font: font], for: text)
    }

    /// 设置富文本文字的 `UIFont`
    /// - Parameter font: `UIFont`
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        addAttributes([.font: font], range: fullNSRange)
        return self
    }

    /// 添加特定区域的文字颜色
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 范围
    /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ color: UIColor, for range: NSRange) -> Self {
        return addAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    /// 添加特定文字的颜色
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 文字
    /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ color: UIColor, for text: String) -> Self {
        return addAttributes([NSAttributedString.Key.foregroundColor: color], for: text)
    }

    /// 设置富文本文字的颜色
    /// - Parameter color: 富文本文字的颜色
    /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ color: UIColor) -> Self {
        addAttributes([.foregroundColor: color], range: fullNSRange)
        return self
    }

    /// 添加特定范围行间距
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - alignment: 对齐方式
    ///   - range: 范围
    /// - Returns: `Self`
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    /// 添加特定文本行间距
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - alignment: 对齐方式
    ///   - text: 文本
    /// - Returns: `Self`
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for text: String) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: text)
    }

    /// 添加特定范围的下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式
    ///   - range: 范围
    /// - Returns: `Self`
    @discardableResult
    func underline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for range: NSRange) -> Self {
        // 下划线样式
        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    /// 添加特定文本的下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式
    ///   - text: 文本
    /// - Returns: `Self`
    @discardableResult
    func underline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for text: String) -> Self {
        // 下划线样式
        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: text)
    }

    /// 添加特定范围的删除线
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 范围
    /// - Returns: `Self`
    @discardableResult
    func deleteline(_ color: UIColor, for range: NSRange) -> Self {
        var attributes = [NSAttributedString.Key: Any]()
        // 删除线样式
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color

        let version = UIDevice.currentSystemVersion as NSString
        if version.floatValue >= 10.3 {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else if version.floatValue <= 9.0 {
            attributes[NSAttributedString.Key.strikethroughStyle] = []
        }
        return addAttributes(attributes, for: range)
    }

    /// 添加特定文本的删除线
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - text: 文本
    /// - Returns: `Self`
    @discardableResult
    func deleteline(_ color: UIColor, for text: String) -> Self {
        var attributes = [NSAttributedString.Key: Any]()
        // 删除线样式
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color

        let version = UIDevice.currentSystemVersion as NSString
        if version.floatValue >= 10.3 {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else if version.floatValue <= 9.0 {
            attributes[NSAttributedString.Key.strikethroughStyle] = []
        }
        return addAttributes(attributes, for: text)
    }

    /// 插入图片(可以图片名称或者图片URL地址,如果为网络图片,需要传入`imageBounds`)
    /// - Parameters:
    ///   - imageSource: 图片资源(可本地图片/网络图片)
    ///   - imageBounds: 图片的大小,默认为`.zero`(以底部基线为标准Y>0：图片向上移动；Y<0:图片向下移动)
    ///   - imageIndex: 图片的位置,默认放在开头
    /// - Returns: `Self`
    @discardableResult
    func insertImage(_ imageSource: String, imageBounds: CGRect = .zero, imageIndex: Int = 0) -> Self {
        // NSTextAttachment可以将要插入的图片作为特殊字符处理
        let attch = NSTextAttachment()
        attch.image = loadImage(imageSource)
        attch.bounds = imageBounds
        // 创建带有图片的富文本
        let string = NSAttributedString(attachment: attch)
        // 将图片添加到富文本
        insert(string, at: imageIndex)
        return self
    }

    /// 添加首行缩进
    /// - Parameter indent: 缩进宽度
    /// - Returns: `Self`
    @discardableResult
    func firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: fullNSRange)
    }

    /// 添加特定范围的倾斜
    /// - Parameters:
    ///   - obliqueness: 倾斜
    ///   - range: 范围
    /// - Returns: `Self`
    @discardableResult
    func obliqueness(_ obliqueness: Float = 0, for range: NSRange) -> Self {
        return addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    /// 添加特定文本的倾斜
    /// - Parameters:
    ///   - obliqueness: 倾斜
    ///   - text: 文本
    /// - Returns: `Self`
    @discardableResult
    func obliqueness(_ obliqueness: Float = 0, for text: String) -> NSAttributedString {
        return addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: text)
    }

    /// 添加特定范围的属性
    /// - Parameters:
    ///   - attributes: 属性
    ///   - range: 范围
    /// - Returns: `Self`
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], for range: NSRange) -> Self {
        for name in attributes.keys {
            addAttribute(name, value: attributes[name] ?? "", range: range)
        }
        return self
    }

    /// 添加特定文本的属性
    /// - Parameters:
    ///   - attributes: 属性
    ///   - text: 文本
    /// - Returns: `Self`
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], for text: String) -> Self {
        let ranges = self.ranges(with: [text])
        if !ranges.isEmpty {
            for name in attributes.keys {
                for range in ranges {
                    addAttribute(name, value: attributes[name] ?? "", range: range)
                }
            }
        }
        return self
    }

    /// 添加属性到与正则表达式匹配的字符串
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - pattern: 指向目标的正则表达式
    ///   - options: 匹配期间应用于表达式的正则表达式选项.请参阅`NSRegularExpression.Options`
    /// - Returns: `Self`
    @discardableResult
    func addAttributes(_ attributes: [Key: Any],
                       toRangesMatching pattern: String,
                       options: NSRegularExpression.Options = []) -> Self
    {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return self }

        let matches = pattern.matches(in: string, options: [], range: NSRange(0 ..< length))
        for match in matches {
            addAttributes(attributes, range: match.range)
        }

        return self
    }

    /// 添加属性到特定字符串
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - target: 要应用于的属性的字符串
    /// - Returns: `NSAttributedString`
    @discardableResult
    func addAttributes<T: StringProtocol>(attributes: [Key: Any],
                                          toOccurrencesOf target: T) -> NSAttributedString
    {
        let pattern = "\\Q\(target)\\E"
        return addAttributes(attributes, toRangesMatching: pattern)
    }
}
