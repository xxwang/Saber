import CoreGraphics
import Foundation

    // MARK: - 属性
public extension CGRect {
        /// 获取中心点坐标
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}

    // MARK: - 构造方法
public extension CGRect {
        /// 构造一个带中心点的CGRect
        /// - Parameters:
        ///   - center: 中心点坐标
        ///   - size: 尺寸
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        self.init(origin: origin, size: size)
    }
}

    // MARK: - 方法
public extension CGRect {
        /// 通过使用指定的锚点调整大小来创建一个新的CGRect
        /// - Parameters:
        ///   - size: 新的尺寸
        ///   - anchor: 锚点
        ///     '(0, 0)' 左上角,'(1, 1)'右下角
        ///     默认为 '(0.5, 0.5)' 中心点:
        ///
        ///          anchor = CGPoint(x: 0.0, y: 1.0):
        ///
        ///                       A2------B2
        ///          A----B       |        |
        ///          |    |  -->  |        |
        ///          C----D       C-------D2
        ///
    func resizing(to size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let sizeDelta = CGSize(width: size.width - width, height: size.height - height)
        let origin = CGPoint(x: minX - sizeDelta.width * anchor.x, y: minY - sizeDelta.height * anchor.y)
        return CGRect(origin: origin, size: size)
    }
}
