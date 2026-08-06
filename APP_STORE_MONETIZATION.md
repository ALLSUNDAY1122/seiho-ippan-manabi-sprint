# 課金・TestFlight申請メモ

## 商品

| 種別 | Product ID | 用途 |
|---|---|---|
| Auto-Renewable Subscription（月額） | `com.allsunday1122.seiho.ippan.premium.monthly` | プレミアム機能を1か月利用 |
| Non-Consumable（買い切り） | `com.allsunday1122.seiho.ippan.premium.lifetime` | プレミアム機能を永続利用 |

プレミアム対象は、60問チャレンジと試験回・分野別モードです。ブラウザ版は価値確認のため制限なし、StoreKitを使うネイティブ版だけ購入状態で制御します。

## App Store Connectで本人が行う操作

1. 対象アプリを作成し、Bundle IDをXcodeプロジェクトと一致させる。
2. Monetization → Subscriptionsでサブスクリプショングループと月額商品を登録する。
3. Monetization → In-App Purchasesで買い切り商品をNon-Consumableとして登録する。
4. 各商品の表示名、説明、価格、審査用スクリーンショットを設定する。
5. Paid Apps Agreement、税務・銀行情報を確認する。
6. 利用規約URL・プライバシーポリシーURLを登録する。

## TestFlight確認項目

- StoreKitの購入・購入キャンセル・購入復元
- 月額サブスクの更新・期限切れ・失効
- 買い切りの再インストール後の復元
- 未購入時にプレミアム機能がロックされること
- 購入後に60問チャレンジ・試験回/分野別が開くこと
- 機内モード時の既存学習履歴と購入状態の表示

## まだ人間の操作が必要な工程

Apple Developerログイン、Bundle ID登録、App Store Connectの商品登録、署名付きiOSビルド、TestFlightへのアップロードと実機確認は、Apple IDの2要素認証を伴うため本人操作が必要です。TestFlightのビルドはApp Store Connectへアップロード後に処理され、最大90日間テストできます。
