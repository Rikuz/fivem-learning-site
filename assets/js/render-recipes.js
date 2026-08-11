// assets/js/render-recipes.js — レシピ集一覧ページ(recipes.html)の描画

function recipeCardHTML(recipe) {
  const combinesText = recipe.combines
    .map((id) => {
      const lesson = (window.LESSONS || []).find((l) => l.id === id);
      return lesson ? lesson.title : id;
    })
    .join(" + ");

  return `
    <a class="lesson-card" href="${recipe.path}">
      <p class="lesson-card__title">${recipe.title}</p>
      <p class="lesson-card__summary">${recipe.summary}</p>
      <div class="lesson-card__meta">
        <span>組み合わせ: ${combinesText}</span>
      </div>
    </a>
  `;
}

function renderRecipeList() {
  const el = document.getElementById("recipe-list");
  if (!el) return;

  const recipes = window.RECIPES || [];
  el.className = "tier-section__cards";
  el.innerHTML = recipes.map(recipeCardHTML).join("");
}

function initRecipesPage() {
  renderRecipeList();
}

window.addEventListener("DOMContentLoaded", initRecipesPage);
