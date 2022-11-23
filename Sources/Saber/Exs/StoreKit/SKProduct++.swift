import StoreKit

// MARK: - 方法
public extension SaberEx where Base: SKProduct {
    /// 本地化`商品价格`
    /// - Returns: 本地化价格字符串
    func localePrice() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = base.priceLocale
        return formatter.string(from: base.price)
    }
}
