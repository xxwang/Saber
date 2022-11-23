import UIKit

// MARK: - 属性
public extension UILabel {
    /// 获取字体的大小
    var fontSize: CGFloat {
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = minimumScaleFactor

        let attributedText = NSMutableAttributedString(attributedString: self.attributedText!)
        attributedText.setAttributes([
            .font: font as Any,
        ], range: attributedText.fullNSRange)
        attributedText.boundingRect(with: bounds.size, options: .usesLineFragmentOrigin, context: context)

        return font.pointSize * context.actualScaleFactor
    }

    /// 获取内容需要的高度(需要在`UILabel`宽度确定的情况下)
    var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }

    /// 获取`UILabel`的每一行字符串(需要`UILabel`具有宽度值)
//    var textLines:[String] {
//        let text = self.text ?? ""
//        let font = self.font!
//        return text.lines(bounds.width, font:font)
//    }

    /// 获取`UILabel`第一行内容
    var firstLineString: String? {
        return linesContent().1?.first
    }

    /// 判断`UILabel`中的内容是否被截断
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }

        // 计算理论上显示所有文字需要的尺寸
        let rect = CGSize(
            width: bounds.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        let labelTextSize = (labelText as NSString)
            .boundingRect(
                with: rect,
                options: .usesLineFragmentOrigin,
                attributes: [.font: font!],
                context: nil
            )

        // 计算理论上需要的行数
        let labelTextLines = Int(Foundation.ceil(CGFloat(labelTextSize.height) / font.lineHeight))
        // 实际可显示的行数
        var labelShowLines = Int(Foundation.floor(CGFloat(bounds.size.height) / font.lineHeight))
        if numberOfLines != 0 {
            labelShowLines = min(labelShowLines, numberOfLines)
        }
        // 比较两个行数来判断是否被截断
        return labelTextLines > labelShowLines
    }
}

// MARK: - 构造方法
public extension UILabel {
    /// 使用内容字符串来创建一个`UILabel`
    /// - Parameter text:内容字符串
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// 使用内容字符串和字体样式来创建一个`UILabel`
    /// - Parameters:
    ///   - text:内容字符串
    ///   - style:字体样式
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }
}

// MARK: - 获取`UILabel`中内容大小
public extension UILabel {
    /// 获取`UILabel`中`字符串`的大小
    /// - Parameter maxWidth:最大宽度
    /// - Returns:`CGSize`
    func textSize(_ maxWidth: CGFloat = kScreenWidth) -> CGSize {
        return text?.strSize(maxWidth, font: font) ?? .zero
    }

    /// 获取`UILabel`中`属性字符串`的大小
    /// - Parameter maxWidth:最大宽度
    /// - Returns:`CGSize`
    func attributedSize(_ maxWidth: CGFloat = kScreenWidth) -> CGSize {
        return attributedText?.strSize(maxWidth) ?? .zero
    }
}

// MARK: - 属性字符串
public extension UILabel {
    /// 混合图片和文本
    /// - Parameters:
    ///   - text:文字内容
    ///   - images:图片数组
    ///   - spacing:间距
    ///   - scale:缩放比例
    ///   - insertIndex:图片插入位置
    ///   - isOrgin:是否使用图片原始大小
    func blend(
        _ text: String?,
        images: [UIImage?] = [],
        spacing: CGFloat = 5,
        scale: CGFloat,
        insertIndex: Int = 0,
        isOrgin: Bool = false
    ) -> NSMutableAttributedString {
        // 头部字符串
        let headString = text?.sb.subString(to: insertIndex) ?? ""
        let attributedString = NSMutableAttributedString(string: headString)

        for image in images {
            guard let image = image else {
                continue
            }
            // 创建图片附件
            let attach = NSTextAttachment()
            attach.image = image
            // 计算图片宽高
            let imageHeight = (isOrgin ? image.size.height : font.pointSize) * scale
            let imageWidth = (image.size.width / image.size.height) * imageHeight
            // 附件的Y坐标位置
            let attachTop = (font.lineHeight - font.pointSize) / 2
            // 设置附件尺寸相关信息
            attach.bounds = CGRect(x: -3, y: -attachTop, width: imageWidth, height: imageHeight)

            // 使用图片附件创建属性字符串
            let imageAttributedString = NSAttributedString(attachment: attach)
            // 将图片属性字符串追加到`attribuedString`
            attributedString.append(imageAttributedString)
            // 文字间距只对文字有效
            attributedString.append(NSAttributedString(string: " "))
        }

        // 尾部字符串
        let tailString = text?.sb.subString(from: insertIndex) ?? ""
        attributedString.append(NSAttributedString(string: tailString))

        // 图文间距需要减去默认的空格宽度
        let spaceW = " ".strSize(.greatestFiniteMagnitude, font: font).width
        let range = NSRange(location: 0, length: images.count * 2)
        attributedString.addAttribute(.kern, value: spacing - spaceW, range: range)

        // 设置属性字符串到`UILabel`
        attributedText = attributedString

        return attributedString
    }

