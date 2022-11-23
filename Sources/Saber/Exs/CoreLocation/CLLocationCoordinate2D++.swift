import CoreLocation

extension CLLocationCoordinate2D: Saberable {}

// MARK: - 类型转换
public extension SaberEx where Base == CLLocationCoordinate2D {
    /// `CLLocationCoordinate2D`转`CLLocation`
    /// - Returns: `CLLocation`
    func toLocation() -> CLLocation {
        return CLLocation(latitude: base.latitude, longitude: base.longitude)
    }
}

// MARK: - 方法
public extension SaberEx where Base == CLLocationCoordinate2D {
    /// 两个`CLLocationCoordinate2D`之间的`距离`(单位:`米`)
    /// - Parameter second:`CLLocationCoordinate2D`
    /// - Returns: `Double`
    func distance(to second: CLLocationCoordinate2D) -> Double {
        return toLocation().distance(from: second.sb.toLocation())
    }
}
