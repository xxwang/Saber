import CoreLocation
import Foundation

// MARK: - 属性
public extension CLLocationCoordinate2D {
    /// `CLLocationCoordinate2D`转`CLLocation`
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

// MARK: - 方法
public extension CLLocationCoordinate2D {
    /// 两个`CLLocationCoordinate2D`之间的距离(单位:`米`)
    /// - Parameter second:`CLLocationCoordinate2D`
    /// - Returns:`距离`
    func distance(with second: CLLocationCoordinate2D) -> Double {
        return location.distance(from: second.location)
    }
}
