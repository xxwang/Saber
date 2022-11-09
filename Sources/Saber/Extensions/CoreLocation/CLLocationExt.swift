import CoreLocation
import Foundation

// MARK: - 静态方法
public extension CLLocation {
    /// 两个`CLLocation`之间的距离(`米`)
    /// - Parameters:
    ///   - start:开始位置
    ///   - end:结束位置
    /// - Returns:距离
    static func distance(_ start: CLLocation, end: CLLocation) -> Double {
        return start.distance(from: end)
    }

    /// 计算两点之间的大圆路径的中间点
    /// - Parameters:
    ///   - start:开始位置
    ///   - end:结束位置
    /// - Returns:表示中间点的位置
    static func midLocation(_ start: CLLocation, _ end: CLLocation) -> CLLocation {
        let lat1 = Double.pi * start.coordinate.latitude / 180.0
        let long1 = Double.pi * start.coordinate.longitude / 180.0
        let lat2 = Double.pi * end.coordinate.latitude / 180.0
        let long2 = Double.pi * end.coordinate.longitude / 180.0

        let bxLoc = cos(lat2) * cos(long2 - long1)
        let byLoc = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bxLoc) * (cos(lat1) + bxLoc) + (byLoc * byLoc)))
        let mlong = long1 + atan2(byLoc, cos(lat1) + bxLoc)

        return CLLocation(latitude: mlat * 180 / Double.pi, longitude: mlong * 180 / Double.pi)
    }
}

// MARK: - 方法
public extension CLLocation {

        /// 计算`self`和另一个点之间的大圆路径的中间点
        /// - Parameter point: 结束位置
        /// - Returns: 表示中间点的位置
    func midLocation(to point: CLLocation) -> CLLocation {
        return CLLocation.midLocation(self, point)
    }

    /// 计算到另一个`CLLocation` 的方位角
    /// - Parameters:
    ///   - destination:计算方位的位置
    /// - Returns:在 `0°... 360° `范围内计算出的方位角
    func bearing(to destination: CLLocation) -> Double {
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0

        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1)
        )
        let degrees = rads * 180 / Double.pi

        return (degrees + 360).truncatingRemainder(dividingBy: 360)
    }
}

// MARK: - CLLocation数组
public extension Array where Element: CLLocation {
    /// 根据地球的曲率计算数组中每个位置之间的距离之和
    /// - Parameter unit:返回距离的长度单位
    /// - Returns:以指定单位表示的距离
    @available(tvOS 10.0, macOS 10.12, watchOS 3.0, *)
    func distance(unitLength unit: UnitLength) -> Measurement<UnitLength> {
        guard count > 1 else {
            return Measurement(value: 0.0, unit: unit)
        }
        var distance: CLLocationDistance = 0.0
        for idx in 0 ..< count - 1 {
            distance += self[idx].distance(from: self[idx + 1])
        }
        return Measurement(value: distance, unit: UnitLength.meters).converted(to: unit)
    }
}
