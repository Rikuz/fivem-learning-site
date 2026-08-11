# CLAUDE.md — FiveM スクリプト学習サイト プロジェクト指示書

このファイルは、Claude Codeがこのリポジトリで作業する際に**最初に必ず読む**指示書です。
実装を始める前に `docs/ARCHITECTURE.md`、`docs/CONTENT_OUTLINE.md`、`docs/DESIGN_SYSTEM.md`、`docs/IMPLEMENTATION_PLAN.md` にも目を通してください。

---

## プロジェクト概要

FiveM(GTA Vのマルチプレイヤー拡張フレームワーク)のスクリプト開発を、**初めて触る人でも難易度を少しずつ上げながら学べる学習サイト**を構築する。

- 各レッスンには**実際に動くコード例**を必ず含める(コピペで動く状態。省略する場合は理由を明記)。
- 「NPCを配置できる」「UIを表示できる」「lb-phoneにアプリを作れる」のように**「できるようになること」を軸にカテゴリ分け**する。
- 「難易度別ロードマップ(順番に進む)」と「カテゴリ別一覧(横断的に探す)」の**両方の入口**から同じレッスンにたどり着けるようにする。
- 他スクリプトとの連携は **okokシリーズ** と **lb-phone** の2種類を扱う。

---

## 技術方針(なぜこの構成か)

| 決定事項 | 理由 |
|---|---|
| ビルドツール・フレームワークなし。素のHTML/CSS/JavaScriptのみ | Claude Codeが1ファイルずつ確実に生成・検証できる。ユーザーが `npm install` 不要でそのままブラウザで確認できる。GitHub Pagesなど任意の静的ホスティングにそのまま置ける |
| コードハイライトは Prism.js(CDN読み込み) | ビルド不要で軽量。`assets/vendor/prism/` にローカルコピーを置き、オフラインでも動くようにする(CDN依存を避ける)。ダウンロード時は **Lua言語コンポーネントを必ず含める**(Prism coreの初期状態にはLuaのハイライトが含まれていない) |
| レッスンデータは `assets/js/lessons-data.js` に **JS配列**として持つ(JSONをfetchしない) | `file://` で `index.html` を直接ダブルクリックして開いた場合、`fetch()` はCORSエラーで失敗する。スクリプトタグで読み込むJS配列ならサーバーなしでも動く |
| 進捗管理は `localStorage` | サーバー・DB不要。ユーザーの要望通り「ブラウザに保存して次回も続きから」を満たす。スキーマは `docs/ARCHITECTURE.md` 参照 |
| 本番公開先は **GitHub Pages**(プロジェクトページ形式) | 無料・HTTPS配信・素のHTML/CSS/JSをpushするだけで公開できる。ただし `https://<user>.github.io/<repo>/` のように**サブディレクトリ配下**で配信されるため、CSS/JS/リンクの参照は必ず相対パスで統一する(下記ルール参照)。これは `file://` 直接オープン対応とも両立する選択 |
| CSSフレームワークは **Pico.css(classless版、CDN不使用)** を土台として採用 | `assets/vendor/pico/pico.min.css` にローカル同梱し、Prism.jsと同じ「CDN非依存でオフラインでも動く」方針を踏襲。classless版はタグセレクタに直接スタイルを当てるため、独自クラス(`.lesson-card`等)を持つ既存コンポーネントの見た目とは衝突しない。**各HTMLの`<head>`では、Pico本体を既存の`base.css`/`components.css`より必ず先に読み込む**(後から読み込む自前CSSで上書きするため)。ただし`body>main`のような子孫結合子セレクタはPico側の詳細度が高いため、`base.css`側も`body > main`のように合わせている(単に`main`と書くと負ける)。配色は「疲れにくさ」を最優先し、純白/純黒を避けた低コントラスト寄りのパレット+`prefers-color-scheme`によるダークモード対応を`base.css`の`:root`で行う |

---

