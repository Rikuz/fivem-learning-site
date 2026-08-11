// assets/js/render-samples.js — サンプルコード一覧ページ(samples.html)の描画

function sampleCardHTML(sample) {
  const difficultyInfo = window.TIER_INFO[sample.difficulty];
  const depsText = sample.dependencies.length ? sample.dependencies.join(" / ") : "FiveM標準のみ(追加リソース不要)";
  const resourceText = sample.resources.length > 1 ? `${sample.resources.length}resource構成` : "1resource構成";

  return `
    <a class="lesson-card" data-lesson-card="${sample.id}" href="${sample.path}">
      <div class="lesson-card__badges">
        <span class="badge tier-badge" data-tier="${sample.difficulty}">${difficultyInfo.emoji} 難易度: ${difficultyInfo.label}</span>
      </div>
      <p class="lesson-card__title">${sample.title} <span data-complete-check></span></p>
      <p class="lesson-card__summary">${sample.summary}</p>
      <div class="lesson-card__meta">
        <span>${resourceText} / 依存: ${depsText}</span>
      </div>
    </a>
  `;
}

function renderSampleList() {
  const el = document.getElementById("sample-list");
  if (!el) return;

  const samples = [...(window.SAMPLES || [])].sort((a, b) => a.difficulty - b.difficulty);

  el.className = "tier-section__cards";
  el.innerHTML = samples.map(sampleCardHTML).join("");
}

function initSamplesPage() {
  renderSampleList();
  renderProgressUI();
}

window.addEventListener("DOMContentLoaded", initSamplesPage);
