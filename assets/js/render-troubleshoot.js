// assets/js/render-troubleshoot.js — トラブルシューティング・フローチャート(troubleshoot.html)のロジック

const TROUBLESHOOT_NODES = {
  root: {
    question: "今、どんな状況ですか?",
    options: [
      { label: "コンソールにエラーメッセージが表示される", next: "error-type" },
      { label: "エラーは出ないが、期待通りに動かない(反応がない)", next: "no-response" },
      { label: "resourceがそもそも起動しない(ensureしても反映されない)", next: "startup-fail" },
      { label: "ローカルでは動くのに、本番公開後だけ問題が起きる", next: "production-issue" },
    ],
  },
  "error-type": {
    question: "エラーメッセージにはどんな内容が含まれていますか?",
    options: [
      { label: "「attempt to call a nil value」「attempt to index a nil value」", result: "nil-value" },
      { label: "「Error parsing script」(構文エラー)", result: "syntax" },
      { label: "「execution of native XXXXXXXX failed」", result: "native" },
      { label: "上記に当てはまらない/エラー文をよく見ていない", result: "generic-error" },
    ],
  },
  "no-response": {
    question: "「反応がない」のは、具体的にどこですか?",
    options: [
      { label: "NUI(画面のボタン等)を押しても何も起きない", result: "nui" },
      { label: "TriggerServerEvent/TriggerClientEventを呼んでも実行されない", result: "event" },
      { label: "ox_target等のインタラクション自体が表示されない", result: "target" },
    ],
  },
  "startup-fail": {
    question: "起動時の状況は?",
    options: [
      { label: "「Could not find resource」と出る", result: "not-found" },
      { label: "依存先(dependency)のresourceが見つからないと言われる", result: "dependency" },
      { label: "特にエラーは出ないが、機能が動いていない", result: "silent-fail" },
    ],
  },
  "production-issue": {
    question: "本番でどんな問題が起きていますか?",
    options: [
      { label: "resourceのrestart(再起動)を繰り返すと不具合が出る", result: "restart" },
      { label: "複数人が同時に使うと不具合が出る", result: "concurrent" },
      { label: "サーバーが重い・カクつく", result: "performance" },
    ],
  },
};

