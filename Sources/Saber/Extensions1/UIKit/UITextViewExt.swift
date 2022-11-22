import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static let placeholder: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
    static let placeholderLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
    static let placeholdFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
    static let placeholdColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
    static let placeholderOrigin: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDERORIGIN".hashValue)
}

// MARK: - 方法
public extension UITextView {
    /// 清空内容
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }

    /// 滚动到文本视图的底部
    func scrollToBottom() {
        let range = NSRange(location: (text as NSString).length - 1, length: 1)
        scrollRangeToVisible(range)
    }

    /// 滚动到文本视图的顶部
    func scrollToTop() {
        let range = NSRange(location: 0, length: 1)
        scrollRangeToVisible(range)
    }

    /// 调整大小到内容的大小
    func wrapToContent() {
        contentInset = .zero
        scrollIndicatorInsets = .zero
        contentOffset = .zero
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
    }

    /// 限制输入的字数
    /// `- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;`里面调用
    /// - Parameters:
    ///   - range:范围
    ///   - text:输入的文字
    ///   - maxCharacters:限制字数
    ///   - regex:可输入内容(正则)
    /// - Returns:返回是否可输入
    func inputRestrictions(shouldChangeTextIn range: NSRange, replacementText text: String, maxCharacters: Int, regex: String?) -> Bool {
        guard !text.isEmpty else {
            return true
        }

        guard let oldContent = self.text else {
            return false
        }

        if let _ = markedTextRange {
            // 有高亮
            if range.length == 0 {
                // 联想中
                return oldContent.count + 1 <= maxCharacters
            } else {
                // 正则的判断
                if let weakRegex = regex, !text.sb.isMatchRegexp(weakRegex) {
                    return false
                }

                // 联想选中键盘
                let allContent = oldContent.subString(to: range.location) + text
                if allContent.count > maxCharacters {
                    let newContent = allContent.subString(to: maxCharacters)
                    self.text = newContent
                    return false
                }
            }
        } else {
            guard !text.sb.isNineKeyBoard() else {
                return true
            }
            // 正则的判断
            if let weakRegex = regex, !text.sb.isMatchRegexp(weakRegex) {
                return false
            }
            // 如果数字大于指定位数,不能输入
            guard oldContent.count + text.count <= maxCharacters else {
                return false
            }
        }
        return true
    }

    /// 添加链接文本(链接为空时则表示普通文本)
    /// - Parameters:
    ///   - string:文本
    ///   - withURLString:链接
    func appendLinkString(string: String, font: UIFont, withURLString: String = "") {
        // 原来的文本内容
        let attrString = NSMutableAttributedString()
        attrString.append(attributedText)

        // 新增的文本内容(使用默认设置的字体样式)
        let attrs = [NSAttributedString.Key.font: font]
        let appendString = NSMutableAttributedString(string: string, attributes: attrs)
        // 判断是否是链接文字
        if withURLString != "" {
            let range = NSRange(location: 0, length: appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value: withURLString, range: range)
            appendString.endEditing()
        }
        // 合并新的文本
        attrString.append(appendString)
        // 设置合并后的文本
        attributedText = attrString
    }

    /// 转换特殊符号标签字段
    func resolveHashTags() {
        let nsText: NSString = text! as NSString
        // 使用默认设置的字体样式
        let attrs = [NSAttributedString.Key.font: font!]
        let attrString = NSMutableAttributedString(string: nsText as String, attributes: attrs)

        // 用来记录遍历字符串的索引位置
        var bookmark = 0
        // 用于拆分的特殊符号
        let charactersSet = CharacterSet(charactersIn: "@#")

        // 先将字符串按空格和分隔符拆分
        let sentences: [String] = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for sentence in sentences {
            // 如果是url链接则跳过
            if !sentence.sb.isURL() {
                // 再按特殊符号拆分
                let words: [String] = sentence.components(separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0 ..< words.count {
                    let word = words[i]
                    let keyword = chopOffNonAlphaNumericCharacters(word as String)
                    if keyword != "", i > 0 {
                        // 使用自定义的scheme来表示各种特殊链接,比如:mention:hangge
                        // 使得这些字段会变蓝色且可点击
                        // 匹配的范围
                        let remainingRangeLength = min(nsText.length - bookmark2 + 1, word.count + 2)
                        let remainingRange = NSRange(location: bookmark2 - 1, length: remainingRangeLength)
                        // print(keyword, bookmark2, remainingRangeLength)
                        // 获取转码后的关键字,用于url里的值
                        // (确保链接的正确性,比如url链接直接用中文就会有问题)
                        let encodeKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        // 匹配@某人
                        var matchRange = nsText.range(of: "@\(keyword)", options: .literal, range: remainingRange)
                        attrString.addAttribute(NSAttributedString.Key.link, value: "test1:\(encodeKeyword)", range: matchRange)
                        // 匹配#话题#
                        matchRange = nsText.range(of: "#\(keyword)#", options: .literal, range: remainingRange)
                        attrString.addAttribute(NSAttributedString.Key.link, value: "test2:\(encodeKeyword)", range: matchRange)
                        // attrString.addAttributes([NSAttributedString.Key.link :"test2:\(encodeKeyword)"], range:matchRange)
                    }
                    // 移动坐标索引记录
                    bookmark2 += word.count + 1
                }
            }
            // 移动坐标索引记录
            bookmark += sentence.count + 1
        }
        // print(nsText.length, bookmark)
        // 最终赋值
        attributedText = attrString
    }

    /// 过滤部多余的非数字和字符的部分
    /// - Parameter text:@hangge.123 -> @hangge
    /// - Returns:返回过滤后的字符串
    private func chopOffNonAlphaNumericCharacters(_ text: String) -> String {
        let nonAlphaNumericCharacters = CharacterSet.alphanumerics.inverted
        let characterArray = text.components(separatedBy: nonAlphaNumericCharacters)
        return characterArray[0]
    }
}