## ディレクトリ構成

```
fivem-learning-site/
├── CLAUDE.md
├── README.md
├── index.html                      # トップ: 難易度別ロードマップ(タイムライン表示)
├── category.html                   # カテゴリ別一覧(フィルタ・逆引き検索機能付き)
├── practice.html                   # 実践演習一覧(難易度順)
├── tracks.html                     # プロジェクトトラック一覧(目的別の通し道)
├── samples.html                    # サンプルコード一覧(演習と1対1対応する実際に動くリソース一式)
├── assets/
│   ├── css/
│   │   ├── base.css                # リセット・共通レイアウト・カラー変数
│   │   ├── components.css          # カード/バッジ/進捗バー等の部品
│   │   └── lesson.css              # レッスンページ・演習ページ・トラック詳細ページ・サンプル解説ページ専用スタイル
│   ├── js/
│   │   ├── lessons-data.js         # 全レッスンのメタデータ(唯一の情報源)
│   │   ├── exercises-data.js       # 全演習のメタデータ(唯一の情報源)
│   │   ├── tracks-data.js          # 全プロジェクトトラックのメタデータ(唯一の情報源)
│   │   ├── samples-data.js         # 全サンプルコードのメタデータ(唯一の情報源)
│   │   ├── progress.js             # localStorage読み書き・完了マーク処理
│   │   ├── render-index.js         # トップページのロードマップ描画
│   │   ├── render-category.js      # カテゴリ一覧ページの描画・フィルタ処理
│   │   ├── render-practice.js      # 演習一覧ページの描画
│   │   ├── render-tracks.js        # トラック一覧・トラック詳細ページの描画
│   │   ├── render-samples.js       # サンプルコード一覧ページの描画
│   │   └── nav.js                  # 共通ヘッダー/パンくず/前後レッスンリンクの描画
│   └── vendor/
│       ├── prism/                  # コードハイライト(prism.js / prism.css をローカル同梱)
│       └── pico/                   # CSSフレームワーク(pico.min.css、classless版をローカル同梱)
├── lessons/
│   ├── tier1-beginner/             # 入門
│   ├── tier2-novice/               # 初級
│   ├── tier3-intermediate/         # 中級
│   ├── tier4-upper-intermediate/   # 中上級(okok/lb-phone/Qbox/ox系含む)
│   └── tier5-advanced/             # 上級
├── practice/                       # 実践演習の詳細ページ(設計仕様のみ、完成コードは載せない)
├── tracks/                         # プロジェクトトラックの詳細ページ(順序付きチェックリスト)
├── samples/                        # サンプルコードの解説ページ+実際に動くリソース一式(演習と同数、1対1対応)
└── docs/
    ├── ARCHITECTURE.md
    ├── CONTENT_OUTLINE.md
    ├── EXERCISE_OUTLINE.md
    ├── TRACK_OUTLINE.md          # プロジェクトトラック(目的別の通し道)の設計書
    ├── DESIGN_SYSTEM.md
    └── IMPLEMENTATION_PLAN.md
```

---

## ローカルでの確認方法

`index.html` をダブルクリックして直接開くだけでも動作する設計にすること(fetchを使わないため)。
Prism.jsの一部機能やCSSの相対パスを確実に確認したい場合は、簡易サーバーでも良い。

```bash
# どちらでもOK
python3 -m http.server 8000
# または
npx serve .
```

---

## 公開方法(GitHub Pages)

本サイトは GitHub Pages のプロジェクトページとして公開する想定(`https://<user>.github.io/<repo>/`)。

- ビルド不要のため、リポジトリの `main`ブランチのルートをそのまま公開設定にできる(GitHubリポジトリの Settings → Pages → Source を「Deploy from a branch」「Branch: main / (root)」にする)。
- サブディレクトリ配下で配信される都合上、**CSS/JS/リンクの参照パスは必ず相対パスにする**(上記「レッスンページを書くときの必須ルール」参照)。ルート相対パス(`/assets/...`)は本番で壊れるので使わない。
- 公開後は `file://` 直接オープン・ローカルサーバー・GitHub Pagesの3パターンすべてで表示崩れやリンク切れがないか確認する(`docs/IMPLEMENTATION_PLAN.md` Phase 6 参照)。

