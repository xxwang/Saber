import UIKit

// MARK: - QRCodeManager
public class QRCodeManager {}

// MARK: - 二维码生成
public extension QRCodeManager {
    /// 生成二维码图片
    /// - Parameters:
    ///   - content: 二维码里面的内容
    ///   - size: 二维码的大小
    ///   - logoSize: logo的大小
    ///   - logoImage: logo图片
    /// - Returns: 返回生成二维码图片
    static func QRCodeImage(with content: String, size: CGSize, isLogo: Bool = true, logoSize: CGSize?, logoImage: UIImage? = nil, logoRoundCorner: CGFloat? = nil) -> UIImage? {
        // 创建名为"CIQRCodeGenerator"的CIFilter
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 将filter所有属性设置为默认值
        filter?.setDefaults()
        // 将所需尽心转为UTF8的数据,并设置给filter
        let data = content.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        // 设置二维码的纠错水平,越高纠错水平越高,可以污损的范围越大
        // L: 7%
        // M: 15%
        // Q: 25%
        // H: 30%
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        // 拿到二维码图片,此时的图片不是很清晰,需要二次加工
        guard let outPutImage = filter?.outputImage else {
            return nil
        }

        return getHDImgWithCIImage(with: outPutImage, size: size, isLogo: isLogo, logoSize: logoSize, logoImage: logoImage, logoRoundCorner: logoRoundCorner)
    }

    /// 调整二维码清晰度,添加水印图片
    /// - Parameters:
    ///   - image: 模糊的二维码图片
    ///   - size: 二维码的宽高
    ///   - logoSize: logo的大小
    ///   - logoImage: logo图片
    /// - Returns: 添加 logo 图片后,清晰的二维码图片
    private static func getHDImgWithCIImage(with image: CIImage, size: CGSize, isLogo: Bool = true, logoSize: CGSize?, logoImage: UIImage? = nil, logoRoundCorner: CGFloat? = nil) -> UIImage? {
        let extent = image.extent.integral
        let scale = min(size.width / extent.width, size.height / extent.height)
        // 创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale

        // 创建基于GPU的CIContext对象,性能和效果更好
        let context = CIContext(options: nil)
        // 创建CoreGraphics image
        guard let bitmapImage = context.createCGImage(image, from: extent) else {
            return nil
        }

        // 创建一个DeviceGray颜色空间
        let cs = CGColorSpaceCreateDeviceGray()
        // CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
        // width：图片宽度像素
        // height：图片高度像素
        // bitsPerComponent：每个颜色的比特值,例如在rgba-32模式下为8
        // bitmapInfo：指定的位图应该包含一个alpha通道
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) // 图形上下文,画布
        bitmapRef?.interpolationQuality = CGInterpolationQuality.none // 写入质量
        bitmapRef?.scaleBy(x: scale, y: scale) // 调整“画布”的缩放
        bitmapRef?.draw(bitmapImage, in: extent) // 绘制图片

        // 保存bitmap到图片
        guard let scaledImage = bitmapRef?.makeImage() else {
            return nil
        }

        // 清晰的二维码图片
        let outputImage = UIImage(cgImage: scaledImage)

        guard isLogo == true, let logoSize = logoSize, let logoImage = logoImage else {
            return outputImage
        }

        var newLogo: UIImage = logoImage
        if let newLogoRoundCorner = logoRoundCorner, let roundCornerLogo = logoImage.isRoundCorner(radius: newLogoRoundCorner, corners: .allCorners, imageSize: logoSize) {
            newLogo = roundCornerLogo
        }

        // 给二维码加 logo 图
        UIGraphicsBeginImageContextWithOptions(outputImage.size, false, UIScreen.main.scale)
        outputImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 把水印图片画到生成的二维码图片上,注意尺寸不要太大(根据上面生成二维码设置的纠错程度设置),否则有可能造成扫不出来
        let waterImgW = logoSize.width
        let waterImgH = logoSize.height
        let waterImgX = (size.width - waterImgW) * 0.5
        let waterImgY = (size.height - waterImgH) * 0.5
        newLogo.draw(in: CGRect(x: waterImgX, y: waterImgY, width: waterImgW, height: waterImgH))
        let newPicture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newPicture
    }
}

// MARK: - 二维码解析
public extension QRCodeManager {
    /// 获取图片中二维码数组
    /// - Parameter qrcodeImg: 二维码图片
    /// - Returns: 二维码信息数组
    static func getImageQRImage(_ qrcodeImg: UIImage) -> [CIQRCodeFeature] {
        let context = CIContext(options: nil)
        guard let ciImage = CIImage(image: qrcodeImg),
              let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature]
        else {
            return []
        }
        return features
    }

    /// 获取图片每个二维码里面的信息数组
    /// - Parameter qrcodeImg: 二维码图片
    /// - Returns: 二维码信息数组
    static func getImageQRImageInfo(_ qrcodeImg: UIImage) -> [String] {
        // 遍历所有的二维码,并拿出二维码里面的信息
        return getImageQRImage(qrcodeImg).map { $0.messageString ?? "" }
    }

    /// 识别图片二维码
    /// - Parameter qrcodeImg: 二维码图片
    /// - Returns: 数据
    static func recognizeQRCode(_ qrcodeImg: UIImage) -> String? {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: CoreImage.CIImage(cgImage: qrcodeImg.cgImage!))
        guard (features?.count)! > 0 else {
            return nil
        }
        let feature = features?.first as? CIQRCodeFeature
        return feature?.messageString
    }
}
