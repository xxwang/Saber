import MapKit

// MARK: - 构造方法
public extension MKPolyline {
    /// 根据提供的坐标数组创建一条新的线段
    /// - Parameters coordinates:`CLLocationCoordinate2D`数组
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        var refCoordinates = coordinates
        self.init(coordinates: &refCoordinates, count: refCoordinates.count)
    }
}
