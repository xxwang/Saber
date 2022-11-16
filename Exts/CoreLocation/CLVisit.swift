import CoreLocation
import Foundation

// MARK: - 类型转换
public extension SaberExt where Base: CLVisit {
    /// `CLVisit`转`CLLocation`
    /// - Returns: `CLLocation`
    func toLocation() -> CLLocation {
        return CLLocation(latitude: base.coordinate.latitude, longitude: base.coordinate.longitude)
    }
}
