import CoreLocation

// MARK: - 静态方法
public extension SaberExt where Base: CLGeocoder {
    /// 反地理编码(`坐标转地址`)
    /// - Parameters:
    ///   - completionHandler:回调函数
    static func reverseGeocode(location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: completionHandler)
    }

    /// 地理编码(`地址转坐标`)
    /// - Parameters:
    ///   - completionHandler:回调函数
    static func locationEncode(addr: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(addr, completionHandler: completionHandler)
    }
}
