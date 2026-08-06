# 生命保険 一般課程試験｜学びスプリント

単一HTMLで動作する生命保険募集人・一般課程試験対策プロトタイプです。

## ローカル確認

`index.html` をブラウザで直接開くか、次のように静的サーバーで配信します。

```powershell
python -m http.server 8080
```

ブラウザで `http://localhost:8080/` を開いてください。

## GitHub Pages

このフォルダを専用GitHubリポジトリのルートへ配置し、GitHub Pagesの公開元をActionsに設定します。`main`へのpushで `.github/workflows/pages.yml` がデプロイします。

## 検証状況

- 収録問題：212問（6分野）
- 問題形式：○×、三択、複数選択
- 正解データ：参考サイト等の実データで主要論点をスポット確認済み
- 未実施：212問全件と参照270問の逐一完全監査
- 問題文は参考サイトから転用していません

## 次の人手工程

Apple Developer Program認証、App Store Connect登録、iPhone実機・TestFlight確認、App Review提出はアカウント所有者による操作が必要です。
