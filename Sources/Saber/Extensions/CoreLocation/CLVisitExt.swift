import CoreLocation
import Foundation

// MARK: - 属性
public extension CLVisit {
    /// `CLVisit`转`CLLocation`
    var location: CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
