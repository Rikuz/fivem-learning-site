// assets/js/render-index.js — トップページ(index.html)のロードマップ描画

function lessonCardHTML(lesson) {
  const tierInfo = window.TIER_INFO[lesson.tier];
  const progress = getProgress();
  const prereqsMet = lesson.prerequisites.every((id) => progress[id] === true);
  const locked = lesson.prerequisites.length > 0 && !prereqsMet;

  const categoryBadges = lesson.categories
    .map((key) => {
      const info = window.CATEGORY_INFO[key];
      return `<span class="badge category-badge">${info.emoji} ${info.label}</span>`;
    })
    .join("");

  return `
    <a class="lesson-card${locked ? " lesson-card--locked" : ""}" data-lesson-card="${lesson.id}" href="${lesson.path}">
      <div class="lesson-card__badges">
        <span class="badge tier-badge" data-tier="${lesson.tier}">${tierInfo.emoji} ${tierInfo.label}</span>
        ${categoryBadges}
      </div>
      <p class="lesson-card__title">${lesson.title} <span data-complete-check></span></p>
      <p class="lesson-card__summary">${lesson.summary}</p>
      <div class="lesson-card__meta">
        <span>所要時間目安: ${lesson.estimatedMinutes}分</span>
        ${locked ? `<span>🔒 前提レッスン未完了</span>` : ""}
      </div>
    </a>
  `;
}

function renderOverallProgress() {
  const el = document.getElementById("overall-progress");
  if (!el) return;
  el.setAttribute("data-progress-summary", "");
  el.innerHTML = `
    <div class="progress-summary">
      <span>全体の進捗</span>
      <div class="progress-bar"><div class="progress-bar__fill" style="width:0%"></div></div>
      <span data-progress-label>0% 完了</span>
    </div>
  `;
}

function renderTierTimeline() {
  const el = document.getElementById("roadmap");
  if (!el) return;
  const lessons = window.LESSONS || [];

  el.className = "tier-timeline";
  el.innerHTML = [1, 2, 3, 4, 5]
    .map((tier) => {
      const tierInfo = window.TIER_INFO[tier];
      const tierLessons = lessons.filter((l) => l.tier === tier);
      return `
        <section class="tier-section" style="--tier-main: var(--tier${tier}-main)">
          <div class="tier-section__header">
            <h2 class="tier-section__title">${tierInfo.emoji} ${tierInfo.label}</h2>
            <div class="progress-summary" data-progress-summary data-progress-summary-tier="${tier}">
              <div class="progress-bar"><div class="progress-bar__fill" style="width:0%"></div></div>
              <span data-progress-label>0% 完了</span>
            </div>
          </div>
          <div class="tier-section__cards">
            ${tierLessons.map(lessonCardHTML).join("")}
          </div>
        </section>
      `;
    })
    .join("");
}

function initIndexPage() {
  renderOverallProgress();
  renderTierTimeline();
  renderProgressUI();
}

window.addEventListener("DOMContentLoaded", initIndexPage);
