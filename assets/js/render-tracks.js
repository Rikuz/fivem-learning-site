// assets/js/render-tracks.js — トラック一覧(tracks.html)・トラック詳細(tracks/*.html)の描画

function getTrackCompletionRate(track) {
  const progress = getProgress();
  const total = track.steps.length;
  if (total === 0) return 0;
  const done = track.steps.filter((s) => progress[s.id] === true).length;
  return Math.round((done / total) * 100);
}

function trackCardHTML(track) {
  const rate = getTrackCompletionRate(track);
  return `
    <a class="lesson-card" data-track-card="${track.id}" href="tracks/${track.id}.html">
      <div class="lesson-card__badges">
        <span class="badge tier-badge">${track.emoji} 全${track.steps.length}ステップ</span>
      </div>
      <p class="lesson-card__title">${track.title}</p>
      <p class="lesson-card__summary">${track.summary}</p>
      <div class="lesson-card__meta">
        <span>ゴール: ${track.goal}</span>
      </div>
      <div class="progress-bar" data-track-progress-bar>
        <div class="progress-bar__fill" style="width: ${rate}%"></div>
      </div>
      <div class="lesson-card__meta"><span>${rate}% 完了</span></div>
    </a>
  `;
}

function renderTracksList() {
  const el = document.getElementById("tracks-list");
  if (!el) return;

  const tracks = window.TRACKS || [];
  el.className = "tier-section__cards";
  el.innerHTML = tracks.map(trackCardHTML).join("");
}

function trackStepHTML(step, index) {
  const isLesson = step.type === "lesson";
  const item = isLesson ? findLessonById(step.id) : findExerciseById(step.id);

  if (!item) {
    return `<li class="track-step track-step--missing">#${index + 1} ${step.id}(未登録)</li>`;
  }

  const root = computeSiteRoot();
  const title = isLesson ? item.title : item.title;
  const typeLabel = isLesson ? "レッスン" : "演習";

  return `
    <li class="track-step" data-lesson-card="${step.id}">
      <span class="track-step__index">${index + 1}</span>
      <div class="track-step__body">
        <a class="track-step__link" href="${root}${item.path}">
          <span class="badge category-badge">${typeLabel}</span>
          ${title}
          <span data-complete-check></span>
        </a>
        <p class="track-step__note">${step.note}</p>
      </div>
    </li>
  `;
}

function renderTrackDetail() {
  const el = document.getElementById("track-detail");
  if (!el) return;

  const trackId = document.body.dataset.trackId;
  const track = findTrackById(trackId);
  if (!track) return;

  document.title = `${track.title} | プロジェクトトラック | FiveMスクリプト学習`;

  const headerEl = document.getElementById("track-header");
  if (headerEl) {
    headerEl.innerHTML = `
      <h1>${track.emoji} ${track.title}</h1>
      <p>${track.summary}</p>
      <p><strong>ゴール:</strong> ${track.goal}</p>
    `;
  }

  el.className = "track-step-list";
  el.innerHTML = `<ol class="track-step-list__ol">${track.steps.map(trackStepHTML).join("")}</ol>`;
}

function initTracksPage() {
  renderTracksList();
  renderProgressUI();
}

function initTrackDetailPage() {
  renderTrackDetail();
  renderProgressUI();
}

window.addEventListener("DOMContentLoaded", () => {
  if (document.getElementById("tracks-list")) initTracksPage();
  if (document.getElementById("track-detail")) initTrackDetailPage();
});
