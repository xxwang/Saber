import MapKit

// MARK: - 属性
public extension SaberExt where Base: MKMultiPoint {
    /// 表示`MKMultiPoint`的坐标数组
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: base.pointCount)
        base.getCoordinates(&coords, range: NSRange(location: 0, length: base.pointCount))
        return coords
    }
}
