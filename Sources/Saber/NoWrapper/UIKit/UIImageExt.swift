import AVFoundation
import CoreImage
import Dispatch
import Photos
import UIKit

// MARK: - 属性
public extension UIImage {
    /// `UIImage`的大小(单位:bytes/字节)
    var bytesSize: Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }

    /// `UIImage`的大小(单位:`KB`)
    var kilobytesSize: Int {
        return (jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }

    /// 获取原始渲染模式下的图片
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }

    /// 获取模板渲染模式下的图片
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - 构造方法
public extension UIImage {
    /// 根据颜色和大小创建UIImage
    /// - Parameters:
    ///   - color:图像填充颜色
    ///   - size:图像尺寸
    convenience init(_ color: UIColor, size: CGSize = .init(value: 1)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }

    /// 从Base64字符串创建新图像
    ///
    /// - Parameters:
    ///   - base64String:一个表示图像的base64字符串
    ///   - scale:从base64字符串创建的图像数据时要采用的比例因子.1.0的比例因子会生成大小与基于像素的图像尺寸匹配的图像.应用不同的比例因子会更改“size”属性报告的图像大小
    convenience init?(base64String: String, scale: CGFloat = 1.0) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data, scale: scale)
    }

    /// 从URL创建新图像
    ///
    /// - Important:
    ///   使用此方法将data://URL转换为UIImage对象
    ///   不要使用此同步初始值设定项来请求基于网络的URL.对于基于网络的URL,此方法可以在慢速网络上阻止当前线程数十秒,导致用户体验不佳,在iOS中,可能会导致应用程序终止
    ///   而对于非文件URL,请考虑使用异步方式,使用`dataTask(with:completionHandler:)` 方法或诸如`AlamofireImage`, `Kingfisher`, `SDWebImage`等库来执行异步网络图像加载
    /// - Parameters:
    ///   - url:表示图像位置
    ///   - scale:从URL创建的图像数据时,要采用的比例因子.应用1.0的比例因子会生成大小与基于像素的图像尺寸匹配的图像.应用不同的比例因子会更改“size”属性报告的图像大小
    convenience init?(url: URL, scale: CGFloat = 1.0) throws {
        let data = try Data(contentsOf: url)
        self.init(data: data, scale: scale)
    }

    /// 用同样的图片名称创建`高亮`和`暗调`模式图片
    /// - Parameter imageName:图片名称
    convenience init(imageName: String) {
        self.init(imageName, darkImageName: imageName)
    }

    /// 用不同的图片名称创建动态图片
    /// - Parameters:
    ///   - lightImageName:高亮图片名称
    ///   - darkImageName:暗调图片名称
    convenience init(_ lightImageName: String, darkImageName: String) {
        self.init(lightImageName.sb.toImage(), darkImage: darkImageName.sb.toImage())
    }

    /// 用不同的图片创建动态图片
    /// - Parameters:
    ///   - lightImage:高亮图片
    ///   - darkImage:暗调图片
    convenience init(_ lightImage: UIImage?, darkImage: UIImage?) {
        if #available(iOS 13.0, *) {
            guard
                let weakLightImage = lightImage,
                let weakDarkImage = darkImage,
                let config = weakLightImage.configuration
            else {
                self.init()
                return
            }
            let lightImage = weakLightImage.withConfiguration(config.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
            lightImage.imageAsset?.register(weakDarkImage, with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.dark)))
            let result = lightImage.imageAsset?.image(with: .current) ?? lightImage
            self.init(cgImage: result.cgImage!)
        } else {
            self.init(cgImage: lightImage!.cgImage!)
        }
    }
}

