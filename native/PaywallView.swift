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
                Text("学びスプリント プレミアム")
                    .font(.title2.bold())
                Text("60問チャレンジと試験回・分野別モードを解放します。")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if let monthly = purchases.monthlyProduct {
                    purchaseButton(
                        title: "月額サブスク",
                        detail: "自動更新・いつでも解約可能",
                        product: monthly
                    )
                }
                if let lifetime = purchases.lifetimeProduct {
                    purchaseButton(
                        title: "買い切り",
                        detail: "一度の購入で永続利用",
                        product: lifetime
                    )
                }

                Button("購入を復元") {
                    Task { await purchases.restorePurchases() }
                }
                .buttonStyle(.borderless)

                if purchases.products.isEmpty && !purchases.isLoading {
                    Text("商品情報が未設定です。App Store Connectの商品登録後に表示されます。")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                if let error = purchases.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
            .padding(24)
            .navigationTitle("プレミアム")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
    }

    @ViewBuilder
    private func purchaseButton(title: String, detail: String, product: Product) -> some View {
        Button {
            Task { await purchases.purchase(product) }
        } label: {
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
