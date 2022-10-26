import SpriteKit

// MARK: - 方法
public extension SKSpriteNode {
    /// 等比填充
    /// - Parameter fillSize: 边界尺寸
    func aspectFill(to fillSize: CGSize) {
        if let textureSize = texture?.size() {
            let width = textureSize.width
            let height = textureSize.height

            guard width > 0, height > 0 else {
                return
            }

            let horizontalRatio = fillSize.width / width
            let verticalRatio = fillSize.height / height
            let ratio = horizontalRatio < verticalRatio ? horizontalRatio : verticalRatio
            size = CGSize(width: width * ratio, height: height * ratio)
        }
    }
}
