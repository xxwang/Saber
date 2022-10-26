import UIKit

// MARK: - 属性
public extension NSAttributedString {
    /// 获取整个字体串`NSRange`
    var fullNSRange: NSRange {
        return NSRange(location: 0, length: length)
    }

    /// 应用于整个字符串的属性字典
    var attributes: [Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }
}

// MARK: - 方法
public extension NSAttributedString {
    /// 获取指定字符串在属性字符串中的范围
    /// - Parameter subStr: 查获取`NSRange`的字符串
    /// - Returns: `NSRange`
    func subNSRange(_ subStr: String) -> NSRange {
        return string.subNSRange(subStr)
    }

    /// 计算属性文本`size`
    /// - Parameter maxWidth: 最大宽度
    /// - Returns: 文本size
    func attributedSize(_ maxWidth: CGFloat = kSCREEN_WIDTH) -> CGSize {
        let result = boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
                                  options: [
                                      .usesLineFragmentOrigin,
                                      .usesFontLeading,
                                      .truncatesLastVisibleLine,
                                  ],
                                  context: nil).size
        return CGSize(width: Darwin.ceil(result.width), height: Darwin.ceil(result.height))
    }

    /// 获取对应字符串数组的`NSRange`
    /// - Parameter texts: 字符串数组
    /// - Returns: `NSRange`数组
    func ranges(with texts: [String]) -> [NSRange] {
        var ranges = [NSRange]()
        // 遍历
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

    /// 加载网络图片
    /// - Parameter imageSource: 图片资源
    /// - Returns: 图片
    func loadImage(_ imageSource: String) -> UIImage? {
        if imageSource.hasPrefix("http: //") || imageSource.hasPrefix("https: //") {
            let imageURL = URL(string: imageSource)
            var imageData: Data?
            do {
                imageData = try Data(contentsOf: imageURL!)
                return UIImage(data: imageData!)!
            } catch {
                return nil
            }
        }
        return UIImage(named: imageSource)!
    }
}

// MARK: - 方法(数组: Element: NSAttributedString)
public extension Array where Element: NSAttributedString {
    /// 连接序列中的元素,在每个元素之间添加`separator`(分割符)
    /// - Parameter separator: 分割符 `NSAttributedString`
    /// - Returns: `NSAttributedString`
    func joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else { return NSMutableAttributedString(string: "") }
        return dropFirst().reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
            result.append(separator)
            result.append(element)
        }
    }

    /// 连接序列中的元素,在每个元素之间添加`separator`(分割符)
    /// - Parameter separator: 分割符 `String`
    /// - Returns: `NSAttributedString`
    func joined(separator: String) -> NSAttributedString {
        guard let firstElement = first else { return NSMutableAttributedString(string: "") }
        let attributedStringSeparator = NSAttributedString(string: separator)
        return dropFirst().reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
            result.append(attributedStringSeparator)
            result.append(element)
        }
    }
}

// MARK: - 运算符
public extension NSAttributedString {
    /// 将一个`NSAttributedString`添加到另一个`NSAttributedString`
    ///
    /// - Parameters:
    ///   - lhs: 添加的目标属性字符串
    ///   - rhs: 要添加的属性字符串
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// 把两个`NSAttributedString`合并到一起,生成新的属性字符串
    ///
    /// - Parameters:
    ///   - lhs: 要添加到的属性字符串
    ///   - rhs: 要添加的`NSAttributed`字符串
    /// - Returns: 添加了`NSAttributedString`的新实例
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// 将一个`NSAttributedString`添加到另一个`NSAttributedString`
    ///
    /// - Parameters:
    ///   - lhs: 要添加到的`NSAttributedString`
    ///   - rhs: 要添加的字符串
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// 将一个`NSAttributedString`添加到另一个`NSAttributedString`,并返回一个新的`NSAttributedString`实例
    ///
    /// - Parameters:
    ///   - lhs: `NSAttributedString`要添加到的字符串
    ///   - rhs: 要添加的字符串
    /// - Returns: 添加了字符串的新`NSAttributedString`实例
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}