// MARK: - 方法
public extension UIImage {
    /// 图像的平均颜色
    func averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }

        // CIAreaAverage返回包含给定图像区域平均颜色的单像素图像
        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        // 从过滤器中获取单像素图像后,提取像素的RGBA8数据
        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // 将像素数据转换为UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }

    /// 压缩图片大小(返回`UIImage`)
    /// - Parameter quality:生成的`JPEG`图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)(默认值为0.5)
    /// - Returns:压缩后的可选`UIImage`
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }

    /// 压缩`UIImage`并生成`Data`(返回`UIImage`的`Data`)
    ///
    /// - Parameter quality:生成的`JPEG`图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)(默认值为0.5)
    /// - Returns:压缩后的可选Data
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return jpegData(compressionQuality: quality)
    }

    /// 把`UIImage`裁剪为指定`CGRect`大小
    ///
    /// - Parameter rect:目标`CGRect`
    /// - Returns:裁剪后的`UIImage`
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width, rect.size.height <= size.height else { return self }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    /// 等比例把`UIImage`缩放至指定高度
    ///
    /// - Parameters:
    ///   - toHeight:新高度
    ///   - opaque:是否不透明
    /// - Returns:缩放后的`UIImage`(可选)
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 等比例把`UIImage`缩放至指定宽度
    ///
    /// - Parameters:
    ///   - toWidth:新宽度
    ///   - opaque:是否不透明
    /// - Returns:缩放后的`UIImage`(可选)
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 创建按给定角度旋转的图片
    ///
    ///     // 将图像旋转180°
    ///     image.rotated(by:Measurement(value:180, unit:.degrees))
    ///
    /// - Parameter angle:旋转(按:测量值(值:180,单位:度))
    /// - Returns:按给定角度旋转的新图像
    @available(tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)

        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 创建按给定角度(弧度)旋转的图片
    ///
    ///     // 将图像旋转180°
    ///     image.rotated(by:.pi)
    ///
    /// - Parameter radians:旋转图像的角度(以弧度为单位)
    /// - Returns:按给定角度旋转的新图像
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// `UIImage`充满颜色
    ///
    /// - Parameter color:填充图像的颜色
    /// - Returns:用给定颜色填充的`UIImage`
    func filled(withColor color: UIColor) -> UIImage {
        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                let renderer = UIGraphicsImageRenderer(size: size, format: format)
                return renderer.image { context in
                    color.setFill()
                    context.fill(CGRect(origin: .zero, size: size))
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 指定颜色为`UIImage`着色
    ///
    /// - Parameters:
    ///   - color:为图像着色的颜色
    ///   - blendMode:混合模式
    ///   - alpha:用于绘制的`alpha`值
    /// - Returns:使用给定颜色着色的`UIImage`
    func tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
        let drawRect = CGRect(origin: .zero, size: size)

        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                return UIGraphicsImageRenderer(size: size, format: format).image { context in
                    color.setFill()
                    context.fill(drawRect)
                    draw(in: drawRect, blendMode: blendMode, alpha: alpha)
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// 带背景色的`UImage`
    ///
    /// - Parameters:
    ///   - backgroundColor:用作背景色的颜色
    /// - Returns:带背景色的`UImage`
    func withBackgroundColor(_ backgroundColor: UIColor) -> UIImage {
        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                return UIGraphicsImageRenderer(size: size, format: format).image { context in
                    backgroundColor.setFill()
                    context.fill(context.format.bounds)
                    draw(at: .zero)
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }

        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        draw(at: .zero)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// 带圆角的`UIImage`
    ///
    /// - Parameters:
    ///   - radius:角半径(可选),如果未指定,结果图像将为圆形
    /// - Returns:带圆角的`UIImage`
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0, radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 图像的`Base64`编码`PNG`数据字符串
    ///
    /// - Returns:以字符串形式返回图像的`Base` 64编码`PNG`数据
    func pngBase64String() -> String? {
        return pngData()?.base64EncodedString()
    }

    /// 图像的`Base64`编码`JPEG`数据字符串
    /// - Parameter compressionQuality:生成的JPEG图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)
    /// - Returns:以字符串形式返回图像的基本64编码JPEG数据
    func jpegBase64String(compressionQuality: CGFloat) -> String? {
        return jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
    }

    /// 以原始渲染模式为`UIImage`着色
    ///
    /// - Parameters:
    ///   - color:图像的颜色
    /// - Returns:着色的`UIImage`
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func withAlwaysOriginalTintColor(_ color: UIColor) -> UIImage {
        return withTintColor(color, renderingMode: .alwaysOriginal)
    }

    /// 获取图片大小
    /// - Parameters:
    ///   - url:图片地址
    ///   - max:最大边长度
    static func imageSize(_ url: URL?, max: CGFloat? = nil) -> CGSize {
        guard let url = url,
              let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
              let result = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any],
              let width = result["PixelWidth"] as? CGFloat,
              let height = result["PixelHeight"] as? CGFloat
        else {
            return .zero
        }

        var size = CGSize(width: width, height: height)

        guard let relative = max else {
            return size
        }
        if size.height > size.width {
            size.width = size.width / size.height * relative
            size.height = relative
        } else {
            size.height = size.height / size.width * relative
            size.width = relative
        }
        return size
    }

    /// 获取视频的第一帧
    /// - Parameters:
    ///   - videoURL:视频 url
    ///   - maximumSize:图片的最大尺寸
    /// - Returns:视频的第一帧
    static func getVideoFirstImage(videoURL: String, maximumSize: CGSize = CGSize(width: 1000, height: 1000), closure: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: videoURL) else {
            closure(nil)
            return
        }
        DispatchQueue.global().async {
            let opts = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
            let avAsset = AVURLAsset(url: url, options: opts)
            let generator = AVAssetImageGenerator(asset: avAsset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = maximumSize
            var cgImage: CGImage?
            let time = CMTimeMake(value: 0, timescale: 600)
            var actualTime: CMTime = CMTimeMake(value: 0, timescale: 0)
            do {
                try cgImage = generator.copyCGImage(at: time, actualTime: &actualTime)
            } catch {
                DispatchQueue.main.async {
                    closure(nil)
                }
                return
            }
            guard let image = cgImage else {
                DispatchQueue.main.async {
                    closure(nil)
                }
                return
            }
            DispatchQueue.main.async {
                closure(UIImage(cgImage: image))
            }
        }
    }

    /// layer 转 image
    /// - Parameters:
    ///   - layer:layer 对象
    ///   - scale:缩放比例
    /// - Returns:返回转化后的 image
    static func image(from layer: CALayer, scale: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

    /// 设置图片透明度
    /// alpha:透明度
    /// - Returns:newImage
    func imageByApplayingAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }

    /// 裁剪给定区域
    /// - Parameter crop:裁剪区域
    /// - Returns:剪裁后的图片
    func cropWithCropRect(_ crop: CGRect) -> UIImage? {
        let cropRect = CGRect(x: crop.origin.x * scale, y: crop.origin.y * scale, width: crop.size.width * scale, height: crop.size.height * scale)
        if cropRect.size.width <= 0 || cropRect.size.height <= 0 {
            return nil
        }
        var image: UIImage?
        autoreleasepool {
            let imageRef: CGImage? = self.cgImage!.cropping(to: cropRect)
            if let imageRef = imageRef {
                image = UIImage(cgImage: imageRef)
            }
        }
        return image
    }

    /// 图片的模糊效果(高斯模糊滤镜)
    /// - Parameter fuzzyValue:设置模糊半径值(越大越模糊)
    /// - Returns:返回模糊后的图片
    func getGaussianBlurImage(fuzzyValue: CGFloat = 20) -> UIImage? {
        // 生成的高斯模糊滤镜图片
        return blurredPicture(fuzzyValue: fuzzyValue, filterName: "CIGaussianBlur")
    }

    /// 像素化后的图片
    /// - Parameter fuzzyValue:设置模糊半径值(越大越模糊)
    /// - Returns:返回像素化后的图片
    func getPixellateImage(fuzzyValue: CGFloat = 20) -> UIImage? {
        // 生成的高斯模糊滤镜图片
        return blurredPicture(fuzzyValue: fuzzyValue, filterName: "CIPixellate")
    }

    /// 图片模糊
    /// - Parameters:
    ///   - fuzzyValue:设置模糊半径值(越大越模糊)
    ///   - filterName:模糊类型
    /// - Returns:返回模糊后的图片
    private func blurredPicture(fuzzyValue: CGFloat, filterName: String) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        // 创建高斯模糊滤镜类
        guard let blurFilter = CIFilter(name: filterName) else { return nil }
        // 设置图片
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        // 设置模糊半径值(越大越模糊)
        blurFilter.setValue(fuzzyValue, forKey: filterName == "CIPixellate" ? kCIInputScaleKey : kCIInputRadiusKey)
        // 从滤镜中 取出图片
        guard let outputImage = blurFilter.outputImage else { return nil }
        // 创建上下文
        let context = CIContext(options: nil)
        // 根据滤镜中的图片 创建CGImage
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        // 生成的模糊图片
        return UIImage(cgImage: cgImage)
    }

    /// 返回一个将白色背景变透明的UIImage
    /// - Returns:白色背景变透明的UIImage
    func imageByRemoveWhiteBg() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return transparentColor(colorMasking: colorMasking)
    }

    /// 返回一个将黑色背景变透明的UIImage
    /// - Returns:黑色背景变透明的UIImage
    func imageByRemoveBlackBg() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return transparentColor(colorMasking: colorMasking)
    }

    private func transparentColor(colorMasking: [CGFloat]) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        guard let rawImageRef = cgImage, let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) else {
            return nil
        }
        UIGraphicsBeginImageContext(size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.translateBy(x: 0.0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        return result
    }
}

// MARK: - 图片旋转的一些操作
public extension UIImage {
    /// 图片旋转 (角度)
    /// - Parameter degree:角度 0 -- 360
    /// - Returns:旋转后的图片
    func imageRotated(degree: CGFloat) -> UIImage? {
        let radians = Double(degree) / 180 * Double.pi
        return imageRotated(radians: CGFloat(radians))
    }

