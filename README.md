# FiveM スクリプト学習サイト — 設計一式

このフォルダは、Claude Codeに実装を依頼するための**設計ドキュメント一式**です。まだサイト本体(HTML/CSS/JS)は含まれていません。

## 使い方

1. このフォルダをそのままGitリポジトリのルートにする(`fivem-learning-site`などにリネームして良い)。
2. Claude Codeをこのフォルダで起動する。`CLAUDE.md`が自動的に読み込まれる。
3. `docs/IMPLEMENTATION_PLAN.md`のPhase 0から順に実装を依頼する。

## ファイル構成

| ファイル | 役割 |
|---|---|
| `CLAUDE.md` | Claude Codeへの最重要指示書。技術方針・レッスンの書き方ルール・テンプレートを定義 |
| `docs/ARCHITECTURE.md` | ページ構成、データモデル(lessons-data.js)、進捗管理(localStorage)の設計 |
| `docs/CONTENT_OUTLINE.md` | 全25レッスンのカリキュラム一覧。okok/lb-phone連携の正確な構文もここに記載済み |
| `docs/DESIGN_SYSTEM.md` | カラー・タイポグラフィ・コンポーネントのデザイン仕様 |
| `docs/IMPLEMENTATION_PLAN.md` | Phase 0〜6の段階的な実装計画 |

## この設計の要点(サマリー)

- **難易度別ロードマップ**(入門→初級→中級→中上級→上級)と**カテゴリ別横断検索**(NPC配置・UI表示・DB連携など)の両方から同じレッスンにアクセスできる構成。
- ビルドツール不要の素のHTML/CSS/JSで、`file://`で直接開いても動く設計。
- 進捗は`localStorage`に保存され、次回訪問時も続きから再開できる。
- 他スクリプトとの連携は**okokシリーズ**と**lb-phone**の2種類。実際のドキュメントで確認した正確なexport構文を`CONTENT_OUTLINE.md`に明記済み。
- 本番公開先は **GitHub Pages**(プロジェクトページ)。サブディレクトリ配下で配信されるため、CSS/JS/リンクは全て相対パスで統一する(`CLAUDE.md`参照)。

## 公開方法(GitHub Pages)

1. このリポジトリをGitHubにpushする(publicリポジトリ、または GitHub Pro などPages対応プラン)。
2. GitHubのリポジトリ画面で **Settings → Pages** を開く。
3. **Source** を「Deploy from a branch」、**Branch** を `main` / `(root)` に設定して保存する。
4. 数分後、`https://<GitHubユーザー名>.github.io/<リポジトリ名>/` で公開される。
5. 公開後、相対パスの参照が正しく動いているか(CSS崩れ・リンク切れがないか)を必ず確認する。