---

## レッスンページを書くときの必須ルール

新しいレッスンHTMLを追加するときは、必ず以下を守ること。

1. **本文構成は「結論 → 説明 → コード例 → 注意点 → 補足」の順で固定する。**
   初学者が迷わないように、まず「このレッスンで何ができるようになるか」を一言で示し、次に仕組みの説明、動くコード、よくあるミス、発展的な内容の順に並べる。この順番は変えない。
2. **CSS/JSの参照パスは常に相対パスにする。先頭に`/`を付けた絶対パス(例: `/assets/css/base.css`)は禁止。**
   理由: `file://`で直接開いた場合はルート相対パスがファイルシステムのルートを指してしまい壊れる。また本番のGitHub Pagesはプロジェクトページとして `https://<user>.github.io/<repo>/` というサブディレクトリ配下で配信されるため、`/assets/...`は`https://<user>.github.io/assets/...`という誤ったURLになる。ルート直下(`index.html`, `category.html`)は `assets/css/base.css`、`lessons/tierX/*.html`(2階層下)は `../../assets/css/base.css` のように、常にそのファイルからの相対パスで書くこと。
3. **コードは省略しない。** コピー&ペーストしてそのまま動く状態で書く。省略する場合は理由をコメントで明記する。
4. **専門用語は初出時に簡単な補足を入れる。**(例: 「native関数(FiveMがゲームエンジンを直接操作するために提供する組み込み関数)」)
5. **各レッスンHTMLは同一のテンプレート構造を使う。** 下記「レッスンページテンプレート」を参照。テンプレートから外れる場合は理由をREADMEかコミットメッセージに残す。
6. `lessons/` にHTMLファイルを追加したら、**必ず同時に** `assets/js/lessons-data.js` にもエントリを追加する(id, title, tier, categories, prerequisites, path, estimatedMinutes, summary)。片方だけの更新は禁止(一覧・フィルタ・進捗率が壊れるため)。
7. ページの先頭付近で `assets/js/progress.js` を読み込み、「このレッスンを完了にする」チェックボックス/ボタンにレッスンIDを紐付ける。
8. 同一tier内の並び順(`lessons-data.js`の配列順)に従って、前/次のレッスンへのナビゲーションリンクを自動生成する(`nav.js`が担当)。

### レッスンページテンプレート(HTML構造の骨格)

```html
<!doctype html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <title><!-- レッスンタイトル --> | FiveMスクリプト学習</title>
  <link rel="stylesheet" href="../../assets/css/base.css">
  <link rel="stylesheet" href="../../assets/css/components.css">
  <link rel="stylesheet" href="../../assets/css/lesson.css">
  <link rel="stylesheet" href="../../assets/vendor/prism/prism.css">
</head>
<body data-lesson-id="<!-- 例: t4-03-okok-integration -->">
  <header id="site-header"></header> <!-- nav.jsが共通ヘッダーを注入 -->
  <nav id="breadcrumb"></nav>        <!-- nav.jsが パンくず を注入 -->

  <main>
    <div class="lesson-meta">
      <span class="badge tier-badge"><!-- 難易度バッジ --></span>
      <span class="badge category-badge"><!-- カテゴリタグ(複数可) --></span>
    </div>

    <h1><!-- レッスンタイトル --></h1>

    <section class="conclusion">
      <h2>結論</h2>
      <!-- このレッスンで何ができるようになるか、一言で -->
    </section>

    <section class="explanation">
      <h2>説明</h2>
      <!-- なぜそうなるか、仕組み -->
    </section>

    <section class="code-example">
      <h2>コード例</h2>
      <!-- <pre><code class="language-lua">...</code></pre> コピーボタン付き -->
    </section>

    <section class="pitfalls">
      <h2>注意点・よくあるミス</h2>
    </section>

    <section class="supplement">
      <h2>補足</h2>
    </section>

    <label class="complete-toggle">
      <input type="checkbox" id="mark-complete-checkbox">
      このレッスンを完了にする
    </label>
  </main>

  <nav id="prev-next-nav"></nav> <!-- nav.jsが前後リンクを注入 -->
  <footer id="site-footer"></footer>

  <script src="../../assets/js/lessons-data.js"></script>
  <script src="../../assets/js/progress.js"></script>
  <script src="../../assets/js/nav.js"></script>
  <script src="../../assets/vendor/prism/prism.js"></script>
  <script src="../../assets/js/code-copy.js"></script>
</body>
</html>
```