    /// 设置`text`间距
    /// - Parameters:
    ///   - text:文本字符串
    ///   - lineSpacing:行间距
    ///   - wordSpacing:字间距
    /// - Returns:`NSMutableAttributedString`
    func setupTextSpacing(
        with text: String,
        lineSpacing: CGFloat,
        wordSpacing: CGFloat = 1
    ) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        style.alignment = .left
        // 设置行间距
        style.lineSpacing = lineSpacing

        style.hyphenationFactor = 1.0
        style.firstLineHeadIndent = 0.0
        style.paragraphSpacingBefore = 0.0
        style.headIndent = 0
        style.tailIndent = 0

        // 创建属性字符串
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .paragraphStyle: style,
            .kern: wordSpacing,
        ])

        // 字体
        if let font = font {
            attributedString.addAttribute(.font, value: font, range: attributedString.fullNSRange)
        }

        // 设置属性字符串到`UILabel`
        attributedText = attributedString

        return attributedString
    }
}

// MARK: - 方法
public extension UILabel {
    /// 获取`UILabel`的文本行数及每一行的内容
    /// - Parameters:
    ///   - labelWidth:`UILabel`的宽度
    ///   - lineSpacing:行间距
    ///   - wordSpacing:字间距
    ///   - paragraphSpacing:段落间距
    /// - Returns:行数及每行内容
    func linesContent(
        _ labelWidth: CGFloat? = nil,
        lineSpacing: CGFloat = 0.0,
        wordSpacing: CGFloat = 0.0,
        paragraphSpacing: CGFloat = 0.0
    ) -> (Int?, [String]?) {
        guard
            let text = text,
            let font = font
        else {
            return (0, nil)
        }

        let labelWidth: CGFloat = labelWidth ?? bounds.width

        let textAlignment = self.textAlignment
        let lineBreakMode = self.lineBreakMode

        // 获取属性字符串的属性
        let attributesDict = UILabel.attributeList(
            font: font,
            lineBreakMode: lineBreakMode,
            textAlignment: textAlignment,
            lineSpacing: lineSpacing,
            wordSpacing: wordSpacing,
            paragraphSpacing: paragraphSpacing
        )

        // 创建属性字符串并设置属性
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(attributesDict, range: attributedString.fullNSRange)

        // 创建框架设置器
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)

        let path = CGMutablePath()
        // 2.5 是经验误差值
        path.addRect(CGRect(x: 0, y: 0, width: labelWidth - 2.5, height: CGFloat(MAXFLOAT)))
        let framef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        // 从框架设置器中获取行内容(Element == CTLine)
        let lines = CTFrameGetLines(framef) as NSArray

