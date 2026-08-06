# SwiftUI / WKWebViewラッパー

`StudySprintApp.swift`、`ContentView.swift`、`PurchaseManager.swift`、`PaywallView.swift`をXcodeのiOS Appプロジェクトへ追加し、ルートの`index.html`をアプリバンドルへ含めます。

`WKWebView`の標準データストアを使うため、HTML側の`localStorage`による学習履歴は端末内に保存されます。

## App Store Connectの商品ID

先にApp Store Connectで、次の商品を同じBundle IDのアプリへ登録してください。

- 自動更新サブスク（月額）: `com.allsunday1122.seiho.ippan.premium.monthly`
- 買い切り（Non-Consumable）: `com.allsunday1122.seiho.ippan.premium.lifetime`

価格・表示名・説明・サブスクリプショングループはApp Store Connectで設定します。商品登録後、SandboxまたはStoreKit Configurationで購入・復元・失効を確認してください。
