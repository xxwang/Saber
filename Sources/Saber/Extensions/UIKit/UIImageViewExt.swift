import Kingfisher
import UIKit

// MARK: - 方法
public extension UIImageView {
    /// 添加模糊效果
    /// - Parameter style: 模糊效果的样式
    func blur(with style: UIBlurEffect.Style = .light) {
        // 模糊效果
        let blurEffect = UIBlurEffect(style: style)
        // 效果View
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // 设置效果view的尺寸
        blurEffectView.frame = bounds
        // 支持设备旋转
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 添加效果到图片
        addSubview(blurEffectView)
    }

    /// 添加模糊效果并返回`UIImageView`
    /// - Parameter style: 模糊效果的样式 (默认 .light)
    /// - Returns: 添加了模糊效果的UIImageView
    func blurred(with style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = self
        imgView.blur(with: style)
        return imgView
    }

    /// 修改图像的颜色
    /// - Parameter color: 要修改成的颜色
    func image(with color: UIColor) {
        /*
         .automatic = 0 // 根据图片的使用环境和所处的绘图上下文自动调整渲染模式.
         .alwaysOriginal = 1 // 始终绘制图片原始状态,不使用Tint Color.
         .alwaysTemplate = 2 // 始终根据Tint Color绘制图片,忽略图片的颜色信息.
         */
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
}

// MARK: - 加载图片
public extension UIImageView {
    /// 从`URL`下载网络图片并设置到`UIImageView`
    /// - Parameters:
    ///   - url: 图片URL地址
    ///   - contentMode: 图片视图内容模式
    ///   - placeholder: 占位图片
    ///   - completionHandler: 完成回调
    func download(
        form url: URL,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        placeholder: UIImage? = nil,
        completionHandler: ((UIImage?) -> Void)? = nil
    ) {
        image = placeholder
        self.contentMode = contentMode

        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
            else {
                completionHandler?(nil)
                return
            }

            DispatchQueue.mainAsync {
                self.image = image
                completionHandler?(image)
            }
        }.resume()
    }

    /// 加载网络图片(`Kingfisher`框架)
    /// - Parameters:
    ///   - url: 图片`URL`地址(URL/字符串都可以)
    ///   - placeholder: 占位图片
    ///   - fail: 失败图片
    func loadImage(
        _ source: Any?,
        placeholder: UIImage? = nil,
        fail: UIImage? = nil
    ) {
        // 设置占位图片
        if let placeholder = placeholder {
            image = placeholder
        }

        // 检查资源是否为空
        guard let source = source else {
            image = fail ?? placeholder
            return
        }

        // 图片
        if let image = source as? UIImage {
            self.image = image
            return
        }

        var imageURL: URL?
        if let string = source as? String { // 字符串
            if !string.hasPrefix("http://"), !string.hasPrefix("https://") {
                image = string.image ?? (fail ?? placeholder)
                return
            } else {
                imageURL = URL(string: string)
            }
        } else if let sourceURL = source as? URL { // URL
            imageURL = sourceURL
        } else { // 非法资源
            image = fail ?? placeholder
            return
        }

        guard let imageURL = imageURL, imageURL.isValid else {
            image = fail ?? placeholder
            return
        }

        // 加载指示器
        kf.indicatorType = .activity
        let options: KingfisherOptionsInfo = [
            .scaleFactor(UIScreen.screenScale),
            .transition(.fade(1)),
            .cacheOriginalImage,
        ]
        kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: options
        ) { result in
            switch result {
            //                case let .success:(value):
            case .success:
                //                Debug.Info("图片加载成功!\(value)")
                break
            case let .failure(error):
                Debug.Error("图片加载失败!\n地址: \(imageURL.absoluteString)\n错误: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Gif
public extension UIImageView {
    /// 加载本地`Gif`图片的名称
    /// - Parameter name: 图片名称
    func loadGif(imageNamed: String) {
        DispatchQueue.globalAsync {
            let image = UIImage.gif(name: imageNamed)
            DispatchQueue.mainAsync {
                self.image = image
            }
        }
    }

    /// 加载`Asset`中的`Gif`图片
    /// - Parameter asset: `asset`中的图片名称
    func loadGif(asset: String) {
        DispatchQueue.globalAsync {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.mainAsync {
                self.image = image
            }
        }
    }

    /// 加载网络`URL`的`Gif`图片
    /// - Parameter url: `Gif`图片URL地址
    @available(iOS 9.0, *)
    func loadGif(url: String) {
        DispatchQueue.globalAsync {
            let image = UIImage.gif(url: url)
            DispatchQueue.mainAsync {
                self.image = image
            }
        }
    }
}

// MARK: - 链式语法
public extension UIImageView {
    /// 创建默认`UIImageView`
    static var defaultImageView: UIImageView {
        let imageView = UIImageView()
        return imageView
    }

    /// 设置图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置图片
    /// - Parameter imageNamed: 图片名称
    /// - Returns: `Self`
    @discardableResult
    func image(_ imageNamed: String) -> Self {
        image = UIImage(named: imageNamed)
        return self
    }

    /// 设置模糊效果
    /// - Parameter style: 模糊效果样式
    /// - Returns: `Self`
    @discardableResult
    func blur(_ style: UIBlurEffect.Style = .light) -> Self {
        blur(with: style)
        return self
    }
}
