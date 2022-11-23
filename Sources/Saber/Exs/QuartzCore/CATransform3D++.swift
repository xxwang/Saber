import CoreGraphics
import QuartzCore

extension CATransform3D: Saberable {}

// MARK: - 属性
public extension SaberEx where Base == CATransform3D {
    /// 判断是否是`CATransform3D`默认对象
    var isIdentity: Bool {
        return CATransform3DIsIdentity(base)
    }

    /// `CATransform3D`默认值(`[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]`)
    static var identity: CATransform3D {
        return CATransform3DIdentity
    }
}

// MARK: - CGAffineTransform
public extension SaberEx where Base == CATransform3D {
    /// 如果`CATransform3D`可以用`CGAffineTransform`(`仿射变换`)精确表示，则返回 `true`
    var isAffine: Bool {
        return CATransform3DIsAffine(base)
    }

    /// `CATransform3D`转`CGAffineTransform`
    /// - Returns: 如果转换失败,返回`identity`
    func affineTransform() -> CGAffineTransform {
        return CATransform3DGetAffineTransform(base)
    }
}

// MARK: - 方法
public extension SaberEx where Base == CATransform3D {
    /// 通过平移`(tx, ty, tz)` 返回新的`CATransform3D`
    /// - Parameters:
    ///   - tx:x 轴平移
    ///   - ty:y 轴平移
    ///   - tz:z 轴平移
    /// - Returns:平移后的`CATransform3D`
    func translatedBy(
        x tx: CGFloat,
        y ty: CGFloat,
        z tz: CGFloat
    ) -> CATransform3D {
        return CATransform3DTranslate(base, tx, ty, tz)
    }

    /// 通过缩放`(sx, sy, sz)` 返回新的`CATransform3D`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y 轴缩放
    ///   - sz:z 轴缩放
    /// - Returns:缩放后的`CATransform3D`
    func scaledBy(
        x sx: CGFloat,
        y sy: CGFloat,
        z sz: CGFloat
    ) -> CATransform3D {
        return CATransform3DScale(base, sx, sy, sz)
    }

    /// 通过旋转`(x, y, z)` 返回新的`CATransform3D`
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的z位置
    /// - Returns:旋转后的`CATransform3D`
    func rotated(
        by angle: CGFloat,
        x: CGFloat,
        y: CGFloat,
        z: CGFloat
    ) -> CATransform3D {
        return CATransform3DRotate(base, angle, x, y, z)
    }

    /// 反转`CATransform3D`
    /// - Returns:`CATransform3D`
    func inverted() -> CATransform3D {
        return CATransform3DInvert(base)
    }

    /// 将两个`CATransform3D`连接,并生成新的`CATransform3D`
    /// - Parameter t2:`CATransform3D`
    /// - Returns: 新的`CATransform3D`
    func concatenating(_ t2: CATransform3D) -> CATransform3D {
        return CATransform3DConcat(base, t2)
    }

    /// 通过平移`(tx, ty, tz)` 并赋值给`base`
    /// - Parameters:
    ///   - tx:x 轴平移
    ///   - ty:y 轴平移
    ///   - tz:z 轴平移
    /// - Returns:平移后的`CATransform3D`
    func translatedBy(
        x tx: CGFloat,
        y ty: CGFloat,
        z tz: CGFloat
    ) {
        base = CATransform3DTranslate(base, tx, ty, tz)
    }

    /// 通过缩放`(sx, sy, sz)`  并赋值给`base`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y 轴缩放
    ///   - sz:z 轴缩放
    /// - Returns:缩放后的`CATransform3D`
    func scaledBy(
        x sx: CGFloat,
        y sy: CGFloat,
        z sz: CGFloat
    ) {
        base = CATransform3DScale(base, sx, sy, sz)
    }

    /// 通过旋转`(x, y, z)`  并赋值给`base`
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的z位置
    /// - Returns:旋转后的`CATransform3D`
    func rotated(
        by angle: CGFloat,
        x: CGFloat,
        y: CGFloat,
        z: CGFloat
    ) {
        base = CATransform3DRotate(base, angle, x, y, z)
    }

    /// 反转`CATransform3D` 并赋值给`base`
    /// - Returns:`CATransform3D`
    func inverted() {
        base = CATransform3DInvert(base)
    }

    /// 将两个`CATransform3D`连接, 并赋值给`base`
    /// - Parameter t2:`CATransform3D`
    /// - Returns: 新的`CATransform3D`
    func concatenating(_ t2: CATransform3D) {
        base = CATransform3DConcat(base, t2)
    }
}

// MARK: - 构造方法
public extension CATransform3D {
    /// 创建一个值为 `(tx, ty, tz)` 的`CATransform3D`
    /// - Parameters:
    ///   - tx: x 轴平移
    ///   - ty: y轴平移
    ///   - tz: z 轴平移
    @inlinable
    init(
        translationX tx: CGFloat,
        y ty: CGFloat,
        z tz: CGFloat
    ) {
        self = CATransform3DMakeTranslation(tx, ty, tz)
    }

    /// 创建一个按 `(sx, sy, sz)` 缩放的`CATransform3D`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y轴缩放
    ///   - sz:z轴缩放
    @inlinable
    init(
        scaleX sx: CGFloat,
        y sy: CGFloat,
        z sz: CGFloat
    ) {
        self = CATransform3DMakeScale(sx, sy, sz)
    }

    /// 创建一个围绕向量 `(x, y, z)` 旋转 `angle` 弧度的`CATransform3D`
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的z位置
    @inlinable
    init(
        rotationAngle angle: CGFloat,
        x: CGFloat,
        y: CGFloat,
        z: CGFloat
    ) {
        self = CATransform3DMakeRotation(angle, x, y, z)
    }
}

// MARK: - Codable
extension CATransform3D: Codable {
    /// 解码
    /// - Parameter decoder: 解码器
    @inlinable
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.init(
            m11: try container.decode(CGFloat.self),
            m12: try container.decode(CGFloat.self),
            m13: try container.decode(CGFloat.self),
            m14: try container.decode(CGFloat.self),
            m21: try container.decode(CGFloat.self),
            m22: try container.decode(CGFloat.self),
            m23: try container.decode(CGFloat.self),
            m24: try container.decode(CGFloat.self),
            m31: try container.decode(CGFloat.self),
            m32: try container.decode(CGFloat.self),
            m33: try container.decode(CGFloat.self),
            m34: try container.decode(CGFloat.self),
            m41: try container.decode(CGFloat.self),
            m42: try container.decode(CGFloat.self),
            m43: try container.decode(CGFloat.self),
            m44: try container.decode(CGFloat.self)
        )
    }

    /// 编码
    /// - Parameter encoder: 编码器
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(m11)
        try container.encode(m12)
        try container.encode(m13)
        try container.encode(m14)
        try container.encode(m21)
        try container.encode(m22)
        try container.encode(m23)
        try container.encode(m24)
        try container.encode(m31)
        try container.encode(m32)
        try container.encode(m33)
        try container.encode(m34)
        try container.encode(m41)
        try container.encode(m42)
        try container.encode(m43)
        try container.encode(m44)
    }
}

// MARK: - 运算符
extension CATransform3D: Equatable {
    /// 判断两个`CATransform3D`是否相等
    /// - Returns:是否相等
    @inlinable
    public static func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        CATransform3DEqualToTransform(lhs, rhs)
    }
}
