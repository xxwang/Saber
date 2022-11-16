import SpriteKit

// MARK: - 方法
public extension SaberExt where Base: SKSpriteNode {
    /// 等比例填充
    /// - Parameter fillSize:边界尺寸
    func aspectFill(to fillSize: CGSize) {
        guard let textureSize = base.texture?.size() else {
            return
        }

        let width = textureSize.width
        let height = textureSize.height

        guard width > 0, height > 0 else {
            return
        }

        let horizontalRatio = fillSize.width / width
        let verticalRatio = fillSize.height / height
        let ratio = horizontalRatio < verticalRatio ? horizontalRatio : verticalRatio
        base.size = CGSize(width: width * ratio, height: height * ratio)
    }
}
