import Combine
import Foundation
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

    deinit { updatesTask?.cancel() }

    var hasPremium: Bool { !purchasedProductIDs.isEmpty }
    var monthlyProduct: Product? { products.first { $0.id == Self.monthlyProductID } }
    var lifetimeProduct: Product? { products.first { $0.id == Self.lifetimeProductID } }

    func loadProductsAndEntitlements() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await Product.products(for: Self.productIDs)
                .sorted { $0.id == Self.monthlyProductID && $1.id != Self.monthlyProductID }
            await refreshEntitlements()
        } catch {
            errorMessage = "Unable to load purchase options. Please try again."
        }
    }

    func purchase(_ product: Product) async {
        isLoading = true
        defer { isLoading = false }
        do {
            switch try await product.purchase() {
            case .success(let verification): await handle(verification)
            case .pending: errorMessage = "Purchase approval is pending."
            case .userCancelled: break
            @unknown default: break
            }
        } catch {
            errorMessage = "Purchase could not be completed. Please try again."
        }
    }

    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            errorMessage = "Purchases could not be restored."
        }
    }

    private func refreshEntitlements() async {
        var active = Set<String>()
        for await verification in Transaction.currentEntitlements {
            guard case .verified(let transaction) = verification,
                  transaction.revocationDate == nil,
                  transaction.expirationDate.map({ $0 > Date() }) ?? true else { continue }
            active.insert(transaction.productID)
        }
        purchasedProductIDs = active
    }

    private func handle(_ verification: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = verification else {
            errorMessage = "Purchase verification failed."
            return
        }
        if transaction.revocationDate == nil,
           transaction.expirationDate.map({ $0 > Date() }) ?? true {
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
