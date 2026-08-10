# IMPLEMENTATION_PLAN.md — 実装フェーズ計画

コンテンツが「実際に動くコード例つきで詳しく解説」という工数の大きい方針のため、**1セッションで全部作ろうとせず、Phase単位で区切って実装する。** 各Phase終了時に必ずブラウザで動作確認すること。

---

## Phase 0: プロジェクト雛形

**やること:**
- ディレクトリ構成一式を作成(`docs/ARCHITECTURE.md`のツリー通り)
- `assets/css/base.css`, `components.css`, `lesson.css` の土台(`docs/DESIGN_SYSTEM.md`のトークンを反映)
- `assets/js/lessons-data.js` に **全25レッスン分のメタデータだけ**を先に登録(pathは埋めるが、リンク先のHTMLはまだ空でも可)
- `assets/js/progress.js` の実装(`getProgress`, `markComplete`, `markIncomplete`, `isComplete`, `getCompletionRate`, `renderProgressUI`)
- `assets/js/nav.js` の実装(共通ヘッダー・パンくず・前後リンクの描画)
- Prism.jsを`assets/vendor/prism/`に配置(ダウンロード時に**Lua言語コンポーネントを必ず含める**。core既定ではLuaのハイライトは含まれない)
- `index.html`(ロードマップ表示、progress連携込み)
- `category.html`(フィルタ機能込み)
- レッスンページの共通テンプレート1枚を作り、動作確認(進捗チェックが正しくlocalStorageに保存され、index.html/category.htmlの完了率に反映されるか)

**完了条件:** index.htmlとcategory.htmlが表示され、ダミーの1レッスンで完了チェック→進捗バーが更新されることを確認できる。また、全ページのCSS/JS参照が相対パスになっており(`CLAUDE.md`のルール参照)、`file://`直接オープンでも崩れないことを確認する。

---

## Phase 1: Tier 1(入門)— 5レッスン

対象: `t1-01` 〜 `t1-05`(`docs/CONTENT_OUTLINE.md`参照)

**完了条件:** 5レッスンすべてが結論→説明→コード例→注意点→補足の構成で書かれ、前後ナビゲーションが正しくつながっている。t1-03の「最初のスクリプトを作る」は、実際にFiveMサーバーで動作確認可能な内容であること(コードの正確性を最優先)。

---

## Phase 2: Tier 2(初級)— 5レッスン

対象: `t2-01` 〜 `t2-05`

**完了条件:** 前Phaseと同様。特に `t2-05-threads-loops` では「Wait()を省略した場合の危険性」を、初心者が具体的にイメージできる説明にする(前回の会話で触れたresmonの負荷の話などを軽く先取りしてもよい)。

---

## Phase 3: Tier 3(中級)— 5レッスン

対象: `t3-01` 〜 `t3-05`

**完了条件:** NUIの2レッスン(t3-01, t3-02)は、実際にHTML/CSS/JSのサンプルファイルも合わせて用意し、動作確認できる状態にする。

---

## Phase 4: Tier 4(中上級・okok/lb-phone)— 5レッスン

対象: `t4-01` 〜 `t4-05`

**完了条件:** `t4-03`(okok連携)と`t4-04`/`t4-05`(lb-phone連携)は、`docs/CONTENT_OUTLINE.md`に記載した構文を**一字一句そのまま**使用していること。このPhaseはコンテンツの正確性リスクが最も高いため、実装後に構文部分だけ再度`CONTENT_OUTLINE.md`と突き合わせて確認する。

---

## Phase 5: Tier 5(上級)— 5レッスン

対象: `t5-01` 〜 `t5-05`

**完了条件:** 前Phaseと同様。`t5-05`(高度なNUI)では、このサイト自体がビルドレス構成である理由(CLAUDE.md参照)にも軽く触れ、学習者が「なぜこのサイトはこう作られているか」を理解できるようにすると教育効果が高い。

---

## Phase 6: 仕上げ・公開

**やること:**
- 全ページのモバイル表示確認(レスポンシブ)
- キーボード操作のみでの進捗チェック・フィルタ操作確認(アクセシビリティ)
- 全リンク切れチェック(前後ナビゲーション、prerequisitesリンク)
- 全ページのCSS/JS/リンク参照が相対パスになっているか最終チェック(`/assets/...`のようなルート相対パスが残っていないか)
- `README.md`の更新(サイトの概要、ローカルでの開き方は反映済み。デプロイ後は公開URLを追記)
- **GitHub Pagesへの公開**:
  1. GitHubリポジトリを作成しpush
  2. Settings → Pages → Source: 「Deploy from a branch」、Branch: `main` / `(root)`
  3. `https://<user>.github.io/<repo>/` で表示確認(相対パスが正しく解決されているか特に注意)
  4. `file://`直接オープン・ローカルサーバー・GitHub Pagesの3パターンで最終比較確認

---

## Claude Codeセッションの進め方の目安

- 1回のセッション = 1 Phase を目安にする(Phase 0だけは土台作りなので少し重い)。
- 各Phase開始時に、そのPhaseで扱うレッスンIDを`docs/CONTENT_OUTLINE.md`から確認してから着手する。
- コードの正確性(特にPhase 4)に自信が持てない場合は、実装を止めて質問する(憶測で構文を埋めない)。
