# DESIGN_SYSTEM.md — デザインシステム

初学者が「圧迫感なく、今どのレベルにいるか一目でわかる」ことを最優先にする。派手さより明瞭さ。

## カラートークン(tier別)

| tier | 名称 | メインカラー | 背景色(淡) | 用途 |
|---|---|---|---|---|
| 1 | 入門 | `#2e7d32`(緑) | `#e8f5e9` | tierバッジ、進捗バーの該当区間 |
| 2 | 初級 | `#0277bd`(青) | `#e1f5fe` | 同上 |
| 3 | 中級 | `#ef6c00`(橙) | `#fff3e0` | 同上 |
| 4 | 中上級 | `#d84315`(赤橙) | `#fbe9e7` | 同上 |
| 5 | 上級 | `#4a148c`(紫) | `#f3e5f5` | 同上 |

**重要:** 色だけで難易度を区別しない。バッジには必ず「入門」「初級」などのテキストも併記する(色覚多様性・アクセシビリティ対応)。

## 共通カラー

| 用途 | 値 |
|---|---|
| 本文テキスト | `#1a1a1a` |
| 背景 | `#ffffff` |
| 補助テキスト・キャプション | `#666666` |
| ボーダー | `#e0e0e0` |
| 完了マーク(チェック) | `#2e7d32` |
| リンク | `#0277bd` |
| コードブロック背景 | `#1e1e1e`(Prism.jsのダークテーマに合わせる) |

## カテゴリバッジ(25種、絵文字+テキストの組み合わせ)

| カテゴリ | 表示 |
|---|---|
| environment | ⚙️ 環境構築 |
| lua-basics | 📘 Lua基礎 |
| npc-entity | 🧍 NPC・エンティティ操作 |
| nui | 🖥️ UI表示(NUI) |
| database | 🗄️ DB連携 |
| framework | 🧩 フレームワーク連携 |
| okok | 🔔 okok連携 |
| lb-phone | 📱 lb-phone連携 |
| events | 📡 イベント/通信 |
| performance | ⚡ パフォーマンス |
| security | 🔒 セキュリティ |
| vehicle | 🚗 車両操作 |
| animation | 🎭 アニメーション |
| targeting | 🎯 ターゲティング |
| ui-library | 🧰 UIライブラリ |
| world | 🌍 ワールド操作 |
| effects | 🎆 エフェクト |
| appearance | 👤 外見・キャラクリエイト |
| camera | 🎥 カメラ演出 |
| gameplay | 🎮 経済・ゲームプレイ |
| admin-tools | 🛠️ 管理者ツール |
| voice | 🎙️ ボイス・無線 |
| dispatch | 🚓 ディスパッチ |
| crime | 🚨 犯罪行為 |
| law-enforcement | 👮 警察業務 |
| housing | 🏠 住居・不動産 |
| monetization | 💳 収益化・課金 |

すべて中立なグレー系の背景(`#f0f0f0`)+黒文字のピル型バッジで統一し、tierカラーと視覚的にケンカしないようにする(tierは「進む方向」、カテゴリは「種類」という役割の違いを色でも表現する)。

## タイポグラフィ

```css
--font-body: -apple-system, BlinkMacSystemFont, "Hiragino Kaku Gothic ProN",
             "Noto Sans JP", sans-serif;
--font-code: "SFMono-Regular", Consolas, "Menlo", "Courier New", monospace;

--font-size-base: 16px;
--font-size-h1: 28px;
--font-size-h2: 20px;
--font-size-small: 14px;
--line-height-body: 1.7;   /* 日本語の可読性のため広めに */
```

## スペーシング

8pxを基準単位とする(`--space-1: 8px; --space-2: 16px; --space-3: 24px; --space-4: 32px;`)。

## 主なコンポーネント

| コンポーネント | 説明 |
|---|---|
| `.lesson-card` | タイトル・所要時間・tierバッジ・カテゴリタグ・完了チェックを持つカード。index.html / category.htmlで共通利用 |
| `.progress-bar` | 全体 or tier単位の完了率を表す横棒。ヘッダーに常時表示 |
| `.tier-timeline` | index.htmlのメイン。5つのtierを縦に並べ、各tierの中にlesson-cardを並べる |
| `.code-block` | Prism.jsでハイライトしたコード + 右上に「コピー」ボタン(クリックでクリップボードにコピー、ボタンのラベルが一瞬「コピーしました」に変わる)。実装は `navigator.clipboard.writeText` を優先使用し、失敗・非対応の場合(セキュアコンテキストでない環境など)は非表示の`<textarea>`+`document.execCommand('copy')`にフォールバックする。本番はGitHub Pages(HTTPS)なので通常はClipboard APIでそのまま動作する想定 |
| `.category-filter` | category.html上部のチェックボックス群。選択状態はURLクエリにも反映し、リンク共有できるようにする(例: `category.html?cat=nui,okok`) |
| `.prev-next-nav` | レッスン下部の「← 前のレッスン / 次のレッスン →」リンク |
| `.complete-toggle` | 「このレッスンを完了にする」チェックボックス。チェック時にprogress.jsを呼び、視覚的なフィードバック(✅アニメーション程度)を出す |

## レスポンシブ方針

- ブレークポイントは1つで十分(`max-width: 640px`でモバイル用レイアウトに切り替え)。
- モバイルではtier-timelineを横スクロールのタブ切り替えにしてもよい(必須ではない)。
- コードブロックは常に`overflow-x: auto`で横スクロール可能にする(縮小表示で文字を潰さない)。

## トーン

- 説明文は「〜します」「〜になります」のような丁寧語で統一し、専門用語には初出時に括弧で簡単な補足を入れる(CLAUDE.mdのルールと同一)。
- 「初心者にもわかるように」を意識しつつ、幼稚にしすぎない(相手は新人エンジニアであり、子ども向けではない)。