        var lineArr = [String]()
        // 获取每行内容
        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let lineString = text.sb.subString(from: lineRange.location, length: lineRange.length)
            lineArr.append(lineString as String)
        }
        return (lineArr.count, lineArr)
    }

    /// 修改`UILabel`行间距
    /// - Parameter lineSpacing:行间距大小
    func changeLineSpacing(_ lineSpacing: CGFloat) {
        guard let text = text, text.count > 0 else {
            return
        }
        // 已有属性列表
        if var attributes = attributedText?.attributes {
            // 已有段落样式
            if let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
                // 设置行间距
                style.lineSpacing = lineSpacing
                // 向属性列表中设置段落样式
                attributes[.paragraphStyle] = style
                return
            } else {
                // 无段落样式
                let style = NSMutableParagraphStyle.defaultStyle
                // 设置行间距
                style.lineSpacing = lineSpacing
                // 向属性列表中设置段落样式
                attributes[.paragraphStyle] = style
            }
            // 创建属性字符串
            let mAttributedString = NSMutableAttributedString(string: text)
            mAttributedString.addAttributes(attributes, for: text.sb.fullNSRange())
            attributedText = mAttributedString
            sizeToFit()
            return
        }
        // 无样式且无段落样式
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        // 创建属性字符串
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: style, range: text.sb.fullNSRange())
        attributedText = attributedString

        sizeToFit()
    }

    /// 修改`UILabel`字间距
    /// - Parameter wordSpacing:字间距大小
    func changeWordSpacing(_ wordSpacing: CGFloat) {
        guard let text = text, text.count > 0 else {
            return
        }

        // 已有属性列表
        if var attributes = attributedText?.attributes {
            attributes[.kern] = wordSpacing

            // 创建属性字符串
            let mAttributedString = NSMutableAttributedString(string: text)
            mAttributedString.addAttributes(attributes, for: text.sb.fullNSRange())
            attributedText = mAttributedString
            sizeToFit()
            return
        }
        // 创建属性字符串
        let attributedString = NSMutableAttributedString(string: text, attributes: [.kern: wordSpacing])
        attributedText = attributedString

        sizeToFit()
    }

    /// 改变`UILabel`行间距和字间距
    /// - Parameters:
    ///   - lineSpace:行间距
    ///   - wordSpace:字间距
    func changeSpacing(_ lineSpacing: CGFloat, wordSpacing: CGFloat) {
        changeLineSpacing(lineSpacing)
        changeWordSpacing(wordSpacing)
    }

    /// `UILabel`添加删除线
    /// - Parameters:
    ///   - lineValue:删除线的粗细
    ///   - lineColor:删除线的颜色
    func deleteLine(_ lineValue: Int = 1, lineColor: UIColor = .black) {
        guard let text = text, text.count > 0 else {
            return
        }

        // 已有属性列表
        if var attributes = attributedText?.attributes {
            attributes[.strikethroughStyle] = lineValue
            attributes[.strikethroughColor] = lineColor

            // 创建属性字符串
            let mAttributedString = NSMutableAttributedString(string: text)
            mAttributedString.addAttributes(attributes, for: text.sb.fullNSRange())
            attributedText = mAttributedString
            sizeToFit()
            return
        }
        // 创建属性字符串
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .strikethroughStyle: lineValue,
            .strikethroughColor: lineColor,
        ])
        attributedText = attributedString

        sizeToFit()
    }
}

// MARK: - 私有方法
private extension UILabel {
    /// 根据传入参数生成属性列表
    /// - Parameters:
    ///   - font:字体
    ///   - lineBreakMode:换行样式
    ///   - textAlignment:文本对齐
    ///   - lineSpacing:行间距
    ///   - wordSpacing:字间距
    ///   - paragraphSpacing:段落间距
    /// - Returns:` [NSAttributedString.Key :Any]`
    private static func attributeList(
        font: UIFont,
        lineBreakMode: NSLineBreakMode,
        textAlignment: NSTextAlignment,
        lineSpacing: CGFloat,
        wordSpacing: CGFloat,
        paragraphSpacing: CGFloat
    ) -> [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle.defaultStyle
            .lineBreakMode(lineBreakMode)
            .alignment(textAlignment)
            .lineSpacing(lineSpacing)
            .paragraphSpacing(paragraphSpacing)

        let attributeDict: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style,
            .kern: wordSpacing,
        ]
        return attributeDict
    }
}

// MARK: - 链式语法
public extension UILabel {
    /// 创建默认`UILabel`
    static var defaultLabel: UILabel {
        let label = UILabel()
        return label
    }

