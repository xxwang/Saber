import UIKit

// MARK: - 属性
public extension NSAttributedString {
    /// 整个`NSAttributedString`的`NSRange`
    var fullNSRange: NSRange {
        return NSRange(location: 0, length: length)
    }

    /// `NSAttributedString`上的`属性字典`
    var attributes: [Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }

    /// `NSAttributedString`转`NSMutableAttributedString`
    var mutableAttributedString: NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }
}

// MARK: - 方法
public extension NSAttributedString {
    /// 获取`subStr`在`self`中的`NSRange`
    /// - Parameter subStr: 用于查找的字符串
    /// - Returns: `NSRange`
    func subNSRange(_ subStr: String) -> NSRange {
        return string.subNSRange(subStr)
    }

    /// 获取`texts`在`self`中的`[NSRange]`
    /// - Parameter texts: `[String]`
    /// - Returns: `[NSRange]`
    func subNSRanges(with texts: [String]) -> [NSRange] {
        var ranges = [NSRange]()
        for str in texts {
            if string.contains(str) {
                let subStrArr = string.components(separatedBy: str)
                var subStrIndex = 0
                for i in 0 ..< (subStrArr.count - 1) {
                    let subDivisionStr = subStrArr[i]
                    if i == 0 {
                        subStrIndex += (subDivisionStr.lengthOfBytes(using: .unicode) / 2)
                    } else {
                        subStrIndex += (subDivisionStr.lengthOfBytes(using: .unicode) / 2 + str.lengthOfBytes(using: .unicode) / 2)
                    }
                    let newRange = NSRange(location: subStrIndex, length: str.count)
                    ranges.append(newRange)
                }
            }
        }
        return ranges
    }

    /// 计算`NSAttributedString`的`CGSize`
    /// - Parameter maxWidth: 最大宽度
    /// - Returns: `CGSize`
    func strSize(_ maxWidth: CGFloat = kSCREEN_WIDTH) -> CGSize {
        let result = boundingRect(
            with: CGSize(
                width: maxWidth,
                height: CGFloat.greatestFiniteMagnitude
            ),
            options: [
                .usesLineFragmentOrigin,
                .usesFontLeading,
                .truncatesLastVisibleLine,
            ],
            context: nil
        ).size
        return CGSize(width: Darwin.ceil(result.width), height: Darwin.ceil(result.height))
    }
}

// MARK: - 方法(数组: Element: NSAttributedString)
public extension Array where Element: NSAttributedString {
    /// `拼接``NSAttributedString数组`中的每个元素并使用`separator`分割
    /// - Parameter separator: `NSAttributedString`类型分割符
    /// - Returns: `NSAttributedString`
    func joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else {
            return "".attributedString
        }
        return dropFirst()
            .reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
                result.append(separator)
                result.append(element)
            }
    }

    /// `拼接``NSAttributedString数组`中的每个元素并使用`separator`分割
    /// - Parameter separator: `String`类型分割符
    /// - Returns: `NSAttributedString`
    func joined(separator: String) -> NSAttributedString {
        let separator = NSAttributedString(string: separator)
        return joined(separator: separator)
    }
}

// MARK: - 运算符
public extension NSAttributedString {
    /// 将`NSAttributedString`追加到另一个`NSAttributedString`
    /// - Parameters:
    ///   - lhs: 目标`NSAttributedString`
    ///   - rhs: 待追加`NSAttributedString`
    static func += (
        lhs: inout NSAttributedString,
        rhs: NSAttributedString
    ) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// 将`String`追加到`NSAttributedString`
    /// - Parameters:
    ///   - lhs: 目标`NSAttributedString`
    ///   - rhs: 要添加的`String`
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// 合并两个`NSAttributedString`,生成新的`NSAttributedString`
    /// - Parameters:
    ///   - lhs: 参与合并的第一个`NSAttributedString`
    ///   - rhs: 参与合并的第二个`NSAttributedString`
    /// - Returns: `NSAttributedString`
    static func + (
        lhs: NSAttributedString,
        rhs: NSAttributedString
    ) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// 将`String`添加到`NSAttributedString`,返回新的`NSAttributedString`
    /// - Parameters:
    ///   - lhs: 目标`NSAttributedString`
    ///   - rhs: 要添加的`String`
    /// - Returns: 新`NSAttributedString`
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}

// MARK: - 链式语法
public extension NSAttributedString {
    /// 设置指定`range`内的`字体`
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setFont(
        _ font: UIFont,
        for range: NSRange? = nil
    ) -> NSAttributedString {
        let range = range ?? fullNSRange
        return setAttributes([NSAttributedString.Key.font: font], for: range)
    }

