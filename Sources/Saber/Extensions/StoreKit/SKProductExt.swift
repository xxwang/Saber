import StoreKit

// MARK: - 属性
public extension SaberExt where Base == SKProduct {
    /// 本地化价格
    var localizedPrice: String? {
        let formatter = SKProduct.sb.priceFormatter
        formatter.locale = self.base.priceLocale
        return formatter.string(from: self.base.price)
    }

    /// 数字格式化
    private static let priceFormatter: NumberFormatter = {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        return priceFormatter
    }()
}

// MARK: - 方法
public extension SaberExt where Base == SKProduct {}
