import Foundation
import Combine
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    static let monthlyProductID = "com.allsunday1122.seiho.ippan.premium.monthly"
    static let lifetimeProductID = "com.allsunday1122.seiho.ippan.premium.lifetime"
    static let productIDs: Set<String> = [monthlyProductID, lifetimeProductID]

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private var updatesTask: Task<Void, Never>?

    private init() {
        updatesTask = listenForTransactions()
        Task { await loadProductsAndEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
    }

    var hasPremium: Bool {
        !purchasedProductIDs.isEmpty
    }

    var monthlyProduct: Product? {
        products.first { $0.id == Self.monthlyProductID }
    }

    var lifetimeProduct: Product? {
        products.first { $0.id == Self.lifetimeProductID }
    }

    func loadProductsAndEntitlements() async {
        isLoading = true
        defer { isLoading = false }

        do {
            products = try await Product.products(for: Self.productIDs)
                .sorted { lhs, rhs in
                    lhs.id == Self.monthlyProductID && rhs.id != Self.monthlyProductID
                }
            await refreshEntitlements()
        } catch {
            errorMessage = "商品情報を読み込めませんでした。通信状態を確認してください。"
        }
    }

    func purchase(_ product: Product) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(verification)
            case .pending:
                errorMessage = "購入の承認待ちです。"
            case .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = "購入を完了できませんでした。もう一度お試しください。"
        }
    }

    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            errorMessage = "購入を復元できませんでした。"
        }
    }

    private func refreshEntitlements() async {
        var active = Set<String>()
        for await verification in Transaction.currentEntitlements {
            if let productID = await verifiedActiveProductID(from: verification) {
                active.insert(productID)
            }
        }
        purchasedProductIDs = active
    }

    private func verifiedActiveProductID(
        from verification: VerificationResult<Transaction>
    ) async -> String? {
        guard case .verified(let transaction) = verification else { return nil }
        guard transaction.revocationDate == nil else { return nil }
        if let expirationDate = transaction.expirationDate, expirationDate <= Date() {
            return nil
        }
        await transaction.finish()
        return transaction.productID
    }

    private func handle(_ verification: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = verification else {
            errorMessage = "購入の検証に失敗しました。"
            return
        }

        if transaction.revocationDate == nil,
           transaction.expirationDate == nil || transaction.expirationDate! > Date() {
            purchasedProductIDs.insert(transaction.productID)
        } else {
            purchasedProductIDs.remove(transaction.productID)
        }
        await transaction.finish()
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await verification in Transaction.updates {
                await self?.handle(verification)
            }
        }
    }
}
