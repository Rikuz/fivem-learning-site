// assets/js/render-practice.js — 実践演習一覧ページ(practice.html)の描画

function exerciseCardHTML(exercise) {
  const difficultyInfo = window.TIER_INFO[exercise.difficulty];
  const depsText = exercise.dependencies.length ? exercise.dependencies.join(" / ") : "FiveM標準のみ(追加リソース不要)";

  return `
    <a class="lesson-card" data-lesson-card="${exercise.id}" href="${exercise.path}">
      <div class="lesson-card__badges">
        <span class="badge tier-badge" data-tier="${exercise.difficulty}">${difficultyInfo.emoji} 難易度: ${difficultyInfo.label}</span>
      </div>
      <p class="lesson-card__title">${exercise.title} <span data-complete-check></span></p>
      <p class="lesson-card__summary">${exercise.summary}</p>
      <div class="lesson-card__meta">
        <span>依存: ${depsText}</span>
      </div>
    </a>
  `;
}

function renderExerciseList() {
  const el = document.getElementById("practice-list");
  if (!el) return;

  const exercises = [...(window.EXERCISES || [])].sort((a, b) => a.difficulty - b.difficulty);

  el.className = "tier-section__cards";
  el.innerHTML = exercises.map(exerciseCardHTML).join("");
}

function initPracticePage() {
  renderExerciseList();
  renderProgressUI();
}

window.addEventListener("DOMContentLoaded", initPracticePage);