    /// 图片旋转 (弧度)
    /// - Parameter radians:弧度 0 -- 2π
    /// - Returns:旋转后的图片
    func imageRotated(radians: CGFloat) -> UIImage? {
        guard let weakCGImage = cgImage else {
            return nil
        }
        let rotateViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let transform = CGAffineTransform(rotationAngle: radians)
        rotateViewBox.transform = transform
        UIGraphicsBeginImageContext(rotateViewBox.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.translateBy(x: rotateViewBox.frame.width / 2, y: rotateViewBox.frame.height / 2)
        context.rotate(by: radians)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        context.draw(weakCGImage, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 水平翻转
    /// - Returns:返回水平翻转的图片
    func flipHorizontal() -> UIImage? {
        return rotate(orientation: .upMirrored)
    }

    /// 垂直翻转
    /// - Returns:返回垂直翻转的图片
    func flipVertical() -> UIImage? {
        return rotate(orientation: .downMirrored)
    }

    /// 向下翻转
    /// - Returns:向下翻转后的图片
    func flipDown() -> UIImage? {
        return rotate(orientation: .down)
    }

    /// 向左翻转
    /// - Returns:向左翻转后的图片
    func flipLeft() -> UIImage? {
        return rotate(orientation: .left)
    }

    /// 镜像向左翻转
    /// - Returns:镜像向左翻转后的图片
    func flipLeftMirrored() -> UIImage? {
        return rotate(orientation: .leftMirrored)
    }

    /// 向右翻转
    /// - Returns:向右翻转后的图片
    func flipRight() -> UIImage? {
        return rotate(orientation: .right)
    }

    /// 镜像向右翻转
    /// - Returns:镜像向右翻转后的图片
    func flipRightMirrored() -> UIImage? {
        return rotate(orientation: .rightMirrored)
    }

    /// 图片平铺区域
    /// - Parameter size:平铺区域的大小
    /// - Returns:平铺后的图片
    func imageTile(size: CGSize) -> UIImage? {
        let tempView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        tempView.backgroundColor = UIColor(patternImage: self)
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        tempView.layer.render(in: context)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return bgImage
    }

    /// 图片翻转(base)
    /// - Parameter orientation:翻转类型
    /// - Returns:翻转后的图片
    private func rotate(orientation: UIImage.Orientation) -> UIImage? {
        guard let imageRef = cgImage else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: imageRef.width, height: imageRef.height)
        var bounds = rect
        var transform = CGAffineTransform.identity

        switch orientation {
        case .up:
            return self
        case .upMirrored:
            // 图片左平移width个像素
            transform = CGAffineTransform(translationX: rect.size.width, y: 0)
            // 缩放
            transform = transform.scaledBy(x: -1, y: 1)
        case .down:
            transform = CGAffineTransform(translationX: rect.size.width, y: rect.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: rect.size.height)
            transform = transform.scaledBy(x: 1, y: -1)
        case .left:
            swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: 0, y: rect.size.width)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .leftMirrored:
            swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: rect.size.height, y: rect.size.width)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .right:
            swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: rect.size.height, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .rightMirrored:
            swapWidthAndHeight(rect: &bounds)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        default:
            return nil
        }

        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        // 图片绘制时进行图片修正
        switch orientation {
        case .left:
            fallthrough
        case .leftMirrored:
            fallthrough
        case .right:
            fallthrough
        case .rightMirrored:
            context.scaleBy(x: -1.0, y: 1.0)
            context.translateBy(x: -bounds.size.width, y: 0.0)
        default:
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0.0, y: -rect.size.height)
        }
        context.concatenate(transform)
        context.draw(imageRef, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 交换宽高
    /// - Parameter rect:image 的 frame
    private func swapWidthAndHeight(rect: inout CGRect) {
        let swap = rect.size.width
        rect.size.width = rect.size.height
        rect.size.height = swap
    }
}

/*
 Core Image 是一个强大的滤镜处理框架.它除了可以直接给图片添加各种内置滤镜,还能精确地修改鲜艳程度, 色泽, 曝光等,下面通过两个样例演示如何给 UIImage 添加滤镜
 */
// MARK: - 给图片添加滤镜效果(棕褐色老照片滤镜,黑白滤镜)
public extension UIImage {
    /// 滤镜类型
    enum CMImageFilterType: String {
        /// 棕褐色复古滤镜(老照片效果),有点复古老照片发黄的效果)
        case CISepiaTone
        /// 黑白效果滤镜
        case CIPhotoEffectNoir
    }

    /// 图片加滤镜
    /// - Parameters:
    ///   - filterType:滤镜类型
    ///   - alpha:透明度
    /// - Returns:添加滤镜后的图片
    func filter(filterType: CMImageFilterType, alpha: CGFloat?) -> UIImage? {
        guard let imageData = pngData() else {
            return nil
        }
        let inputImage = CoreImage.CIImage(data: imageData)
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: filterType.rawValue) else {
            return nil
        }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if alpha != nil {
            filter.setValue(alpha, forKey: "inputIntensity")
        }
        guard let outputImage = filter.outputImage, let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: outImage)
    }

    /// 全图马赛克
    /// - Parameter value:值越大马赛克就越大(使用默认)
    /// - Returns:全图马赛克的图片
    func pixAll(value: Int? = nil) -> UIImage? {
        guard let filter = CIFilter(name: "CIPixellate") else {
            return nil
        }
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if value != nil {
            // 值越大马赛克就越大(使用默认)
            filter.setValue(value, forKey: kCIInputScaleKey)
        }
        let fullPixellatedImage = filter.outputImage
        let cgImage = context.createCGImage(fullPixellatedImage!, from: fullPixellatedImage!.extent)
        return UIImage(cgImage: cgImage!)
    }

    // 检测人脸的frame
    func detectFace() -> [CGRect]? {
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
        let context = CIContext(options: nil)
        // 人脸检测器
        // CIDetectorAccuracyHigh:检测的精度高,但速度更慢些
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: context,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var faceFeatures: [CIFaceFeature]!
        // 人脸检测需要图片方向(有元数据的话使用元数据,没有就调用featuresInImage)
        if let orientation = inputImage.properties[kCGImagePropertyOrientation as String] {
            faceFeatures = (detector!.features(in: inputImage, options: [CIDetectorImageOrientation: orientation]) as! [CIFaceFeature])
        } else {
            faceFeatures = (detector!.features(in: inputImage) as! [CIFaceFeature])
        }
        // 打印所有的面部特征
        // print(faceFeatures)
        let inputImageSize = inputImage.extent.size
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -inputImageSize.height)

        // 人脸位置的frame
        var rects: [CGRect] = []
        // 遍历所有的面部,并框出
        for faceFeature in faceFeatures {
            let faceViewBounds = faceFeature.bounds.applying(transform)
            rects.append(faceViewBounds)
        }
        return rects
    }

    /// 检测人脸并打马赛克
    /// - Returns:打马赛克后的人脸
    func detectAndPixFace() -> UIImage? {
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
        let context = CIContext(options: nil)

        // 用CIPixellate滤镜对原图先做个完全马赛克
        let filter = CIFilter(name: "CIPixellate")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let inputScale = max(inputImage.extent.size.width, inputImage.extent.size.height) / 80
        filter.setValue(inputScale, forKey: kCIInputScaleKey)
        let fullPixellatedImage = filter.outputImage
        // 检测人脸,并保存在faceFeatures中
        guard let detector = CIDetector(ofType: CIDetectorTypeFace,
                                        context: context,
                                        options: nil)
        else {
            return nil
        }
        let faceFeatures = detector.features(in: inputImage)
        // 初始化蒙版图,并开始遍历检测到的所有人脸
        var maskImage: CIImage!
        for faceFeature in faceFeatures {
            // 基于人脸的位置,为每一张脸都单独创建一个蒙版,所以要先计算出脸的中心点,对应为x、y轴坐标,
            // 再基于脸的宽度或高度给一个半径,最后用这些计算结果初始化一个CIRadialGradient滤镜
            let centerX = faceFeature.bounds.origin.x + faceFeature.bounds.size.width / 2
            let centerY = faceFeature.bounds.origin.y + faceFeature.bounds.size.height / 2
            let radius = min(faceFeature.bounds.size.width, faceFeature.bounds.size.height)
            guard let radialGradient = CIFilter(name: "CIRadialGradient",
                                                parameters: [
                                                    "inputRadius0": radius,
                                                    "inputRadius1": radius + 1,
                                                    "inputColor0": CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                                    "inputColor1": CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                                    kCIInputCenterKey: CIVector(x: centerX, y: centerY),
                                                ])
            else {
                return nil
            }
            // 由于CIRadialGradient滤镜创建的是一张无限大小的图,所以在使用之前先对它进行裁剪
            let radialGradientOutputImage = radialGradient.outputImage!.cropped(to: inputImage.extent)
            if maskImage == nil {
                maskImage = radialGradientOutputImage
            } else {
                maskImage = CIFilter(name: "CISourceOverCompositing",
                                     parameters: [
                                         kCIInputImageKey: radialGradientOutputImage,
                                         kCIInputBackgroundImageKey: maskImage as Any,
                                     ])!.outputImage
            }
        }
        // 用CIBlendWithMask滤镜把马赛克图、原图、蒙版图混合起来
        let blendFilter = CIFilter(name: "CIBlendWithMask")!
        blendFilter.setValue(fullPixellatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
        // 输出,在界面上显示
        guard let blendOutputImage = blendFilter.outputImage, let blendCGImage = context.createCGImage(blendOutputImage, from: blendOutputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: blendCGImage)
    }
}

