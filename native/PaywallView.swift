import StoreKit
import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.orange)
                Text("Premium")
                    .font(.title2.bold())
                Text("Unlock 60-question challenges and exam-round study modes.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if let monthly = purchases.monthlyProduct {
                    purchaseButton(title: "Monthly subscription", detail: "First 7 days free, then monthly", product: monthly)
                }
                if let lifetime = purchases.lifetimeProduct {
                    purchaseButton(title: "Lifetime purchase", detail: "One payment, permanent access", product: lifetime)
                }

                Button("Restore purchases") { Task { await purchases.restorePurchases() } }
                    .buttonStyle(.borderless)

                if purchases.products.isEmpty && !purchases.isLoading {
                    Text("Purchase options will appear after App Store Connect products are configured.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                if let error = purchases.errorMessage {
                    Text(error).font(.footnote).foregroundStyle(.red).multilineTextAlignment(.center)
                }
                Spacer()
            }
            .padding(24)
            .navigationTitle("Premium")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
    }

    @ViewBuilder
    private func purchaseButton(title: String, detail: String, product: Product) -> some View {
        Button { Task { await purchases.purchase(product) } } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline)
                    Text(detail).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Text(product.displayPrice).font(.headline)
            }
            .padding()
            .background(.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .disabled(purchases.isLoading)
    }
}