    /// 设置指定`字符串`的`字体`
    /// - Parameters:
    ///   - font: 字体
    ///   - text: 特定文字
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setFont(
        _ font: UIFont,
        for text: String
    ) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.font: font], for: text)
    }

    /// 设置`文字`的`颜色`
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setForegroundColor(
        _ color: UIColor,
        for range: NSRange? = nil
    ) -> NSAttributedString {
        let range = range ?? fullNSRange
        return setAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    /// 设置指定`文字`的`颜色`
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 文字
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setForegroundColor(
        _ color: UIColor,
        for text: String
    ) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.foregroundColor: color], for: text)
    }

    /// 设置指定`range`内文字的`行间距`
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - alignment: 对齐方式
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setLineSpacing(
        _ lineSpacing: CGFloat,
        alignment: NSTextAlignment = .left,
        for range: NSRange? = nil
    ) -> NSAttributedString {
        let range = range ?? fullNSRange

        var style = attributes[.paragraphStyle] as? NSMutableParagraphStyle
        if style == nil {
            style = NSMutableParagraphStyle()
        }
        style?.lineSpacing = lineSpacing
        style?.alignment = alignment
        return setAttributes([NSAttributedString.Key.paragraphStyle: style!], for: range)
    }

    /// 设置指定`文字`的`行间距`
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - alignment: 对齐方式
    ///   - text: 文本
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setLineSpacing(
        _ lineSpacing: CGFloat,
        alignment: NSTextAlignment = .left,
        for text: String
    ) -> NSAttributedString {
        var style = attributes[.paragraphStyle] as? NSMutableParagraphStyle
        if style == nil {
            style = NSMutableParagraphStyle()
        }
        style?.lineSpacing = lineSpacing
        style?.alignment = alignment
        return setAttributes([NSAttributedString.Key.paragraphStyle: style!], for: text)
    }

    /// 设置`range`内`文字`的`下划线`
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setUnderline(
        _ color: UIColor,
        stytle: NSUnderlineStyle = .single,
        for range: NSRange? = nil
    ) -> NSAttributedString {
        let range = range ?? fullNSRange

        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return setAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    /// 设置指定`文字`的`下划线`
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式
    ///   - text: 文本
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setUnderline(
        _ color: UIColor,
        stytle: NSUnderlineStyle = .single,
        for text: String
    ) -> NSAttributedString {
        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return setAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: text)
    }

    /// 设置`range`内文字的`删除线`
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setDeleteline(
        _ color: UIColor,
        for range: NSRange? = nil
    ) -> NSAttributedString {
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
        let range = range ?? fullNSRange
        return setAttributes(attributes, for: range)
    }

    /// 设置指定`文字`的`删除线`
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - text: 文本
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setDeleteline(
        _ color: UIColor,
        for text: String
    ) -> NSAttributedString {
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
        return setAttributes(attributes, for: text)
    }

    /// 添加`首行文字缩进`
    /// - Parameter indent: 缩进宽度
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setFirstLineHeadIndent(_ indent: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: fullNSRange)
    }

    /// 设置`range`范围内`文字`的`倾斜`
    /// - Parameters:
    ///   - obliqueness: 倾斜
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setObliqueness(
        _ obliqueness: Float = 0,
        for range: NSRange? = nil
    ) -> NSAttributedString {
        let range = range ?? fullNSRange
        return setAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    /// 设置指定`文字`的`倾斜`
    /// - Parameters:
    ///   - obliqueness: 倾斜
    ///   - text: 文本
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setObliqueness(
        _ obliqueness: Float = 0,
        for text: String
    ) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: text)
    }

    /// 插入`图片附件`到指定字符`index`,
    /// - Parameters:
    ///   - source: 资源类型可为(`图片名称`/`图片URL`/`图片路径`/`网络图片`)网络图片需指定`bounds`
    ///   - bounds: 图片的大小,默认`.zero`(以底部基线为基准`y>0: 图片向上移动 y<0: 图片向下移动`)
    ///   - index: 图片的位置,默认插入到开头
    /// - Returns: `NSAttributedString`
    @discardableResult
    func set(
        image source: String,
        bounds: CGRect = .zero,
        index: Int = 0
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        // NSTextAttachment可以将要插入的图片作为特殊字符处理
        let attch = NSTextAttachment()
        attch.image = UIImage.loadImage(source)
        attch.bounds = bounds
        // 创建带有图片的富文本
        let string = NSAttributedString(attachment: attch)
        // 将图片添加到富文本
        attributedString.insert(string, at: index)
        return attributedString
    }

    /// 设置`range`内的`属性`
    /// - Parameters:
    ///   - attributes: 属性
    ///   - range: 范围
    /// - Returns: `NSMutableAttributedString`
    @discardableResult
    func setAttributes(
        _ attributes: [NSAttributedString.Key: Any],
        for range: NSRange? = nil
    ) -> NSMutableAttributedString {
        let range = range ?? fullNSRange

        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        for name in attributes.keys {
            mutableAttributedString.addAttribute(name, value: attributes[name] ?? "", range: range)
        }
        return mutableAttributedString
    }

    /// 设置指定`文本`的`属性`
    /// - Parameters:
    ///   - attributes: 属性
    ///   - text: 文本
    /// - Returns: `NSMutableAttributedString`
    @discardableResult
    func setAttributes(
        _ attributes: [NSAttributedString.Key: Any],
        for text: String
    ) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        let ranges = subNSRanges(with: [text])
        if !ranges.isEmpty {
            for name in attributes.keys {
                for range in ranges {
                    mutableAttributedString.addAttribute(name, value: attributes[name] ?? "", range: range)
                }
            }
        }
        return mutableAttributedString
    }

    /// 设置与`正则表达式`符合的`匹配项`的`属性`
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - pattern: 正则表达式
    ///   - options: 匹配选项
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setAttributes(
        _ attributes: [Key: Any],
        toRangesMatching pattern: String,
        options: NSRegularExpression.Options = []
    ) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return self }

        let matches = pattern.matches(in: string, options: [], range: NSRange(0 ..< length))
        let result = NSMutableAttributedString(attributedString: self)

        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }

        return result
    }

    /// 将`属性`设置到与`target`匹配的结果
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - target: 目标字符串
    /// - Returns: `NSAttributedString`
    @discardableResult
    func setAttributes<T: StringProtocol>(
        attributes: [Key: Any],
        toOccurrencesOf target: T
    ) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"
        return setAttributes(attributes, toRangesMatching: pattern)
    }
}
