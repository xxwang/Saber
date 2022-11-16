import CoreGraphics
import QuartzCore

// MARK: - 属性
public extension CATransform3D {
    /// 如果`self`是transform，则返回`true`
    @inlinable
    var isIdentity: Bool { CATransform3DIsIdentity(self) }
}

// MARK: - 静态属性
public extension CATransform3D {
    /// `CATransform3D`默认值([1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1])
    @inlinable
    static var identity: CATransform3D { CATransform3DIdentity }
}



// MARK: - Codable
extension CATransform3D: Codable {
    /// 通过从给定解码器解码来创建新实例
    ///
    /// 如果从解码器读取失败，或者如果读取的数据已损坏或无效，此初始值设定项将引发错误
    /// - Parameter decoder:从中读取数据的解码器
    @inlinable
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.init(m11: try container.decode(CGFloat.self),
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
                  m44: try container.decode(CGFloat.self))
    }

    /// 将该值编码到给定的编码器中
    ///
    /// 如果该值未能对任何内容进行编码，编码器将在其位置对一个空的键控容器进行编码
    ///
    /// 如果任何值对于给定编码器的格式无效，此函数将抛出一个错误
    /// - Parameter encoder:写入数据的编码器
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

// MARK: - CGAffineTransform
public extension CATransform3D {
    /// 如果`self`可以用仿射变换精确表示，则返回 `true`
    @inlinable
    var isAffine: Bool { CATransform3DIsAffine(self) }

    /// 返回`self`表示的仿射变换
    /// - Returns:如果`self`不能用仿射变换精确表示，则返回值是未定义的
    @inlinable
    func affineTransform() -> CGAffineTransform {
        CATransform3DGetAffineTransform(self)
    }
}

// MARK: - 方法
public extension CATransform3D {
    /// 返回通过`(tx, ty, tz)` 平移`self`后的`CATransform3D`
    /// - Parameters:
    ///   - tx:x 轴平移
    ///   - ty:y 轴平移
    ///   - tz:z 轴平移
    /// - Returns:平移后的`CATransform3D`
    @inlinable
    func translatedBy(x tx: CGFloat, y ty: CGFloat,
                      z tz: CGFloat) -> CATransform3D
    {
        CATransform3DTranslate(self, tx, ty, tz)
    }

    /// 返回通过`(sx, sy, sz)` 缩放`self`后的`CATransform3D`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y 轴缩放
    ///   - sz:z 轴缩放
    /// - Returns:缩放后的`CATransform3D`
    @inlinable
    func scaledBy(x sx: CGFloat, y sy: CGFloat,
                  z sz: CGFloat) -> CATransform3D
    {
        CATransform3DScale(self, sx, sy, sz)
    }

    /// 返回通过向量`(x, y, z)`将`self`旋转`angle`角度之后的`CATransform3D`
    ///
    /// 如果向量的长度为零，则行为未定义。
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的z位置
    /// - Returns:旋转后的`CATransform3D`
    @inlinable
    func rotated(by angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        CATransform3DRotate(self, angle, x, y, z)
    }

    /// 反转`self`
    /// 如果`self`没有逆矩阵，则返回原始矩阵
    /// - Returns:`self`的倒置矩阵
    @inlinable
    func inverted() -> CATransform3D {
        CATransform3DInvert(self)
    }

    /// 将 `transform` 连接到`self`并返回一个新的`CATransform3D`
    /// - Parameter t2:要连接到`self`的`CATransform3D`
    /// - Returns:连接后的`CATransform3D`
    @inlinable
    func concatenating(_ t2: CATransform3D) -> CATransform3D {
        CATransform3DConcat(self, t2)
    }

    /// 通过`(tx, ty, tz)` 平移`self`
    /// - Parameters:
    ///   - tx:x 轴平移
    ///   - ty:y 轴平移
    ///   - tz:z 轴平移
    @inlinable
    mutating func translateBy(x tx: CGFloat, y ty: CGFloat, z tz: CGFloat) {
        self = CATransform3DTranslate(self, tx, ty, tz)
    }

    /// 通过`(sx, sy, sz)` 缩放`self`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y 轴缩放
    ///   - sz:z 轴缩放
    @inlinable
    mutating func scaleBy(x sx: CGFloat, y sy: CGFloat, z sz: CGFloat) {
        self = CATransform3DScale(self, sx, sy, sz)
    }

    /// 通过向量`(x, y, z)`将`self`旋转`angle`角度
    ///
    /// 如果向量的长度为零，则行为未定义。
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的y位置
    @inlinable
    mutating func rotate(by angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DRotate(self, angle, x, y, z)
    }

    /// 反转`self`
    @inlinable
    mutating func invert() {
        self = CATransform3DInvert(self)
    }

    /// 将 `transform` 连接到`self`
    /// - Parameter t2:要连接到`self`的`CATransform3D`
    @inlinable
    mutating func concatenate(_ t2: CATransform3D) {
        self = CATransform3DConcat(self, t2)
    }
}

// MARK: - 运算符
extension CATransform3D: Equatable {
    /// 判断两个CATransform3D是否相等
    /// - Returns:是否相等
    @inlinable
    public static func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        CATransform3DEqualToTransform(lhs, rhs)
    }
}
