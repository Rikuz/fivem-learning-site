# FiveM スクリプト学習サイト

FiveM(GTA Vのマルチプレイヤー拡張フレームワーク)のスクリプト開発を、初めて触る人でも難易度を少しずつ上げながら学べる学習サイトです。ビルド不要の素のHTML/CSS/JavaScriptのみで作られています。

**公開URL: https://rikuz.github.io/fivem-learning-site/**

## 特徴

- **難易度別ロードマップ**(入門→初級→中級→中上級→上級、全25レッスン)と**カテゴリ別横断検索**(NPC配置・UI表示・DB連携など)の両方から同じレッスンにアクセスできます。
- 各レッスンは実際に動くコード例つき(結論→説明→コード例→注意点→補足の構成で統一)。
- 進捗は`localStorage`に保存され、次回訪問時も続きから再開できます。
- 他スクリプトとの連携は**okokシリーズ**・**lb-phone**・**ESX/QBCore/Qbox/ox**に対応。実際のドキュメントで確認した構文を使用しています(詳細は各レッスンの補足を参照)。

## ローカルでの確認方法

`index.html`をダブルクリックして直接開くだけで動作します(`file://`でも`fetch()`を使わない設計のため動作します)。

簡易サーバーで確認したい場合は以下でも起動できます。

```bash
python3 -m http.server 8000
# または
npx serve .
```

## ディレクトリ構成

| パス | 役割 |
|---|---|
| `CLAUDE.md` | Claude Codeへの実装指示書(技術方針・レッスンの書き方ルール・テンプレート) |
| `docs/ARCHITECTURE.md` | ページ構成、データモデル(lessons-data.js)、進捗管理(localStorage)の設計 |
| `docs/CONTENT_OUTLINE.md` | 全25レッスンのカリキュラム一覧。okok/lb-phone/ox_inventory連携の正確な構文もここに記載 |
| `docs/DESIGN_SYSTEM.md` | カラー・タイポグラフィ・コンポーネントのデザイン仕様 |
| `docs/IMPLEMENTATION_PLAN.md` | Phase 0〜6の段階的な実装計画 |
| `index.html` / `category.html` | トップ(難易度別ロードマップ)/ カテゴリ別一覧 |
| `assets/css/` | 共通スタイル(base / components / lesson) |
| `assets/js/` | レッスンデータ・進捗管理・描画ロジック |
| `assets/vendor/prism/` | コードハイライト用Prism.js(ローカル同梱、CDN依存なし) |
| `lessons/tier1-beginner/` 〜 `lessons/tier5-advanced/` | 各tierのレッスン本体(各5レッスン、計25) |

## 公開方法(GitHub Pages)

1. このリポジトリをGitHubにpushする(publicリポジトリ、または GitHub Pro などPages対応プラン)。
2. GitHubのリポジトリ画面で **Settings → Pages** を開く。
3. **Source** を「Deploy from a branch」、**Branch** を `main` / `(root)` に設定して保存する。
4. 数分後、`https://<GitHubユーザー名>.github.io/<リポジトリ名>/` で公開される。
5. 公開後、相対パスの参照が正しく動いているか(CSS崩れ・リンク切れがないか)を必ず確認する。

サブディレクトリ配下で配信されるプロジェクトページのため、CSS/JS/リンクの参照は全て相対パスで統一しています(`/assets/...`のようなルート相対パスは使用していません)。