---

## 全文検索インデックス(assets/js/search-index.js)について

`category.html`の「したいことから探す」検索ボックスは、レッスンのtitle/summary/keywordsだけでなく<strong>本文全文</strong>も検索対象にしている。本文テキストは`assets/js/search-index.js`という自動生成ファイルに`SEARCH_INDEX`配列(`{id, text}`)として持たせている(fetchではなく他のdata.js群と同じくinline `<script>`読み込み、file://対応のため)。

- **`lessons/`配下にレッスンHTMLを追加・編集したら、必ず`node scripts/build-search-index.js`を再実行して`assets/js/search-index.js`を再生成すること。** `search-index.js`を手で直接編集しない。
- `scripts/build-search-index.js`は各レッスンHTMLの`<main>`内のテキストをタグ除去して抽出するだけの単純なNodeスクリプトで、`samples/`配下(サンプルコードのHTML)は対象外。
- サイト自体の閲覧にはビルド手順は不要(`search-index.js`は生成済みの状態でリポジトリにコミットされる)。このスクリプトは「レッスン内容が変わった後にインデックスを更新するための著者向けの補助ツール」であり、npm installやビルドパイプラインの一部ではない。

---

## 実践演習(practice/)のルール

レッスンとは別に、`practice.html`(一覧)と`practice/*.html`(詳細)からなる**実践演習**を用意している。詳細な仕様は`docs/EXERCISE_OUTLINE.md`を参照(演習にとっての唯一の正)。

1. **演習ページには完成コードを載せない。** レッスンは動くコードで教えるが、演習は「処理仕様・期待する動作・利用する依存関係・ディレクトリ構造」を箇条書きの**設計仕様**として提示し、学習者自身に実装させる。文章で「〜を作ってください」と指示するだけの書き方は禁止。
2. **必ずディレクトリ構造(ファイルツリー)を明記する。** どの機能をどのファイルに書くべきかが一目でわかるようにする。
3. **「関連レッスン」セクションで、実装に必要な既存レッスンへ直接リンクする。** 演習で使う概念がまだレッスンになければ、先にレッスンを追加してからリンクすること。
4. 演習ページのIDは`ex-XX-slug`形式とし、`assets/js/exercises-data.js`の`EXERCISES`配列にエントリを追加する(id, title, difficulty(1〜5), summary, path, relatedLessons, dependencies)。片方だけの更新は禁止。
5. `difficulty`のバッジ表示は`window.TIER_INFO`(🟢入門〜⚫上級)をそのまま流用し、レッスンの難易度感覚と統一する。
6. `practice/*.html`は`lessons/tierX/*.html`より1階層浅いため、アセット参照は`../assets/...`(`../../`ではない)。
7. `progress.js`の完了トグル(`body[data-lesson-id]`)は演習ページでも再利用してよいが、`index.html`の「全体の進捗」は`window.LESSONS`のみを対象とするため、演習の完了状態はレッスンの進捗率に影響しない。

---

## サンプルコード(samples/)について

演習(`practice/*.html`)には完成コードを載せない方針のため、あえて別の入口として`samples.html`(一覧)+ `samples/*.html`(各演習に対応するサンプルの解説ページ)+ `samples/<resource-name>/`(実際に動くリソース一式の実ファイル)を用意している。演習と同じ数(16件)、同じidで1対1対応する。

1. **`samples/<resource-name>/`には、対応する演習の「ディレクトリ構造」セクションに書かれているファイル名・構成をそのまま再現した実ファイルを置く。** マルチresource構成の演習(ex-07, ex-11)は、演習の指定通り複数のresourceディレクトリに分ける。
2. **`samples/ex-XX-slug.html`(解説ページ)には、実ファイルと同一内容のコードをレッスンページと同じ`<pre><code class="language-lua">`形式で埋め込む。** file://で直接開いた場合にfetch()が使えないため(CLAUDE.md冒頭の技術方針参照)、実ファイルの内容をこのページに動的読み込みさせることはできない。実ファイルを更新したら、解説ページの埋め込みコードも必ず同時に更新すること。
3. サンプルのidは対応する演習と全く同じ`ex-XX-slug`を使う。`assets/js/samples-data.js`の`SAMPLES`配列にエントリを追加する(id, title, difficulty, summary, dependencies, exercisePath, path, resources: [{name, files}])。
4. `samples/*.html`のbodyには`data-sample-id`(演習ページの`data-lesson-id`とは別属性)を付け、`nav.js`のパンくず・前後サンプルナビゲーションに使う。完了トグルチェックボックスは付けない(「サンプルを見た」と「演習を完了した」は別の状態のため)。
5. `samples/*.html`は`practice/*.html`と同じく1階層深い(`../assets/...`)。

---

## プロジェクトトラック(tracks/)について

「lb-phoneアプリを1本作りきる」「犯罪(ゲーム内)scriptを1本作りきる」のような目的ベースの通し道を、Tier別ロードマップ・カテゴリ逆引き検索に次ぐ第3の入口として実装済みの機能。`tracks.html`(一覧)+ `tracks/*.html`(各トラックの詳細ページ)からなり、データは`assets/js/tracks-data.js`の`TRACKS`配列(id, title, summary, goal, steps: [{type: 'lesson'|'exercise', id, note}])を唯一の情報源とする(レッスン/演習の本体は持たず、id経由で`lessons-data.js`/`exercises-data.js`を参照するだけの索引)。設計の詳細・各ステップの根拠は`docs/TRACK_OUTLINE.md`を参照。新しいトラックを追加する場合も、レッスン・演習と同様に「ドキュメント更新→データ追加→ページ作成→検証」の順を守ること。

---

## コンテンツの正確性について

- FiveMのnative関数名・Lua構文・`fxmanifest.lua`の書き方は公式ドキュメント(docs.fivem.net)の記法に合わせる。
- **okokシリーズ(okokNotify, okokTextUIなど)やlb-phoneとの連携コードは、`docs/CONTENT_OUTLINE.md`に記載した実際のexport構文を必ずそのまま使うこと。憶測でexport名や引数を作らない。**(過去にこれらの構文を実際のドキュメントで確認済み)
- 仕様がバージョンによって変わりうる箇所には「※このスクリプトのバージョンによって仕様が変わる場合があります。公式ドキュメントも確認してください」という一文を添える。

---

## 実装の進め方

`docs/IMPLEMENTATION_PLAN.md` のPhaseに沿って進める。**1セッションで全レッスンを一気に作ろうとしない。** Phaseごとに区切り、各Phase終了時にブラウザで実際に開いて動作確認すること(特にlocalStorageの進捗保存、前後レッスンリンク、カテゴリフィルタ)。

## デザイン

`docs/DESIGN_SYSTEM.md` のカラートークン・コンポーネント仕様に従う。独自のデザイン判断が必要な場合は「シンプルさ・読みやすさ・初学者への圧迫感の少なさ」を優先する。
