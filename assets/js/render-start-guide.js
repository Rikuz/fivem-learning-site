// assets/js/render-start-guide.js — スタートガイド(start-guide.html)の診断ロジック

function computeStartingTier(q1, q2) {
  let score = 0;
  if (q1 === "other-lang") score += 1;
  if (q1 === "lua") score += 2;
  if (q2 === "player") score += 1;
  if (q2 === "scripter") score += 2;

  if (score === 0) return 1;
  if (score <= 2) return 2;
  return 3;
}

function trackCardsHTML() {
  const tracks = window.TRACKS || [];
  return `
    <div class="tier-section__cards">
      ${tracks
        .map(
          (track) => `
        <a class="lesson-card" href="tracks/${track.id}.html">
          <div class="lesson-card__badges">
            <span class="badge tier-badge">${track.emoji} 全${track.steps.length}ステップ</span>
          </div>
          <p class="lesson-card__title">${track.title}</p>
          <p class="lesson-card__summary">${track.summary}</p>
        </a>
      `
        )
        .join("")}
    </div>
  `;
}

function buildRecommendation(answers) {
  const { q1, q2, q3 } = answers;

  if (q3 === "specific-goal") {
    return `
      <h2>診断結果: プロジェクトトラックから選びましょう</h2>
      <p>作りたいものが決まっているなら、目的別に一直線で完成まで進める<strong>プロジェクトトラック</strong>が最短ルートです。近いものを選んでください。</p>
      ${trackCardsHTML()}
      <p class="version-note">トラックの各ステップは前提レッスンへのリンクも兼ねているので、知らない概念が出てきたらそのままレッスンに寄り道してから戻ってきても大丈夫です。</p>
    `;
  }

  if (q3 === "specific-technique") {
    return `
      <h2>診断結果: カテゴリ別一覧(逆引き検索)から探しましょう</h2>
      <p>特定の技術だけを知りたい場合は、「したいこと」から探せる<a href="category.html">カテゴリ別一覧</a>が向いています。キーワード検索はレッスン本文も対象なので、native関数名やスクリプト名で検索しても見つかります。</p>
      <p><a class="wizard-cta" href="category.html">カテゴリ別一覧を開く →</a></p>
    `;
  }

  // q3 === "undecided": 基礎から順番に学びたい場合、経験に応じた開始Tierを提案する
  const startTier = computeStartingTier(q1, q2);
  const tierInfo = window.TIER_INFO[startTier];
  const reasons = [];

  if (q1 === "none") reasons.push("プログラミング未経験の場合、Lua基礎から丁寧に扱うTier1がおすすめです。");
  if (q2 === "never") reasons.push("FiveMサーバーを触ったことがない場合、まず環境構築(Tier1)から始めましょう。");
  if (q1 === "lua" || q2 === "scripter") reasons.push("Lua/FiveMどちらかの経験があるので、基礎を飛ばして少し進んだTierから始めても大丈夫です。");
  if (reasons.length === 0) reasons.push("これまでの経験を踏まえると、このあたりから始めるとちょうど良いペースで進められます。");

  return `
    <h2>診断結果: Tier${startTier}(${tierInfo.emoji} ${tierInfo.label})から始めましょう</h2>
    <p>${reasons.join(" ")}</p>
    <p><a class="wizard-cta" href="category.html?tier=${startTier}">Tier${startTier}のレッスン一覧を見る →</a></p>
    <p>全体の流れを難易度順に見たい場合は<a href="index.html">難易度別ロードマップ</a>もあわせてご利用ください。</p>
  `;
}

function initStartGuide() {
  const form = document.getElementById("wizard-form");
  if (!form) return;

  form.addEventListener("submit", (event) => {
    event.preventDefault();

    const formData = new FormData(form);
    const answers = {
      q1: formData.get("q1"),
      q2: formData.get("q2"),
      q3: formData.get("q3"),
    };

    const recommendationEl = document.getElementById("recommendation");
    recommendationEl.innerHTML = buildRecommendation(answers);
    recommendationEl.classList.remove("hidden");
    recommendationEl.scrollIntoView({ behavior: "smooth", block: "start" });
  });
}

window.addEventListener("DOMContentLoaded", initStartGuide);