    /// 设置文字
    /// - Parameter text:文字内容
    /// - Returns:`Self`
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }

    /// 设置文字行数
    /// - Parameter lines:行数
    /// - Returns:`Self`
    @discardableResult
    func numberOfLines(_ lines: Int) -> Self {
        numberOfLines = lines
        return self
    }

    /// 设置换行模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        lineBreakMode = mode
        return self
    }

    /// 设置文字对齐方式
    /// - Parameter alignment:对齐方式
    /// - Returns:`Self`
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }

    /// 设置富文本文字
    /// - Parameter attributedText:富文本文字
    /// - Returns:`Self`
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置文本颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }

    /// 设置文本颜色(十六进制字符串)
    /// - Parameter hex:十六进制字符串
    /// - Returns:`Self`
    @discardableResult
    func textColor(_ hex: String) -> Self {
        textColor = UIColor(hex: hex)
        return self
    }

    /// 设置字体的大小
    /// - Parameter font:字体的大小
    /// - Returns:`Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 设置字体的大小
    /// - Parameter fontSize:字体的大小
    /// - Returns:`Self`
    @discardableResult
    func systemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    /// 设置字体的大小(粗体)
    /// - Parameter fontSize:字体的大小
    /// - Returns:`Self`
    @discardableResult
    func boldSystemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.boldSystemFont(ofSize: fontSize)
        return self
    }

    /// 设置特定范围的字体
    /// - Parameters:
    ///   - font:字体
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func setAttributedFont(_ font: UIFont, for range: NSRange) -> Self {
        let attribuedString = attributedText?.setFont(font, for: range)
        attributedText = attribuedString
        return self
    }

    /// 设置特定文字的字体
    /// - Parameters:
    ///   - font:字体
    ///   - text:要设置字体的文字
    /// - Returns:`Self`
    @discardableResult
    func setAttributedFont(_ font: UIFont, for text: String) -> Self {
        let attributedString = attributedText?.setFont(font, for: text)
        attributedText = attributedString
        return self
    }

    /// 设置特定区域的文字颜色
    /// - Parameters:
    ///   - color:文字颜色
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func setAttributedColor(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.setForegroundColor(color, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置特定文字的颜色
    /// - Parameters:
    ///   - color:文字颜色
    ///   - text:要设置颜色的文字
    /// - Returns:`Self`
    @discardableResult
    func setAttributedColor(_ color: UIColor, for text: String) -> Self {
        let attributedString = attributedText?.setForegroundColor(color, for: text)
        attributedText = attributedString
        return self
    }

    /// 设置行间距
    /// - Parameter spacing:行间距
    /// - Returns:`Self`
    @discardableResult
    func setAttributedLineSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.setLineSpacing(spacing, for: (text ?? "").sb.fullNSRange())
        attributedText = attributedString
        return self
    }

    /// 设置特定范围的下划线
    /// - Parameters:
    ///   - color:下划线颜色
    ///   - style:下划线样式
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func setAttributedUnderLine(_ color: UIColor, style: NSUnderlineStyle = .single, for range: NSRange) -> Self {
        let attributedString = attributedText?.setUnderline(color, stytle: style, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置特定文字的下划线
    /// - Parameters:
    ///   - color:下划线颜色
    ///   - style:下划线样式
    ///   - range:要设置下划线的文字
    /// - Returns:`Self`
    @discardableResult
    func setAttributedUnderLine(_ color: UIColor, style: NSUnderlineStyle = .single, for text: String) -> Self {
        let attributedString = attributedText?.setUnderline(color, stytle: style, for: text)
        attributedText = attributedString
        return self
    }

    /// 设置特定范围的删除线
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - range:范围
    @discardableResult
    func setAttributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.setDeleteline(color, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置特定文字的删除线
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - range:要设置删除线的文字
    @discardableResult
    func setAttributedDeleteLine(_ color: UIColor, for text: String) -> Self {
        let attributedString = attributedText?.setDeleteline(color, for: text)
        attributedText = attributedString
        return self
    }

    /// 设置首行缩进
    /// - Parameter indent:进度宽度
    /// - Returns:`Self`
    @discardableResult
    func setAttributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        let attributedString = attributedText?.setFirstLineHeadIndent(indent)
        attributedText = attributedString
        return self
    }

    /// 设置特定范围的倾斜
    /// - Parameters:
    ///   - inclination:倾斜度
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func setAttributedBliqueness(_ inclination: Float = 0, for range: NSRange) -> Self {
        let attributedString = attributedText?.setObliqueness(inclination, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置特定文字的倾斜
    /// - Parameters:
    ///   - inclination:倾斜度
    ///   - text:特定文字
    /// - Returns:`Self`
    @discardableResult
    func setAttributedBliqueness(_ inclination: Float = 0, for text: String) -> Self {
        let attributedString = attributedText?.setObliqueness(inclination, for: text)
        attributedText = attributedString
        return self
    }

    /// 插入图片
    /// - Parameters:
    ///   - imageSource:图片资源(图片名称/URL地址)
    ///   - imageBounds:图片的大小,默认为.zero,即自动根据图片大小设置,并以底部基线为标准. y > 0 :图片向上移动；y < 0 :图片向下移动
    ///   - imageIndex:图片的位置,默认放在开头
    /// - Returns:`Self`
    @discardableResult
    func insertAttributedImage(
        _ imageSource: String,
        imageBounds: CGRect = .zero,
        imageIndex: Int = 0
    ) -> Self {
        let attributedString = attributedText
        let mAttributedString = NSMutableAttributedString(attributedString: attributedString!)
        mAttributedString.insert(image: imageSource, bounds: imageBounds, index: imageIndex)
        attributedText = mAttributedString
        return self
    }

    /// 是否调整字体大小到适配宽度
    /// - Parameter adjusts:是否调整
    /// - Returns:`Self`
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        adjustsFontSizeToFitWidth = adjusts
        return self
    }
}