// MARK: - 压缩模式
public enum CompressionMode {
    /// 分辨率规则
    private static let resolutionRule: (min: CGFloat, max: CGFloat, low: CGFloat, default: CGFloat, high: CGFloat) = (10, 4096, 512, 1024, 2048)
    /// 数据大小规则
    private static let dataSizeRule: (min: Int, max: Int, low: Int, default: Int, high: Int) = (1024 * 10, 1024 * 1024 * 20, 1024 * 512, 1024 * 1024 * 2, 1024 * 1024 * 10)
    // 低质量
    case low
    // 中等质量 默认
    case medium
    // 高质量
    case high
    // 自定义(最大分辨率, 最大输出数据大小)
    case other(CGFloat, Int)

    fileprivate var maxDataSize: Int {
        switch self {
        case .low:
            return CompressionMode.dataSizeRule.low
        case .medium:
            return CompressionMode.dataSizeRule.default
        case .high:
            return CompressionMode.dataSizeRule.high
        case let .other(_, dataSize):
            if dataSize < CompressionMode.dataSizeRule.min {
                return CompressionMode.dataSizeRule.default
            }
            if dataSize > CompressionMode.dataSizeRule.max {
                return CompressionMode.dataSizeRule.max
            }
            return dataSize
        }
    }

    fileprivate func resize(_ size: CGSize) -> CGSize {
        if size.width < CompressionMode.resolutionRule.min || size.height < CompressionMode.resolutionRule.min {
            return size
        }
        let maxResolution = maxSize
        let aspectRatio = max(size.width, size.height) / maxResolution
        if aspectRatio <= 1.0 {
            return size
        } else {
            let resizeWidth = size.width / aspectRatio
            let resizeHeighth = size.height / aspectRatio
            if resizeHeighth < CompressionMode.resolutionRule.min || resizeWidth < CompressionMode.resolutionRule.min {
                return size
            } else {
                return CGSize(width: resizeWidth, height: resizeHeighth)
            }
        }
    }

    fileprivate var maxSize: CGFloat {
        switch self {
        case .low:
            return CompressionMode.resolutionRule.low
        case .medium:
            return CompressionMode.resolutionRule.default
        case .high:
            return CompressionMode.resolutionRule.high
        case let .other(size, _):
            if size < CompressionMode.resolutionRule.min {
                return CompressionMode.resolutionRule.default
            }
            if size > CompressionMode.resolutionRule.max {
                return CompressionMode.resolutionRule.max
            }
            return size
        }
    }
}

// MARK: - UIImage 压缩相关
public extension UIImage {
    /// 压缩图片
    /// - Parameter mode:压缩模式
    /// - Returns:压缩后Data
    func compress(mode: CompressionMode = .medium) -> Data? {
        return resizeIO(resizeSize: mode.resize(size))?.compressDataSize(maxSize: mode.maxDataSize)
    }

    /// 异步图片压缩
    /// - Parameters:
    ///   - mode:压缩模式
    ///   - queue:压缩队列
    ///   - complete:完成回调(压缩后Data, 调整后分辨率)
    func asyncCompress(mode: CompressionMode = .medium, queue: DispatchQueue = DispatchQueue.global(), complete: @escaping (Data?, CGSize) -> Void) {
        queue.async {
            let data = self.resizeIO(resizeSize: mode.resize(self.size))?.compressDataSize(maxSize: mode.maxDataSize)
            DispatchQueue.main.async {
                complete(data, mode.resize(self.size))
            }
        }
    }

    /// 压缩图片质量
    /// - Parameter maxSize:最大数据大小
    /// - Returns:压缩后数据
    func compressDataSize(maxSize: Int = 1024 * 1024 * 2) -> Data? {
        let maxSize = maxSize
        var quality: CGFloat = 0.8
        var data = jpegData(compressionQuality: quality)
        var dataCount = data?.count ?? 0

        while (data?.count ?? 0) > maxSize {
            if quality <= 0.6 {
                break
            }
            quality = quality - 0.05
            data = jpegData(compressionQuality: quality)
            if (data?.count ?? 0) <= dataCount {
                break
            }
            dataCount = data?.count ?? 0
        }
        return data
    }

    /// ImageIO 方式调整图片大小 性能很好
    /// - Parameter resizeSize:图片调整Size
    /// - Returns:调整后图片
    func resizeIO(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize {
            return self
        }
        guard let imageData = pngData() else { return nil }
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }

        let maxPixelSize = max(size.width, size.height)
        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                       kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                       kCGImageSourceThumbnailMaxPixelSize: maxPixelSize] as CFDictionary

        let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap {
            UIImage(cgImage: $0)
        }

        return resizedImage
    }

    /// CoreGraphics 方式调整图片大小 性能很好
    /// - Parameter resizeSize:图片调整Size
    /// - Returns:调整后图片
    func resizeCG(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize {
            return self
        }
        guard let cgImage = cgImage else { return nil }
        guard let colorSpace = cgImage.colorSpace else { return nil }
        guard let context = CGContext(data: nil,
                                      width: Int(resizeSize.width),
                                      height: Int(resizeSize.height),
                                      bitsPerComponent: cgImage.bitsPerComponent,
                                      bytesPerRow: cgImage.bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }
        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(origin: .zero, size: resizeSize))
        let resizedImage = context.makeImage().flatMap {
            UIImage(cgImage: $0)
        }
        return resizedImage
    }

    /// 压缩图片大小
    /// - Parameters:
    ///   - maxLength:最大长度 0-1
    /// - Returns:处理好的图片
    func compressImageSize(toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1

        // 压缩尺寸
        guard var data = jpegData(compressionQuality: compression) else {
            return self
        }

        // 原图大小在要求范围内,不压缩图片
        if data.count < maxLength {
            return self
        }

        // 原图大小超过范围,先进行"压处理",这里 压缩比 采用二分法进行处理,6次二分后的最小压缩比是0.015625,已经够小了
        var max: CGFloat = 1
        var min: CGFloat = 0

        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            guard let data = jpegData(compressionQuality: compression) else {
                return self
            }

            if data.count < Int(Double(maxLength) * 0.9) {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }

        // 压缩结果符合 直接返回
        guard var resultImage = UIImage(data: data) else {
            return self
        }

        if data.count < maxLength {
            return resultImage
        }

        var lastDataLength = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count

            // 获取处理后的尺寸
            let ratio = CGFloat(maxLength) / CGFloat(data.count)
            let size = CGSize(width: resultImage.size.width * CGFloat(sqrtf(Float(ratio))),
                              height: resultImage.size.height * CGFloat(sqrtf(Float(ratio))))

            // 通过图片上下文进行处理图片
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()

            // 获取处理后图片的大小
            data = resultImage.jpegData(compressionQuality: compression)!
        }

        return resultImage
    }
}

// MARK: - 图片的拉伸和缩放
public extension UIImage {
    /// 返回指定尺寸的图片
    /// - Parameter size:目标图片大小
    /// - Returns:缩放完成的图片
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    /// 获取固定大小的image
    /// - Parameter size:图片尺寸
    /// - Returns:固定大小的 image
    func solidTo(size: CGSize) -> UIImage? {
        let w = size.width
        let h = size.height
        if self.size.height <= self.size.width {
            if self.size.width >= w {
                let scaleImage = fixOrientation().scaleTo(size: CGSize(width: w, height: w * self.size.height / self.size.width))
                return scaleImage
            } else {
                return fixOrientation()
            }
        } else {
            if self.size.height >= h {
                let scaleImage = fixOrientation().scaleTo(size: CGSize(width: h * self.size.width / self.size.height, height: h))
                return scaleImage
            } else {
                return fixOrientation()
            }
        }
    }