const TROUBLESHOOT_RESULTS = {
  "nil-value": {
    title: "原因: 依存リソースの読み込み順、またはタイポの可能性",
    body: `
      <p>「attempt to call/index a nil value」は、<strong>まだ読み込まれていない変数・テーブルにアクセスしている</strong>ときに出る典型的なエラーです。ox_lib/oxmysqlなどの外部リソースを使っている場合、<code>fxmanifest.lua</code>の<code>dependency</code>指定漏れや、依存先resourceの起動順が原因であることが多いです。変数名のタイポも合わせて確認してください。</p>
      <ul>
        <li><a href="lessons/tier3-intermediate/06-exports-between-resources.html">Tier3-06: resource間のexports</a></li>
        <li><a href="lessons/tier3-intermediate/08-ox-lib-notify-progress.html">Tier3-08: ox_libの導入</a></li>
        <li><a href="lessons/tier3-intermediate/03-database-oxmysql.html">Tier3-03: oxmysqlの導入</a></li>
        <li><a href="reference/error-guide.html">エラーメッセージ集で該当箇所を検索する →</a></li>
      </ul>
    `,
  },
  syntax: {
    title: "原因: Luaの構文エラー",
    body: `
      <p>エラーメッセージに含まれる<strong>ファイル名と行番号</strong>を確認し、その付近の<code>end</code>・カンマ・カッコの対応関係を見直してください。</p>
      <ul>
        <li><a href="lessons/tier1-beginner/05-debug-basics.html">Tier1-05: デバッグの基本</a></li>
        <li><a href="reference/error-guide.html">エラーメッセージ集 →</a></li>
      </ul>
    `,
  },
  native: {
    title: "原因: native関数に渡している引数の型・個数の誤り",
    body: `
      <p>エラーに含まれるnative名で、公式リファレンスの引数の型(数値/文字列/vector3等)を確認してください。座標をvector3ではなくx,y,z個別で渡すべき箇所を間違えるケースがよくあります。</p>
      <ul>
        <li><a href="lessons/tier1-beginner/10-native-reference.html">Tier1-10: native関数の調べ方</a></li>
        <li><a href="reference/native-cheatsheet.html">ネイティブ関数早見表 →</a></li>
      </ul>
    `,
  },
  "generic-error": {
    title: "まずはエラーメッセージの全文を確認しましょう",
    body: `
      <p>F8コンソール(client側)またはサーバーを起動しているターミナル(server側)で、エラーメッセージの<strong>全文とファイル名・行番号</strong>を確認するのが最初の一歩です。確認できたら、このフローチャートの最初に戻って該当する内容を選び直してください。</p>
      <ul>
        <li><a href="lessons/tier1-beginner/05-debug-basics.html">Tier1-05: デバッグの基本</a></li>
      </ul>
    `,
  },
  nui: {
    title: "原因: NUIコールバックのcb()呼び忘れの可能性",
    body: `
      <p>Lua側の<code>RegisterNUICallback</code>ハンドラ内で<code>cb(...)</code>を呼び忘れると、NUI側の<code>fetch()</code>がいつまでも完了せず「反応がない」ように見えます。</p>
      <ul>
        <li><a href="lessons/tier3-intermediate/02-nui-callback.html">Tier3-02: NUIコールバック</a></li>
        <li><a href="reference/error-guide.html">エラーメッセージ集 →</a></li>
      </ul>
    `,
  },
  event: {
    title: "原因: イベント名の不一致、または登録漏れ",
    body: `
      <p>発火側(<code>TriggerServerEvent</code>/<code>TriggerClientEvent</code>)と受信側の<strong>イベント名が完全に一致しているか</strong>、受信側で<code>RegisterNetEvent</code>が登録されているか、client/serverの実行側を取り違えていないかを確認してください。</p>
      <ul>
        <li><a href="lessons/tier2-novice/01-events-basics.html">Tier2-01: イベントの基本</a></li>
        <li><a href="reference/error-guide.html">エラーメッセージ集 →</a></li>
      </ul>
    `,
  },
  target: {
    title: "原因: ゾーン座標・モデル名の不一致、またはox_target未起動",
    body: `
      <p><code>addBoxZone</code>の座標がずれている、<code>addModel</code>のモデル名が実際のプロップと一致していない、あるいはox_target自体が起動していない可能性があります。</p>
      <ul>
        <li><a href="lessons/tier3-intermediate/07-ox-target.html">Tier3-07: ox_targetの基本</a></li>
        <li><a href="reference/error-guide.html">エラーメッセージ集 →</a></li>
      </ul>
    `,
  },
  "not-found": {
    title: "原因: resource名のタイポ、または配置場所の誤り",
    body: `
      <p>フォルダ名と<code>ensure</code>に指定した名前が完全一致しているか、対象フォルダが<code>resources</code>ディレクトリ(または設定したパス)の直下に置かれているかを確認してください。</p>
      <ul>
        <li><a href="lessons/tier1-beginner/03-first-script.html">Tier1-03: 最初のスクリプトを作る</a></li>
        <li><a href="reference/error-guide.html">エラーメッセージ集 →</a></li>
      </ul>
    `,
  },
  dependency: {
    title: "原因: dependencyの指定漏れ、または起動順の問題",
    body: `
      <p><code>fxmanifest.lua</code>に<code>dependency 'xxx'</code>が正しく指定されているか、依存先resourceがserver.cfg内で自分より前に<code>ensure</code>されているかを確認してください。</p>
      <ul>
        <li><a href="lessons/tier1-beginner/04-fxmanifest.html">Tier1-04: fxmanifest.luaを理解する</a></li>
        <li><a href="reference/error-guide.html">エラーメッセージ集 →</a></li>
      </ul>
    `,
  },
  "silent-fail": {
    title: "原因の切り分けにはresmon・profilerの確認から",
    body: `
      <p>エラーが出ない場合、まずresourceが本当に起動しているかをresmonで確認し、次にprint()を要所要所に仕込んで、どこまで処理が進んでいるかを切り分けてください。</p>
      <ul>
        <li><a href="lessons/tier1-beginner/05-debug-basics.html">Tier1-05: デバッグの基本</a></li>
        <li><a href="lessons/tier5-advanced/01-performance-resmon.html">Tier5-01: resmonの使い方</a></li>
      </ul>
    `,
  },
  restart: {
    title: "原因: onResourceStopでの後片付け不足の可能性",
    body: `
      <p>resourceをrestartするたびにNPC/Blip/オブジェクトが増えていく場合、<code>onResourceStop</code>で生成物を削除する後片付け処理が抜けています。</p>
      <ul>
        <li><a href="lessons/tier2-novice/02-spawn-npc.html">Tier2-02: NPCの配置</a></li>
        <li><a href="lessons/tier3-intermediate/46-resource-testing-qa.html">Tier3-46: リソースのテスト/QA</a></li>
      </ul>
    `,
  },
  concurrent: {
    title: "原因: 複数人同時アクセスを想定した検証不足",
    body: `
      <p>1人で動作確認したときは問題がなくても、複数人が同時に使うと競合が起きることがあります。公開前チェックリストの手順で検証してください。</p>
      <ul>
        <li><a href="lessons/tier3-intermediate/46-resource-testing-qa.html">Tier3-46: リソースのテスト/QA</a></li>
        <li><a href="reference/security-checklist.html">公開前セキュリティチェックリスト →</a></li>
      </ul>
    `,
  },
  performance: {
    title: "原因の切り分けにはresmon・profilerを使う",
    body: `
      <p>「なんとなく重い」で対処するのではなく、resmonでどのresourceが重いかを数値で確認し、profilerで詳細な原因(イベント頻度・DBアクセス等)を特定してから対処してください。</p>
      <ul>
        <li><a href="lessons/tier5-advanced/01-performance-resmon.html">Tier5-01: パフォーマンス計測と最適化</a></li>
        <li><a href="lessons/tier5-advanced/11-performance-tuning-patterns.html">Tier5-11: パフォーマンス・チューニング実践パターン</a></li>
      </ul>
    `,
  },
};

