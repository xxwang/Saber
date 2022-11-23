import UIKit

// MARK: - 链式语法
public extension NSMutableAttributedString {
    /// 设置富文本文字的`字间距`
    /// - Parameters:
    ///   - wordSpacing:间距
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func wordSpacing(
        _ wordSpacing: CGFloat,
        for range: NSRange? = nil
    ) -> Self {
        let range = range ?? sb.fullNSRange()
        addAttributes([.kern: wordSpacing], range: range)
        return self
    }

    /// 设置指定`range`内文字的`行间距`
    /// - Parameters:
    ///   - lineSpacing:行间距
    ///   - alignment:对齐方式
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func lineSpacing(
        _ lineSpacing: CGFloat,
        alignment: NSTextAlignment = .left,
        for range: NSRange? = nil
    ) -> Self {
        let range = range ?? sb.fullNSRange()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    /// 设置指定`文字`的`行间距`
    /// - Parameters:
    ///   - lineSpacing:行间距
    ///   - alignment:对齐方式
    ///   - text:文本
    /// - Returns:`Self`
    @discardableResult
    func lineSpacing(
        _ lineSpacing: CGFloat,
        alignment: NSTextAlignment = .left,
        for text: String
    ) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: text)
    }

    /// 设置`删除线`
    /// - Parameters:
    ///   - style:删除线样式
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func strikethrough(
        _ style: NSUnderlineStyle = .single,
        for range: NSRange? = nil
    ) -> Self {
        let range = range ?? sb.fullNSRange()
        addAttributes([.strikethroughStyle: style.rawValue], range: range)
        return self
    }

    /// 设置指定`range`内的`字体`
    /// - Parameters:
    ///   - font:字体
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func font(
        _ font: UIFont,
        for range: NSRange? = nil
    ) -> Self {
        let range = range ?? sb.fullNSRange()
        return addAttributes([NSAttributedString.Key.font: font], for: range)
    }

    /// 设置指定`字符串`的`字体`
    /// - Parameters:
    ///   - font:字体
    ///   - text:特定文字
    /// - Returns:`Self`
    @discardableResult
    func font(
        _ font: UIFont,
        for text: String
    ) -> Self {
        return addAttributes([NSAttributedString.Key.font: font], for: text)
    }

    /// 设置`文字`的`颜色`
    /// - Parameters:
    ///   - color:文字颜色
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func foregroundColor(
        _ color: UIColor,
        for range: NSRange? = nil
    ) -> Self {
        let range = range ?? sb.fullNSRange()
        return addAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    /// 设置指定`文字`的`颜色`
    /// - Parameters:
    ///   - color:文字颜色
    ///   - range:文字
    /// - Returns:`Self`
    @discardableResult
    func foregroundColor(
        _ color: UIColor,
        for text: String
    ) -> Self {
        return addAttributes([NSAttributedString.Key.foregroundColor: color], for: text)
    }

    /// 设置`range`内`文字`的`下划线`
    /// - Parameters:
    ///   - color:下划线颜色
    ///   - stytle:下划线样式
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func underline(
        _ color: UIColor,
        stytle: NSUnderlineStyle = .single,
        for range: NSRange? = nil
    ) -> Self {
        let range = range ?? sb.fullNSRange()

        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    /// 设置指定`文字`的`下划线`
    /// - Parameters:
    ///   - color:下划线颜色
    ///   - stytle:下划线样式
    ///   - text:文本
    /// - Returns:`Self`
    @discardableResult
    func underline(
        _ color: UIColor,
        stytle: NSUnderlineStyle = .single,
        for text: String
    ) -> Self {
        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: text)
    }

    /// 设置`range`内文字的`删除线`
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func deleteline(
        _ color: UIColor,
        for range: NSRange? = nil
    ) -> Self {
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))

        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color

        let version = UIDevice.currentSystemVersion as NSString
        if version.floatValue >= 10.3 {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else if version.floatValue <= 9.0 {
            attributes[NSAttributedString.Key.strikethroughStyle] = []
        }

        let range = range ?? sb.fullNSRange()
        return addAttributes(attributes, for: range)
    }

    /// 设置指定`文字`的`删除线`
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - text:文本
    /// - Returns:`Self`
    @discardableResult
    func deleteline(
        _ color: UIColor,
        for text: String
    ) -> Self {
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))

        var attributes = [NSAttributedString.Key: Any]()
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

    /// 添加`首行文字缩进`
    /// - Parameter indent:缩进宽度
    /// - Returns:`Self`
    @discardableResult
    func firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: sb.fullNSRange())
    }

    /// 设置`range`范围内`文字`的`倾斜`
    /// - Parameters:
    ///   - obliqueness:倾斜
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func obliqueness(
        _ obliqueness: Float = 0,
        for range: NSRange? = nil
    ) -> Self {
        let range = range ?? sb.fullNSRange()
        return addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    /// 设置指定`文字`的`倾斜`
    /// - Parameters:
    ///   - obliqueness:倾斜
    ///   - text:文本
    /// - Returns:`Self`
    @discardableResult
    func obliqueness(
        _ obliqueness: Float = 0,
        for text: String
    ) -> Self {
        return addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: text)
    }

    /// 插入`图片附件`到指定字符`index`,
    /// - Parameters:
    ///   - source:资源类型可为(`图片名称`/`图片URL`/`图片路径`/`网络图片`)网络图片需指定`bounds`
    ///   - bounds:图片的大小,默认`.zero`(以底部基线为基准`y>0:图片向上移动 y<0:图片向下移动`)
    ///   - index:图片的位置,默认插入到开头
    /// - Returns:`Self`
    @discardableResult
    func insert(
        image source: String,
        bounds: CGRect = .zero,
        index: Int = 0
    ) -> Self {
        // NSTextAttachment可以将要插入的图片作为特殊字符处理
        let attch = NSTextAttachment()
        attch.image = UIImage.loadImage(source)
        attch.bounds = bounds

        // 创建带有图片的富文本
        let string = NSAttributedString(attachment: attch)

        // 将图片添加到富文本
        insert(string, at: index)

        return self
    }

    /// 设置`range`内的`属性`
    /// - Parameters:
    ///   - attributes:属性
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func addAttributes(
        _ attributes: [NSAttributedString.Key: Any],
        for range: NSRange
    ) -> Self {
        for name in attributes.keys {
            addAttribute(name, value: attributes[name] ?? "", range: range)
        }
        return self
    }

    /// 设置指定`文字`的`属性`
    /// - Parameters:
    ///   - attributes:属性
    ///   - text:文本
    /// - Returns:`Self`
    @discardableResult
    func addAttributes(
        _ attributes: [NSAttributedString.Key: Any],
        for text: String
    ) -> Self {
        let ranges = sb.subNSRanges(with: [text])
        if !ranges.isEmpty {
            for name in attributes.keys {
                for range in ranges {
                    addAttribute(name, value: attributes[name] ?? "", range: range)
                }
            }
        }
        return self
    }

    /// 设置与`正则表达式`符合的`匹配项`的`属性`
    /// - Parameters:
    ///   - attributes:属性字典
    ///   - pattern:正则表达式
    ///   - options:匹配选项
    /// - Returns:`Self`
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

    /// 将`属性`设置到与`target`匹配的结果
    /// - Parameters:
    ///   - attributes:属性字典
    ///   - target:目标字符串
    /// - Returns:`Self`
    @discardableResult
    func addAttributes<T: StringProtocol>(
        attributes: [Key: Any],
        toOccurrencesOf target: T
    ) -> Self {
        let pattern = "\\Q\(target)\\E"
        return addAttributes(attributes, toRangesMatching: pattern)
    }
}
