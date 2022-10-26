import CoreLocation
import Foundation

// MARK: - 静态方法
public extension CLGeocoder {
    /// 地理信息反编码(坐标转地址)
    /// - Parameters:
    ///   - completionHandler: 回调函数
    static func reverseGeocode(location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: completionHandler)
    }

    /// 地理信息编码(地址转坐标)
    /// - Parameters:
    ///   - completionHandler: 回调函数
    static func locationEncode(addr: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addr, completionHandler: completionHandler)
    }
}
