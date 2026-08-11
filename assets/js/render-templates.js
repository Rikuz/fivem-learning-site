// assets/js/render-templates.js — テンプレート集一覧ページ(templates.html)の描画

function templateCardHTML(template) {
  const depsText = template.dependencies.length ? template.dependencies.join(" / ") : "FiveM標準のみ(追加リソース不要)";

  return `
    <a class="lesson-card" href="${template.path}">
      <p class="lesson-card__title">${template.title}</p>
      <p class="lesson-card__summary">${template.summary}</p>
      <div class="lesson-card__meta">
        <span>依存: ${depsText}</span>
      </div>
    </a>
  `;
}

function renderTemplateList() {
  const el = document.getElementById("template-list");
  if (!el) return;

  const templates = window.TEMPLATES || [];
  el.className = "tier-section__cards";
  el.innerHTML = templates.map(templateCardHTML).join("");
}

function initTemplatesPage() {
  renderTemplateList();
}

window.addEventListener("DOMContentLoaded", initTemplatesPage);