    /// 按宽高比系数:等比缩放
    /// - Parameter scale:要缩放的 宽高比 系数
    /// - Returns:等比缩放 后的图片
    func scaleTo(scale: CGFloat) -> UIImage? {
        let w = size.width
        let h = size.height
        let scaledW = w * scale
        let scaledH = h * scale
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: scaledW, height: scaledH))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 按指定尺寸等比缩放
    /// - Parameter size:要缩放的尺寸
    /// - Returns:缩放后的图片
    func scaleTo(size: CGSize) -> UIImage? {
        if cgImage == nil { return nil }
        var w = CGFloat(cgImage!.width)
        var h = CGFloat(cgImage!.height)
        let verticalRadio = size.height / h
        let horizontalRadio = size.width / w
        var radio: CGFloat = 1
        if verticalRadio > 1, horizontalRadio > 1 {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio
        } else {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio
        }
        w = w * radio
        h = h * radio
        let xPos = (size.width - w) / 2
        let yPos = (size.height - h) / 2
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: xPos, y: yPos, width: w, height: h))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

    /// 图片中间1*1拉伸——如气泡一般
    /// - Returns:拉伸后的图片
    func strechAsBubble() -> UIImage {
        let top = size.height * 0.5
        let left = size.width * 0.5
        let bottom = size.height * 0.5
        let right = size.width * 0.5
        let edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        // 拉伸
        return resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
    }

    /// 图片设置拉伸
    /// - Parameters:
    ///   - edgeInsets:拉伸区域
    ///   - resizingMode:拉伸模式
    /// - Returns:返回拉伸后的图片
    func strechBubble(edgeInsets: UIEdgeInsets, resizingMode: UIImage.ResizingMode = .stretch) -> UIImage {
        // 拉伸
        return resizableImage(withCapInsets: edgeInsets, resizingMode: resizingMode)
    }

    /// 调整图像方向 避免图像有旋转
    /// - Returns:返正常的图片
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: (self.cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (self.cgImage?.colorSpace)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        let cgImage: CGImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - 圆角处理
public extension UIImage {
    /// 获取圆角图片(带边框)
    /// - Parameters:
    ///   - size:最终生成的图片尺寸
    ///   - radius:圆角大小
    ///   - corners:圆角方向
    ///   - borderWidth:边框线宽
    ///   - borderColor:边框颜色
    ///   - backgroundColor:背景颜色
    /// - Returns:最终图片
    func circleImage(
        _ size: CGSize,
        cornerRadius radius: CGFloat,
        byRoundingCorners corners: UIRectCorner = .allCorners,
        borderWidth: CGFloat = 0,
        borderColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        completion: ((UIImage?) -> Void)? = nil
    ) -> UIImage {
        // 图形上下文设置
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }

        // 获取当前图形上下文
        let context = UIGraphicsGetCurrentContext()!

        // 填充背景色
        if let backgroundColor = backgroundColor {
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }

        // 绘制区域的大小
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        // 路径
        var path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        if rect.size.width == rect.size.height, radius == rect.size.width / 2 {
            path = UIBezierPath(ovalIn: rect)
        }
        // 添加裁剪
        path.addClip()

        // 绘制图片到上下文
        draw(in: rect)

        // 设置边框
        if let borderColor = borderColor, borderWidth > 0 {
            path.lineWidth = borderWidth * 2
            borderColor.setStroke()
            path.stroke()
        }

        // 从上下文获取图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()

        // 回调
        DispatchQueue.sb.safeAsync(.main) {
            completion?(resultImage)
        }

        return resultImage!
    }

    /// 设置图片的圆角
    /// - Parameters:
    ///   - radius:圆角大小 (默认:3.0,图片大小)
    ///   - corners:切圆角的方式
    ///   - imageSize:图片的大小
    /// - Returns:剪切后的图片
    func isRoundCorner(radius: CGFloat = 3, corners: UIRectCorner = .allCorners, imageSize: CGSize?) -> UIImage? {
        let weakSize = imageSize ?? size
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: weakSize)
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(weakSize, false, UIScreen.main.scale)
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 绘制路线
        contentRef.addPath(UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        // 裁剪
        contentRef.clip()
        // 将原图片画到图形上下文
        draw(in: rect)
        contentRef.drawPath(using: .fillStroke)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 关闭上下文
        UIGraphicsEndImageContext()
        return output
    }

    /// 设置圆形图片
    /// - Returns:圆形图片
    func isCircleImage() -> UIImage? {
        return isRoundCorner(radius: (size.width < size.height ? size.width : size.height) / 2.0, corners: .allCorners, imageSize: size)
    }
}