function renderTroubleshootStep(nodeId, trail) {
  const container = document.getElementById("troubleshoot-content");
  if (!container) return;

  const node = TROUBLESHOOT_NODES[nodeId];

  const trailHTML = trail.length
    ? `<p class="text-small">${trail.map((t) => t.label).join(" → ")}</p>`
    : "";

  const optionsHTML = node.options
    .map((opt, i) => `<button type="button" class="wizard-option-button" data-index="${i}">${opt.label}</button>`)
    .join("");

  container.innerHTML = `
    ${trailHTML}
    <fieldset class="wizard-question">
      <legend>${node.question}</legend>
      <div class="wizard-option-list">${optionsHTML}</div>
    </fieldset>
    ${trail.length ? `<button type="button" id="troubleshoot-reset" class="wizard-cta">← 最初からやり直す</button>` : ""}
  `;

  container.querySelectorAll(".wizard-option-button").forEach((btn) => {
    btn.addEventListener("click", () => {
      const opt = node.options[Number(btn.dataset.index)];
      const newTrail = [...trail, { label: opt.label }];

      if (opt.result) {
        renderTroubleshootResult(opt.result, newTrail);
      } else {
        renderTroubleshootStep(opt.next, newTrail);
      }
    });
  });

  const resetBtn = document.getElementById("troubleshoot-reset");
  if (resetBtn) {
    resetBtn.addEventListener("click", () => renderTroubleshootStep("root", []));
  }
}

function renderTroubleshootResult(resultId, trail) {
  const container = document.getElementById("troubleshoot-content");
  if (!container) return;

  const result = TROUBLESHOOT_RESULTS[resultId];
  const trailHTML = `<p class="text-small">${trail.map((t) => t.label).join(" → ")}</p>`;

  container.innerHTML = `
    ${trailHTML}
    <div id="recommendation">
      <h2>${result.title}</h2>
      ${result.body}
    </div>
    <button type="button" id="troubleshoot-reset" class="wizard-cta">← 最初からやり直す</button>
  `;

  document.getElementById("troubleshoot-reset").addEventListener("click", () => renderTroubleshootStep("root", []));
}

function initTroubleshoot() {
  const container = document.getElementById("troubleshoot-content");
  if (!container) return;
  renderTroubleshootStep("root", []);
}

window.addEventListener("DOMContentLoaded", initTroubleshoot);
