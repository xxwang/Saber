import StoreKit

extension SKProduct: Saberable {}

// MARK: - 方法
public extension SaberExt where Base: SKProduct {
    /// 价格本地化
    /// - Returns: 本地化价格字符串
    func priceLocale() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.base.priceLocale

        return formatter.string(from: self.base.price)
    }
}
