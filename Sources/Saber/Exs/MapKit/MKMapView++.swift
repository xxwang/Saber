import MapKit

// MARK: - 方法
public extension SaberEx where Base: MKMapView {
    /// 注册大头针
    /// - Parameter name: 继承自`MKAnnotationView`的类型
    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func register<T: MKAnnotationView>(annotationViewWithClass name: T.Type) {
        base.register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: name))
    }

    /// 获取`可重用`的大头针
    /// - Parameter name: 继承自`MKAnnotationView`的类型
    /// - Returns: 继承自`MKAnnotationView`的对象
    func dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type) -> T? {
        return base.dequeueReusableAnnotationView(withIdentifier: String(describing: name)) as? T
    }

    /// 获取`可重用`的大头针
    /// - Parameters:
    ///   - name: 继承自`MKAnnotationView`的类型
    ///   - annotation: 大头针对象
    /// - Returns: 继承自`MKAnnotationView`的对象
    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func dequeueReusableAnnotationView<T: MKAnnotationView>(
        withClass name: T.Type,
        for annotation: MKAnnotation
    ) -> T? {
        guard let annotationView = base.dequeueReusableAnnotationView(
            withIdentifier: String(describing: name),
            for: annotation
        ) as? T else {
            fatalError("Couldn't find MKAnnotationView for \(String(describing: name))")
        }
        return annotationView
    }

    /// 缩放地图区域
    /// - Parameters:
    ///   - coordinates: 由`CLLocationCoordinate2D`数组构成的区域
    ///   - meter: 缩放单位`米`
    ///   - edgePadding: 边界距离
    ///   - animated: 是否动画
    func zoom(
        to coordinates: [CLLocationCoordinate2D],
        meter: Double,
        edgePadding: UIEdgeInsets,
        animated: Bool
    ) {
        guard !coordinates.isEmpty else { return }

        if coordinates.count == 1 {
            let coordinateRegion = MKCoordinateRegion(
                center: coordinates.first!,
                latitudinalMeters: meter,
                longitudinalMeters: meter
            )
            base.setRegion(coordinateRegion, animated: true)
        } else {
            let mkPolygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            base.setVisibleMapRect(mkPolygon.boundingMapRect, edgePadding: edgePadding, animated: animated)
        }
    }
}