// MARK: - 链式语法
public extension NSAttributedString {
    /// 设置特定范围的字体
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    func setFont(_ font: UIFont, for range: NSRange) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.font: font], for: range)
    }

    /// 设置特定文字的字体
    /// - Parameters:
    ///   - font: 字体
    ///   - text: 特定文字
    /// - Returns: `NSAttributedString`
    func setFont(_ font: UIFont, for text: String) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.font: font], for: text)
    }

    /// 设置特定区域的文字颜色
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    func setForegroundColor(_ color: UIColor, for range: NSRange) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    /// 设置特定文字的颜色
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 文字
    /// - Returns: `NSAttributedString`
    func setForegroundColor(_ color: UIColor, for text: String) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.foregroundColor: color], for: text)
    }

    /// 设置特定范围行间距
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - alignment: 对齐方式
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    func setLineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange) -> NSAttributedString {
        var style = attributes[.paragraphStyle] as? NSMutableParagraphStyle
        if style == nil {
            style = NSMutableParagraphStyle()
        }
        style?.lineSpacing = lineSpacing
        style?.alignment = alignment
        return setAttributes([NSAttributedString.Key.paragraphStyle: style!], for: range)
    }

    /// 设置特定文本行间距
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - alignment: 对齐方式
    ///   - text: 文本
    /// - Returns: `NSAttributedString`
    func setLineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for text: String) -> NSAttributedString {
        var style = attributes[.paragraphStyle] as? NSMutableParagraphStyle
        if style == nil {
            style = NSMutableParagraphStyle()
        }
        style?.lineSpacing = lineSpacing
        style?.alignment = alignment
        return setAttributes([NSAttributedString.Key.paragraphStyle: style!], for: text)
    }

    /// 设置特定范围的下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    func setUnderline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for range: NSRange) -> NSAttributedString {
        // 下划线样式
        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return setAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    /// 设置特定文本的下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式
    ///   - text: 文本
    /// - Returns: `NSAttributedString`
    func setUnderline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for text: String) -> NSAttributedString {
        // 下划线样式
        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return setAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: text)
    }

    /// 设置特定范围的删除线
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    func setDeleteline(_ color: UIColor, for range: NSRange) -> NSAttributedString {
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
        return setAttributes(attributes, for: range)
    }

    /// 设置特定文本的删除线
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - text: 文本
    /// - Returns: `NSAttributedString`
    func setDeleteline(_ color: UIColor, for text: String) -> NSAttributedString {
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
        return setAttributes(attributes, for: text)
    }

    /// 插入图片(可以图片名称或者图片URL地址,如果为网络图片,需要传入`imageBounds`)
    /// - Parameters:
    ///   - imageSource: 图片资源(可本地图片/网络图片)
    ///   - imageBounds: 图片的大小,默认为`.zero`(以底部基线为标准Y>0: 图片向上移动；Y<0: 图片向下移动)
    ///   - imageIndex: 图片的位置,默认放在开头
    /// - Returns: `NSAttributedString`
    func setImage(_ imageSource: String, imageBounds: CGRect = .zero, imageIndex: Int = 0) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        // NSTextAttachment可以将要插入的图片作为特殊字符处理
        let attch = NSTextAttachment()
        attch.image = loadImage(imageSource)
        attch.bounds = imageBounds
        // 创建带有图片的富文本
        let string = NSAttributedString(attachment: attch)
        // 将图片添加到富文本
        attributedString.insert(string, at: imageIndex)
        return attributedString
    }

    /// 设置首行缩进
    /// - Parameter indent: 缩进宽度
    /// - Returns: `NSAttributedString`
    func setFirstLineHeadIndent(_ indent: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return setAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: fullNSRange)
    }

    /// 设置特定范围的倾斜
    /// - Parameters:
    ///   - obliqueness: 倾斜
    ///   - range: 范围
    /// - Returns: `NSAttributedString`
    func setObliqueness(_ obliqueness: Float = 0, for range: NSRange) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    /// 设置特定文本的倾斜
    /// - Parameters:
    ///   - obliqueness: 倾斜
    ///   - text: 文本
    /// - Returns: `NSAttributedString`
    func setObliqueness(_ obliqueness: Float = 0, for text: String) -> NSAttributedString {
        return setAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: text)
    }

    /// 设置特定范围的属性
    /// - Parameters:
    ///   - attributes: 属性
    ///   - range: 范围
    /// - Returns: `NSMutableAttributedString`
    func setAttributes(_ attributes: [NSAttributedString.Key: Any], for range: NSRange) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        for name in attributes.keys {
            mutableAttributedString.addAttribute(name, value: attributes[name] ?? "", range: range)
        }
        return mutableAttributedString
    }

    /// 设置特定文本的属性
    /// - Parameters:
    ///   - attributes: 属性
    ///   - text: 文本
    /// - Returns: `NSMutableAttributedString`
    func setAttributes(_ attributes: [NSAttributedString.Key: Any], for text: String) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        let ranges = ranges(with: [text])
        if !ranges.isEmpty {
            for name in attributes.keys {
                for range in ranges {
                    mutableAttributedString.addAttribute(name, value: attributes[name] ?? "", range: range)
                }
            }
        }
        return mutableAttributedString
    }

    /// 设置属性到与正则表达式匹配的字符串
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - pattern: 指向目标的正则表达式
    ///   - options: 匹配期间应用于表达式的正则表达式选项.请参阅`NSRegularExpression.Options`
    /// - Returns: `NSAttributedString`
    func setAttributes(_ attributes: [Key: Any],
                       toRangesMatching pattern: String,
                       options: NSRegularExpression.Options = []) -> NSAttributedString
    {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return self }

        let matches = pattern.matches(in: string, options: [], range: NSRange(0 ..< length))
        let result = NSMutableAttributedString(attributedString: self)

        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }

        return result
    }

    /// 设置属性到特定字符串
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - target: 要应用于的属性的字符串
    /// - Returns: `NSAttributedString`
    func setAttributes<T: StringProtocol>(attributes: [Key: Any],
                                          toOccurrencesOf target: T) -> NSAttributedString
    {
        let pattern = "\\Q\(target)\\E"
        return setAttributes(attributes, toRangesMatching: pattern)
    }
}