// MARK: - 图片水印
public extension UIImage {
    /// 图片内绘制文字
    /// - Parameter text:要绘制的文字
    /// - Returns:带绘制文字的图片
    func withText(_ text: String) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))

        let rect = CGRect(origin: CGPoint(x: 5, y: 5), size: size)

        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let dict: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1),
            NSAttributedString.Key.paragraphStyle: style,
        ]
        (text as NSString).draw(in: rect, withAttributes: dict)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }

    /// 给图片添加文字水印
    /// - Parameters:
    ///   - drawTextframe:水印的 frame
    ///   - drawText:水印文字
    ///   - withAttributes:水印富文本
    /// - Returns:返回水印图片
    func drawTextInImage(drawTextframe: CGRect, drawText: String, withAttributes: [NSAttributedString.Key: Any]? = nil) -> UIImage {
        // 开启图片上下文
        UIGraphicsBeginImageContext(size)
        // 图形重绘
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 水印文字属性
        let attributes = withAttributes
        // 水印文字和大小
        let text = NSString(string: drawText)
        // 获取富文本的 size
        // let size = text.size(withAttributes:attributes)
        // 绘制文字
        text.draw(in: drawTextframe, withAttributes: attributes)
        // 从当前上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()

        return image!
    }

    /// 添加图片水印
    /// - Parameters:
    ///   - rect:水印图片的位置
    ///   - image:水印图片
    /// - Returns:带有水印的图片
    func addImageWatermark(rect: CGRect, image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 文字图片占位符
    /// - Parameters:
    ///   - text:图片上的文字
    ///   - size:图片的大小
    ///   - backgroundColor:图片背景色
    ///   - textColor:文字颜色
    ///   - isCircle:是否要圆角
    ///   - isFirstChar:是否展示第一个字符
    /// - Returns:返回图片
    static func textImage(_ text: String, fontSize: CGFloat = 16, size: (CGFloat, CGFloat), backgroundColor: UIColor = UIColor.orange, textColor: UIColor = UIColor.white, isCircle: Bool = true, isFirstChar: Bool = false) -> UIImage? {
        // 过滤空内容
        if text.isEmpty { return nil }
        // 取第一个字符(测试了,太长了的话,效果并不好)
        let letter = isFirstChar ? (text as NSString).substring(to: 1) : text
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)

        let textsize = text.sb.strSize(kScreenWidth, font: .systemFont(ofSize: fontSize))

        // 开启上下文
        UIGraphicsBeginImageContext(sise)
        // 拿到上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if isCircle {
            UIBezierPath(roundedRect: rect, cornerRadius: minSide * 0.5).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(backgroundColor.cgColor)
        // 填充绘制
        ctx.fill(rect)
        let attr = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        // 写入文字
        // 文字写入的起点
        let pointX: CGFloat = textsize.width > minSide ? 0 : (minSide - textsize.width) / 2.0
        let pointY: CGFloat = (minSide - fontSize - 4) / 2.0
        (letter as NSString).draw(at: CGPoint(x: pointX, y: pointY), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
}

class CountedColor {
    let color: UIColor
    let count: Int

    init(color: UIColor, count: Int) {
        self.color = color
        self.count = count
    }
}

// MARK: - 颜色
public extension UIImage {
    /// 更改图片颜色
    /// - Parameter color:指定颜色
    /// - Returns:更改完颜色的图片
    func image(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    /// 更改图片颜色
    /// - Parameters:
    ///   - color:图片颜色
    ///   - blendMode:模式
    /// - Returns:返回更改后的图片颜色
    func tint(color: UIColor, blendMode: CGBlendMode = .destinationIn) -> UIImage? {
        /**
         有时我们的App需要能切换不同的主题和场景,希望图片能动态的改变颜色以配合对应场景的色调.虽然我们可以根据不同主题事先创建不同颜色的图片供调用,但既然用的图片素材都一样,还一个个转换显得太麻烦,而且不便于维护.使用blendMode变可以满足这个需求.
         */
        defer {
            UIGraphicsEndImageContext()
        }
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        guard let tintedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return tintedImage
    }

    /// 获取图片背景/主要/次要/细节 颜色
    /// - Parameter scaleDownSize:指定图片大小
    /// - Returns:背景/主要/次要/细节 颜色
    func colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        let cgImage: CGImage

        if let scaleDownSize = scaleDownSize {
            cgImage = resize(to: scaleDownSize).cgImage!
        } else {
            let ratio = size.width / size.height
            let r_width: CGFloat = 250
            cgImage = resize(to: CGSize(width: r_width, height: r_width / ratio)).cgImage!
        }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        let randomColorsThreshold = Int(CGFloat(height) * 0.01)
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        let context = CGContext(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let data = UnsafePointer<UInt8>(context?.data?.assumingMemoryBound(to: UInt8.self))
        let imageBackgroundColors = NSCountedSet(capacity: height)
        let imageColors = NSCountedSet(capacity: width * height)

        let sortComparator: (CountedColor, CountedColor) -> Bool = { a, b -> Bool in
            a.count <= b.count
        }

        for x in 0 ..< width {
            for y in 0 ..< height {
                let pixel = ((width * y) + x) * bytesPerPixel
                let color = UIColor(
                    /*
                     red:CGFloat(data?[pixel + 1]!) / 255,
                     green:CGFloat(data?[pixel + 2]!) / 255,
                     blue:CGFloat(data?[pixel + 3]!) / 255,
                     */
                    red: CGFloat(data?[pixel + 1] ?? 0) / 255,
                    green: CGFloat(data?[pixel + 2] ?? 0) / 255,
                    blue: CGFloat(data?[pixel + 3] ?? 0) / 255,
                    alpha: 1
                )

                if x >= 5, x <= 10 {
                    imageBackgroundColors.add(color)
                }

                imageColors.add(color)
            }
        }

        var sortedColors = [CountedColor]()

        for color in imageBackgroundColors {
            guard let color = color as? UIColor else { continue }

            let colorCount = imageBackgroundColors.count(for: color)

            if randomColorsThreshold <= colorCount {
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }

        sortedColors.sort(by: sortComparator)

        var proposedEdgeColor = CountedColor(color: blackColor, count: 1)

        if let first = sortedColors.first { proposedEdgeColor = first }

        if proposedEdgeColor.color.isBlackOrWhite, !sortedColors.isEmpty {
            for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
                if !countedColor.color.isBlackOrWhite {
                    proposedEdgeColor = countedColor
                    break
                }
            }
        }

        let imageBackgroundColor = proposedEdgeColor.color
        let isDarkBackgound = imageBackgroundColor.isDark

        sortedColors.removeAll()

        for imageColor in imageColors {
            guard let imageColor = imageColor as? UIColor else { continue }

            let color = imageColor.color(minSaturation: 0.15)

            if color.isDark == !isDarkBackgound {
                let colorCount = imageColors.count(for: color)
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }

        sortedColors.sort(by: sortComparator)

        var primaryColor, secondaryColor, detailColor: UIColor?

        for countedColor in sortedColors {
            let color = countedColor.color

            if primaryColor == nil,
               color.isContrasting(with: imageBackgroundColor)
            {
                primaryColor = color
            } else if secondaryColor == nil,
                      primaryColor != nil,
                      primaryColor!.isDistinct(from: color),
                      color.isContrasting(with: imageBackgroundColor)
            {
                secondaryColor = color
            } else if secondaryColor != nil,
                      secondaryColor!.isDistinct(from: color),
                      primaryColor!.isDistinct(from: color),
                      color.isContrasting(with: imageBackgroundColor)
            {
                detailColor = color
                break
            }
        }

        free(raw)

        return (
            imageBackgroundColor,
            primaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
            secondaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
            detailColor ?? (isDarkBackgound ? whiteColor : blackColor)
        )
    }

    /// 异步获取指定CGPoint位置颜色
    func color(at point: CGPoint, completion: @escaping (UIColor?) -> Void) {
        let size = self.size
        let cgImage = self.cgImage

        DispatchQueue.global(qos: .userInteractive).async {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let imgRef = cgImage,
                  let dataProvider = imgRef.dataProvider,
                  let dataCopy = dataProvider.data,
                  let data = CFDataGetBytePtr(dataCopy), rect.contains(point)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let pixelInfo = (Int(size.width) * Int(point.y) + Int(point.x)) * 4
            let red = CGFloat(data[pixelInfo]) / 255.0
            let green = CGFloat(data[pixelInfo + 1]) / 255.0
            let blue = CGFloat(data[pixelInfo + 2]) / 255.0
            let alpha = CGFloat(data[pixelInfo + 3]) / 255.0

            DispatchQueue.main.async {
                completion(UIColor(red: red, green: green, blue: blue, alpha: alpha))
            }
        }
    }

    /// 获取图片主题颜色
    func mainColor(_ completion: @escaping (_ color: UIColor?) -> Void) {
        DispatchQueue.global().async {
            if self.cgImage == nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            let bitmapInfo = CGBitmapInfo(rawValue: 0).rawValue | CGImageAlphaInfo.premultipliedLast.rawValue

            // 第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
            let thumbSize = CGSize(width: 40, height: 40)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let context = CGContext(data: nil,
                                          width: Int(thumbSize.width),
                                          height: Int(thumbSize.height),
                                          bitsPerComponent: 8,
                                          bytesPerRow: Int(thumbSize.width) * 4,
                                          space: colorSpace,
                                          bitmapInfo: bitmapInfo) else { return completion(nil) }

            let drawRect = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
            context.draw(self.cgImage!, in: drawRect)

            // 第二步 取每个点的像素值
            if context.data == nil { return completion(nil) }
            let countedSet = NSCountedSet(capacity: Int(thumbSize.width * thumbSize.height))
            for x in 0 ..< Int(thumbSize.width) {
                for y in 0 ..< Int(thumbSize.height) {
                    let offset = 4 * x * y
                    let red = context.data!.load(fromByteOffset: offset, as: UInt8.self)
                    let green = context.data!.load(fromByteOffset: offset + 1, as: UInt8.self)
                    let blue = context.data!.load(fromByteOffset: offset + 2, as: UInt8.self)
                    let alpha = context.data!.load(fromByteOffset: offset + 3, as: UInt8.self)
                    // 过滤透明的、基本白色、基本黑色
                    if alpha > 0, red < 250, green < 250, blue < 250, red > 5, green > 5, blue > 5 {
                        let array = [red, green, blue, alpha]
                        countedSet.add(array)
                    }
                }
            }

            // 第三步 找到出现次数最多的那个颜色
            let enumerator = countedSet.objectEnumerator()
            var maxColor: [Int] = []
            var maxCount = 0
            while let curColor = enumerator.nextObject() as? [Int], !curColor.isEmpty {
                let tmpCount = countedSet.count(for: curColor)
                if tmpCount < maxCount { continue }
                maxCount = tmpCount
                maxColor = curColor
            }
            let color = UIColor(red: CGFloat(maxColor[0]) / 255.0, green: CGFloat(maxColor[1]) / 255.0, blue: CGFloat(maxColor[2]) / 255.0, alpha: CGFloat(maxColor[3]) / 255.0)
            DispatchQueue.main.async { completion(color) }
        }
    }

    /// 获取图片某一个位置像素的颜色
    /// - Parameter point:图片上某个点
    /// - Returns:返回某个点的 UIColor
    func pixelColor(_ point: CGPoint) -> UIColor? {
        if point.x < 0 || point.x > size.width || point.y < 0 || point.y > size.height {
            return nil
        }

        let provider = cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)

        let numberOfComponents: CGFloat = 4.0
        let pixelData = (size.width * point.y + point.x) * numberOfComponents

        let r = CGFloat(data![Int(pixelData)]) / 255.0
        let g = CGFloat(data![Int(pixelData) + 1]) / 255.0
        let b = CGFloat(data![Int(pixelData) + 2]) / 255.0
        let a = CGFloat(data![Int(pixelData) + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

// MARK: - 渐变
public enum CMImageGradientDirection {
    /// 水平从左到右
    case horizontal
    /// 垂直从上到下
    case vertical
    /// 左上到右下
    case leftOblique
    /// 右上到左下
    case rightOblique
    /// 自定义
    case other(CGPoint, CGPoint)

    public func point(size: CGSize) -> (CGPoint, CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
        case .rightOblique:
            return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
        case let .other(stat, end):
            return (stat, end)
        }
    }
}

public extension UIImage {
    /// 生成指定尺寸的纯色图像
    /// - Parameters:
    ///   - color:图片颜色
    ///   - size:图片尺寸
    /// - Returns:返回对应的图片
    static func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        return image(color: color, size: size, corners: .allCorners, radius: 0)
    }

    /// 生成指定尺寸和圆角的纯色图像
    /// - Parameters:
    ///   - color:图片颜色
    ///   - size:图片尺寸
    ///   - corners:剪切的方式
    ///   - round:圆角大小
    /// - Returns:返回对应的图片
    static func image(color: UIColor, size: CGSize, corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }

    /// 生成渐变色的图片 ["#B0E0E6", "#00CED1", "#2E8B57"]
    /// - Parameters:
    ///   - hexsString:十六进制字符数组
    ///   - size:图片大小
    ///   - locations:locations 数组
    ///   - direction:渐变的方向
    /// - Returns:渐变的图片
    static func gradient(_ hexsString: [String], size: CGSize = CGSize(width: 1, height: 1), locations: [CGFloat]? = [0, 1], direction: CMImageGradientDirection = .horizontal) -> UIImage? {
        return gradient(hexsString.map { UIColor(hex: $0) }, size: size, locations: locations, direction: direction)
    }

    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors:UIColor 数组
    ///   - size:图片大小
    ///   - locations:locations 数组
    ///   - direction:渐变的方向
    /// - Returns:渐变的图片
    static func gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations: [CGFloat]? = [0, 1], direction: CMImageGradientDirection = .horizontal) -> UIImage? {
        return gradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }

    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors:UIColor 数组
    ///   - size:图片大小
    ///   - radius:圆角
    ///   - locations:locations 数组
    ///   - direction:渐变的方向
    /// - Returns:带圆角的渐变的图片
    static func gradient(_ colors: [UIColor],
                         size: CGSize = CGSize(width: 10, height: 10),
                         radius: CGFloat,
                         locations: [CGFloat]? = [0, 1],
                         direction: CMImageGradientDirection = .horizontal) -> UIImage?
    {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return image(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map { $0.cgColor } as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - 群图标

public extension Array where Element == UIImage {
    /// 生成群聊图标
    /// - Parameters:
    ///   - size:尺寸
    ///   - bgColor:背景颜色
    /// - Returns:群图标
    func groupIcon(_ size: CGFloat, bgColor: UIColor? = nil) -> UIImage {
        return UIImage.makeGroupIcon(size, images: self, bgColor: bgColor)
    }
}

// MARK: - 群图标

public extension UIImage {
    /// 生成群聊图标
    /// - Parameters:
    ///   - size:尺寸
    ///   - images:图片数组
    ///   - bgColor:背景颜色
    /// - Returns:群图标
    static func makeGroupIcon(_ size: CGFloat, images: [UIImage], bgColor: UIColor? = nil) -> UIImage {
        let finalSize = CGSize(width: size, height: size)

        // 开始图片处理上下文(由于输出的图不会进行缩放,所以缩放因子等于屏幕的scale即可
        UIGraphicsBeginImageContextWithOptions(finalSize, false, 0)

        if let bg = bgColor {
            let context: CGContext = UIGraphicsGetCurrentContext()!
            context.addRect(CGRect(origin: .zero, size: finalSize))
            context.setFillColor(bg.cgColor)
            context.drawPath(using: .fill)
        }

        if images.count >= 1 {
            let rects = getRectsInGroupIcon(wh: size, count: images.count)
            var count = 0
            // 将每张图片绘制到对应的区域上
            for image in images {
                if count > rects.count - 1 {
                    break
                }

                let rect = rects[count]
                image.draw(in: rect)
                count = count + 1
            }
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    /// 获取群聊图标中每个小图片的位置尺寸
    /// - Parameters:
    ///   - wh:宽高
    ///   - count:数量
    /// - Returns:CGRect数组
    static func getRectsInGroupIcon(wh: CGFloat, count: Int) -> [CGRect] {
        if count == 1 {
            return [CGRect(x: 0, y: 0, width: wh, height: wh)]
        }

        // 下面是图片数量大于1张的情况
        var array = [CGRect]()
        // 图片间距
        var padding: CGFloat = 5
        // 小图片尺寸
        var cellWH: CGFloat
        // 用于后面计算的单元格数量(小于等于4张图片算4格单元格,大于4张算9格单元格)
        var cellCount: Int

        if count <= 4 {
            cellWH = (wh - padding * 3) / 2
            cellCount = 4
        } else {
            padding = padding / 2
            cellWH = (wh - padding * 4) / 3
            cellCount = 9
        }

        // 总行数
        let rowCount = Int(sqrt(Double(cellCount)))
        // 根据单元格长宽,间距,数量返回所有单元格初步对应的位置尺寸
        for i in 0 ..< cellCount {
            // 当前行
            let row = i / rowCount
            // 当前列
            let column = i % rowCount
            let rect = CGRect(x: padding * CGFloat(column + 1) + cellWH * CGFloat(column),
                              y: padding * CGFloat(row + 1) + cellWH * CGFloat(row),
                              width: cellWH, height: cellWH)
            array.append(rect)
        }

        // 根据实际图片的数量再调整单元格的数量和位置
        if count == 2 {
            array.removeSubrange(0 ... 1)
            for i in 0 ..< array.count {
                array[i].origin.y = array[i].origin.y - (padding + cellWH) / 2
            }
        } else if count == 3 {
            array.remove(at: 0)
            array[0].origin.x = (wh - cellWH) / 2
        } else if count == 5 {
            array.removeSubrange(0 ... 3)
            for i in 0 ..< array.count {
                if i < 2 {
                    array[i].origin.x = array[i].origin.x - (padding + cellWH) / 2
                }
                array[i].origin.y = array[i].origin.y - (padding + cellWH) / 2
            }
        } else if count == 6 {
            array.removeSubrange(0 ... 2)
            for i in 0 ..< array.count {
                array[i].origin.y = array[i].origin.y - (padding + cellWH) / 2
            }
        } else if count == 7 {
            array.removeSubrange(0 ... 1)
            array[0].origin.x = (wh - cellWH) / 2
        } else if count == 8 {
            array.remove(at: 0)
            for i in 0 ..< 2 {
                array[i].origin.x = array[i].origin.x - (padding + cellWH) / 2
            }
        }
        return array
    }
}

// MARK: - 保存图片
public extension UIImage {
    /// 保存图片到相册
    /// - Parameter completion:完成回调
    func saveImageToPhotoAlbum(_ completion: ((Bool) -> Void)?) {
        saveToPhotoAlbum(completion)
    }

    /// 保存图片到相册
    /// - Parameter completion:完成回调
    func savePhotosImageToAlbum(completion: @escaping ((Bool, Error?) -> Void)) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: self)
        } completionHandler: { (isSuccess: Bool, error: Error?) in
            completion(isSuccess, error)
        }
    }
}

private extension UIImage {
    private enum CMRuntimeKey {
        static let saveBlockKey = UnsafeRawPointer(bitPattern: "saveBlock".hashValue)
    }

    private var saveBlock: ((Bool) -> Void)? {
        set {
            objc_setAssociatedObject(self, CMRuntimeKey.saveBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, CMRuntimeKey.saveBlockKey!) as? (Bool) -> Void
        }
    }

    /// 保存图片到相册
    func saveToPhotoAlbum(_ result: ((Bool) -> Void)?) {
        saveBlock = result
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            saveBlock?(false)
        } else {
            saveBlock?(true)
        }
    }
}

// MARK: - DataType
public enum DataType: String {
    case gif
    case png
    case jpeg
    case tiff
    case defaultType
}

// MARK: - Gif加载
public extension UIImage {
    /// 获取资源格式
    /// - Parameter data:资源
    /// - Returns:格式
    static func checkImageDataType(data: Data?) -> DataType {
        guard data != nil else {
            return .defaultType
        }
        let c = data![0]
        switch c {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        default:
            return .defaultType
        }
    }

    /// 加载网络图片
    /// - Parameter imageSource:图片资源
    /// - Returns:图片
    static func loadImage(_ imageSource: String) -> UIImage? {
        if imageSource.hasPrefix("http://") || imageSource.hasPrefix("https://") { // 网络图片
            let imageURL = URL(string: imageSource)
            var imageData: Data?
            do {
                imageData = try Data(contentsOf: imageURL!)
                return UIImage(data: imageData!)!
            } catch {
                return nil
            }
        } else if imageSource.contains("/") { // bundle路径
            return UIImage(contentsOfFile: imageSource)
        }
        return UIImage(named: imageSource)!
    }

    /// 加载 `data` 数据的 `gif` 图片
    /// - Parameter data:data 数据
    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return animatedImageWithSource(source)
    }

    /// 加载网络 `url` 的 `gif` 图片
    /// - Parameter url:gif图片的网络地址
    static func gif(url: String) -> UIImage? {
        guard let bundleURL = URL(string: url) else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }

        return gif(data: imageData)
    }

    /// 加载本地的gif图片
    /// - Parameter name:图片的名字
    static func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif")
        else {
            return nil
        }

        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }

        return gif(data: imageData)
    }

    /// 加载 `asset` 里面的gif图片
    /// - Parameter asset:`asset` 里面的图片名字
    @available(iOS 9.0, *)
    static func gif(asset: String) -> UIImage? {
        guard let dataAsset = NSDataAsset(name: asset) else {
            return nil
        }
        return gif(data: dataAsset.data)
    }

    /// 获取 `asset` 里面的gif图片的信息:包含分解后的图片和`gif`时间
    /// - Parameter asset:`asset` 里面的图片名字
    /// - Returns:分解后的图片和`gif`时间
    static func gifImages(asset: String) -> (gifImages: [UIImage]?, duration: TimeInterval?) {
        guard let dataAsset = NSDataAsset(name: asset) else {
            return (nil, nil)
        }
        guard let source = CGImageSourceCreateWithData(dataAsset.data as CFData, nil) else {
            return (nil, nil)
        }
        return animatedImageSources(source)
    }

    /// 获取 加载本地的 的`gif`图片的信息:包含分解后的图片和`gif`时间
    /// - Parameter name:图片的名字
    /// - Returns:分解后的图片和gif时间
    static func gifImages(name: String) -> (gifImages: [UIImage]?, duration: TimeInterval?) {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif")
        else {
            return (nil, nil)
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return (nil, nil)
        }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return (nil, nil)
        }
        return animatedImageSources(source)
    }

    /// 获取 网络 `url` 的 `gif` 图片的信息:包含分解后的图片和`gif`时间
    /// - Parameter url:`gif`图片的网络地址
    /// - Returns:分解后的图片和`gif`时间
    static func gifImages(url: String) -> (gifImages: [UIImage]?, duration: TimeInterval?) {
        guard let bundleURL = URL(string: url) else {
            return (nil, nil)
        }

        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return (nil, nil)
        }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return (nil, nil)
        }
        return animatedImageSources(source)
    }

    /// 获取`gif`图片转化为动画的`Image`
    private static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let info = animatedImageSources(source)
        guard let frames = info.gifImages, let duration = info.duration else {
            return nil
        }
        let animation = UIImage.animatedImage(with: frames, duration: duration)
        return animation
    }

    /// 获取`gif`图片的信息
    /// - Parameter source:`CGImageSource` 资源
    /// - Returns:gif信息
    private static func animatedImageSources(_ source: CGImageSource) -> (gifImages: [UIImage]?, duration: TimeInterval?) {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        for index in 0 ..< count {
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            let delaySeconds = delayForImageAtIndex(Int(index), source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }

        let duration: Int = {
            var sum = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()

        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for index in 0 ..< count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            for _ in 0 ..< frameCount {
                frames.append(frame)
            }
        }
        return (frames, Double(duration) / 1000.0)
    }

    private static func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self
        )
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1
        }
        return delay
    }

    private static func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = gcdForPair(val, gcd)
        }
        return gcd
    }

    private static func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        var rest: Int
        while true {
            rest = lhs! % rhs!
            if rest == 0 {
                return rhs!
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
}

// MARK: - 动态图片的使用
public extension UIImage {
    /// 动态图片为同一个图片
    /// - Parameter image:图片
    /// - Returns:最终图片
    static func darkModeImage(_ imageName: String) -> UIImage? {
        return darkModeImage(imageName, darkImageName: imageName)
    }

    /// 深色图片和浅色图片切换 (深色模式适配)
    /// - Parameters:
    ///   - lightImage:浅色模式的图片名称
    ///   - darkImage:深色模式的图片名称
    /// - Returns:最终图片
    static func darkModeImage(_ lightImageName: String, darkImageName: String) -> UIImage? {
        return darkModeImage(UIImage(named: lightImageName), darkImage: UIImage(named: darkImageName))
    }

    /// 动态图片为同一个图片
    /// - Parameter image:图片
    /// - Returns:最终图片
    static func darkModeImage(_ image: UIImage?) -> UIImage? {
        return darkModeImage(image, darkImage: image)
    }

    /// 深色图片和浅色图片切换 (深色模式适配)
    /// - Parameters:
    ///   - lightImage:浅色模式的图片
    ///   - darkImage:深色模式的图片
    /// - Returns:最终图片
    static func darkModeImage(_ lightImage: UIImage?, darkImage: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard
                let weakLightImage = lightImage,
                let weakDarkImage = darkImage,
                let config = weakLightImage.configuration
            else {
                return lightImage
            }
            let lightImage = weakLightImage.withConfiguration(config.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
            lightImage.imageAsset?.register(weakDarkImage, with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.dark)))
            return lightImage.imageAsset?.image(with: .current) ?? lightImage
        } else {
            return lightImage
        }
    }
}
