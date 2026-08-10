# ARCHITECTURE.md — 技術アーキテクチャ設計

## 全体の関係図

```
                     ┌───────────────────────────┐
                     │ assets/js/lessons-data.js │  ← 全レッスンの唯一の情報源(Single Source of Truth)
                     └─────────────┬─────────────┘
              ┌────────────────────┼────────────────────┐
              ▼                    ▼                    ▼
      index.html            category.html         lessons/tierX/*.html
   (難易度別ロードマップ)   (カテゴリ別・横断検索)      (個別レッスン本体)
              │                    │                    │
              └────────────────────┴────────────────────┘
                                    │
                                    ▼
                        assets/js/progress.js
                      (localStorageで進捗を一元管理)
```

すべてのページが `lessons-data.js` を共通の情報源として参照するため、**レッスンを1件追加・変更すれば、ロードマップ・カテゴリ一覧・前後ナビゲーション・進捗率のすべてに自動的に反映される**設計にする。

---

## ページ種別

### 1. `index.html` — 難易度別ロードマップ
- 5つのtier(入門〜上級)を縦のタイムラインとして表示。
- 各tierの中に、そのtierに属するレッスンをカード表示(タイトル・所要時間目安・完了チェック)。
- ヘッダーに「全体の完了率」を進捗バーで表示。
- 前提条件(`prerequisites`)を満たしていないレッスンは薄く表示する等、視覚的に「次はここ」がわかるようにする(必須ではないが推奨)。

### 2. `category.html` — カテゴリ別一覧・したいこと逆引き検索
- カテゴリタグ(NPC操作・UI表示・DB連携など)のチェックボックスで複数選択フィルタ。
- 難易度(tier)でも同時に絞り込み可能。
- フィルタ結果をカード一覧で表示。カードには該当レッスンのtierバッジとカテゴリタグを表示。
- 「このカテゴリを使うと何ができるか」の一言サマリーをカテゴリ見出しごとに表示する(例: 「UI表示 — プレイヤー画面にHTML/CSSで作ったオリジナルUIを表示できるようになります」)。
- **キーワード検索(逆引き辞書)**: テキスト入力欄で「発火させたい」「NPCを配置したい」のような自然文を入力すると、各レッスンの`keywords`/タイトル/サマリーに部分一致するものを一覧表示する。カテゴリ・tierチェックボックスとAND条件で組み合わせられる。検索語もURLクエリ(`?q=...`)に反映し、リンク共有できるようにする。

### 3. `lessons/tierX/*.html` — 個別レッスンページ
- `CLAUDE.md` 記載の共通テンプレートに従う。
- 結論→説明→コード例→注意点→補足の順で固定。

---

## データモデル: `lessons-data.js`

```js
// assets/js/lessons-data.js
const LESSONS = [
  {
    id: "t1-01-setup-environment",   // 一意のID。tier番号-連番-スラッグ
    title: "開発環境を整える",
    tier: 1,                          // 1=入門, 2=初級, 3=中級, 4=中上級, 5=上級
    categories: ["environment"],      // 複数可。docs/CONTENT_OUTLINE.mdのカテゴリキー一覧に準拠
    prerequisites: [],                 // 前提レッスンのid配列
    path: "lessons/tier1-beginner/01-setup-environment.html",
    estimatedMinutes: 20,
    summary: "FiveMサーバーの起動、VSCode、Gitなど開発に必要な環境を整える",
    keywords: ["ローカルサーバーを立てたい", "FiveMサーバーを起動したい", "開発環境を作りたい"] // 「したいこと」から探す逆引き検索(category.html)で使う自然文キーワード
  },
  // ... 全レッスン分をここに列挙(docs/CONTENT_OUTLINE.md参照)
];

// 他のJSファイルから使えるようにグローバルに公開
window.LESSONS = LESSONS;
```

---

## 進捗管理: `localStorage` 設計

**キー:** `fivem-learn-progress`
**値(JSON文字列):**
```json
{
  "t1-01-setup-environment": true,
  "t1-02-lua-basics": false
}
```

`assets/js/progress.js` が担当する関数:

| 関数 | 役割 |
|---|---|
| `getProgress()` | localStorageから読み込み、パースして `{id: boolean}` オブジェクトを返す。存在しない場合は空オブジェクト |
| `markComplete(lessonId)` / `markIncomplete(lessonId)` | 完了状態を切り替えてlocalStorageに保存 |
| `isComplete(lessonId)` | 指定レッスンが完了済みかを返す |
| `getCompletionRate(tier)` | tier省略時は全体、指定時はそのtierのみの完了率(%)を計算 |
| `renderProgressUI()` | 各ページ読み込み時に呼び出し、進捗バーやカードのチェックマークをDOMに反映する |

**注意:** `localStorage` はブラウザ単位・ドメイン単位の保存のため、別ブラウザ/別端末では引き継がれない。将来的にアカウント同期が必要になった場合は、この関数群のインターフェースはそのままに、内部実装だけをサーバー連携に差し替えられるように、**progress.jsの外部からは`getProgress`/`markComplete`等の関数だけを呼ぶ**設計にしておくこと(直接localStorageを触るコードを他ファイルに書かない)。

---

## カテゴリ・タグ一覧(固定値。docs/CONTENT_OUTLINE.mdと同期させること)

| キー | 表示名 |
|---|---|
| `environment` | 環境構築 |
| `lua-basics` | Lua基礎 |
| `npc-entity` | NPC・エンティティ操作 |
| `nui` | UI表示(NUI) |
| `database` | DB連携 |
| `framework` | フレームワーク連携(ESX/QBCore) |
| `okok` | okokシリーズ連携 |
| `lb-phone` | lb-phone連携 |
| `events` | イベント/通信 |
| `performance` | パフォーマンス・デバッグ |
| `security` | セキュリティ |
| `vehicle` | 車両操作 |
| `animation` | アニメーション |
| `targeting` | ターゲティング(ox_target等) |
| `ui-library` | UIライブラリ(ox_lib等) |
| `world` | ワールド操作(天候・時間) |

---

## ナビゲーション(前後レッスンリンク)

`nav.js` が `document.body.dataset.lessonId` を読み取り、`LESSONS` 配列から該当レッスンを特定 → 同一tier内での配列順から前後のレッスンを算出してリンクを描画する。tierの最初/最後のレッスンでは、前のtierの最後 / 次のtierの最初にリンクさせ、tierを跨いでも迷わないようにする。

---

## アクセシビリティ・レスポンシブ対応

- カラーだけで難易度やカテゴリを区別しない(バッジにテキストも必ず併記する)。
- コードブロックはモバイルでも横スクロールできるようにする(`overflow-x: auto`)。
- 進捗チェックボックスはキーボード操作(Tab/Space)でも操作可能にする(ネイティブ`<input type="checkbox">`を使う)。