// MARK: - 占位符(使用runtime添加属性)
public extension UITextView {
    /// 设置占位符
    var placeholder: String? {
        set {
            objc_setAssociatedObject(self, AssociateKeys.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initPlaceholder(placeholder!)
        }
        get {
            return objc_getAssociatedObject(self, AssociateKeys.placeholder) as? String
        }
    }

    /// 占位文本字体
    var placeholderFont: UIFont? {
        set {
            objc_setAssociatedObject(self, AssociateKeys.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if placeholderLabel != nil {
                placeholderLabel?.font = placeholderFont
                constraintPlaceholder()
            }
        }
        get {
            return objc_getAssociatedObject(self, AssociateKeys.placeholdFont) as? UIFont == nil ? UIFont.systemFont(ofSize: 13) : objc_getAssociatedObject(self, AssociateKeys.placeholdFont) as? UIFont
        }
    }

    /// 占位文本的颜色
    var placeholderColor: UIColor? {
        set {
            objc_setAssociatedObject(self, AssociateKeys.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if placeholderLabel != nil {
                placeholderLabel?.textColor = placeholderColor
            }
        }
        get {
            return objc_getAssociatedObject(self, AssociateKeys.placeholdColor) as? UIColor == nil ? UIColor.lightGray : objc_getAssociatedObject(self, AssociateKeys.placeholdColor) as? UIColor
        }
    }

    /// 设置占位文本的`Origin`
    var placeholderOrigin: CGPoint? {
        set {
            objc_setAssociatedObject(self, AssociateKeys.placeholderOrigin, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if placeholderLabel != nil, placeholderOrigin != nil {
                placeholderLabel?.frame.origin = placeholderOrigin!
            }
        }
        get {
            return objc_getAssociatedObject(self, AssociateKeys.placeholderOrigin) as? CGPoint == nil ? CGPoint(x: 7, y: 7) : objc_getAssociatedObject(self, AssociateKeys.placeholderOrigin) as? CGPoint
        }
    }
}

// MARK: - 私有(占位符)
private extension UITextView {
    /// 默认文本
    var placeholderLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, AssociateKeys.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, AssociateKeys.placeholderLabel) as? UILabel
        }
    }

    /// 占位符
    /// - Parameter placeholder:占位符
    func initPlaceholder(_ placeholder: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: UITextView.textDidChangeNotification, object: self)

        let font = placeholderFont ?? .systemFont(ofSize: 14)
        let label = UILabel.defaultLabel
            .text(placeholder)
            .font(font)
            .textColor(placeholderColor ?? .gray)
            .numberOfLines(0)
        addSubview(label)
        placeholderLabel = label
        placeholderLabel?.isHidden = text.count > 0 ? true : false

        constraintPlaceholder()
    }

    func constraintPlaceholder() {
        guard let placeholderLabel = placeholderLabel else {
            return
        }

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        let placeholderSize = placeholderLabel.textSize()
        addConstraints([
            NSLayoutConstraint(item: placeholderLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: placeholderSize.width),
            NSLayoutConstraint(item: placeholderLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: placeholderSize.height),
            NSLayoutConstraint(item: placeholderLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: textContainer.lineFragmentPadding),
            NSLayoutConstraint(item: placeholderLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
        ])
    }

    /// 动态监听
    /// - Parameter notification:动态监听
    @objc func textChange(_ notification: Notification) {
        let textView = notification.object as! UITextView
        if placeholder != nil {
            placeholderLabel?.isHidden = textView.text.count > 0
        }
    }
}

// MARK: - 链式语法
public extension UITextView {
    /// 创建默认`UITextView`
    static var defaultTextView: UITextView {
        let textView = UITextView()
        return textView
    }

    /// 设置文字
    /// - Parameter text:文字
    /// - Returns:`Self`
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本
    /// - Parameter attributedText:富文本文字
    /// - Returns:`Self`
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置文本格式
    /// - Parameter textAlignment:文本格式
    /// - Returns:`Self`
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color:文本颜色
    /// - Returns:`Self`
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
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

    /// 设置文本字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 设置系统字体
    /// - Parameter fontSize:字体大小
    /// - Returns:`Self`
    @discardableResult
    func systemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    /// 设置代理
    /// - Parameter delegate:代理
    /// - Returns:`Self`
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter keyboardType:键盘样式
    /// - Returns:`Self`
    @discardableResult
    func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }

    /// 设置键盘`return`键类型
    /// - Parameter returnKeyType:按钮样式
    /// - Returns:`Self`
    @discardableResult
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }

    /// 设置`Return`键是否有内容才可以点击
    /// - Parameter enable:是否开启
    /// - Returns:`Self`
    func enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        enablesReturnKeyAutomatically = enable
        return self
    }

    /// 设置占位符
    /// - Parameter placeholder:占位符文字
    /// - Returns:`Self`
    func placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }

    /// 设置占位符颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    func placeholderTextColor(_ textColor: UIColor) -> Self {
        placeholderColor = textColor
        return self
    }

    /// 设置占位符字体
    /// - Parameter font:文字字体
    /// - Returns:`Self`
    func placeholderFont(_ font: UIFont) -> Self {
        placeholderFont = font
        return self
    }

    /// 设置占位符`Origin`
    /// - Parameter origin:`CGPoint`
    /// - Returns:`Self`
    func placeholderOrigin(_ origin: CGPoint) -> Self {
        placeholderOrigin = origin
        return self
    }
}
