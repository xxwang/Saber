import MapKit

// MARK: - 方法
public extension MKMapView {
    /// 使用类类型注册`MKAnnotationView`
    /// - Parameters name:`MKAnnotationView` 类型.
    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func register<T: MKAnnotationView>(annotationViewWithClass name: T.Type) {
        register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: name))
    }

    /// 使用类类型获取可重用的`MKAnnotationView`
    /// - Parameters:
    ///   - name:`MKAnnotationView`类型
    /// - Returns:可选的`MKAnnotationView`对象
    func dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type) -> T? {
        return dequeueReusableAnnotationView(withIdentifier: String(describing: name)) as? T
    }

    /// 使用类类型获取可重用的`MKAnnotationView`
    /// - Parameters:
    ///   - name:`MKAnnotationView`类型
    ///   - annotation:地图视图的注释
    /// - Returns:可选类型`MKAnnotationView`对象
    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type, for annotation: MKAnnotation) -> T? {
        guard let annotationView = dequeueReusableAnnotationView(
            withIdentifier: String(describing: name),
            for: annotation
        ) as? T else {
            fatalError("Couldn't find MKAnnotationView for \(String(describing: name))")
        }

        return annotationView
    }

    /// 放大多个地图视图坐标
    /// - Parameters:
    ///   - coordinates:获取`CLLocationCoordinate2D`类型的数组
    ///   - meter:如果数组只有一个项,则它们的值为`meters`(`Double`).地图按给定的米放大
    ///   - edgePadding:使指定矩形周围可见的额外空间量(以屏幕点为单位)
    ///   - animated:动画控件采用布尔值.输入动画缩放的真实值
    func zoom(to coordinates: [CLLocationCoordinate2D], meter: Double, edgePadding: UIEdgeInsets, animated: Bool) {
        guard !coordinates.isEmpty else { return }

        if coordinates.count == 1 {
            let coordinateRegion = MKCoordinateRegion(
                center: coordinates.first!,
                latitudinalMeters: meter,
                longitudinalMeters: meter
            )
            setRegion(coordinateRegion, animated: true)
        } else {
            let mkPolygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            setVisibleMapRect(mkPolygon.boundingMapRect, edgePadding: edgePadding, animated: animated)
        }
    }
}
