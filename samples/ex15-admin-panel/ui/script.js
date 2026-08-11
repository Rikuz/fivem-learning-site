let currentLevel = 0;

function post(name, body) {
  return fetch(`https://${GetParentResourceName()}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body || {}),
  });
}

function renderPlayers(players) {
  const list = document.getElementById('player-list');
  list.innerHTML = '';

  players.forEach((player) => {
    const li = document.createElement('li');

    const nameSpan = document.createElement('span');
    nameSpan.textContent = `[${player.id}] ${player.name}`;
    li.appendChild(nameSpan);

    const spectateBtn = document.createElement('button');
    spectateBtn.textContent = '観戦';
    spectateBtn.addEventListener('click', () => post('spectate', { targetId: player.id }));
    li.appendChild(spectateBtn);

    // admin以上の権限を持つプレイヤーのみBAN・キックボタンを表示する
    if (currentLevel >= 2) {
      const kickBtn = document.createElement('button');
      kickBtn.textContent = 'キック';
      kickBtn.addEventListener('click', () => {
        const reason = prompt('キック理由を入力してください') || '';
        post('kick', { targetId: player.id, reason });
      });
      li.appendChild(kickBtn);

      const banBtn = document.createElement('button');
      banBtn.textContent = 'BAN';
      banBtn.addEventListener('click', () => {
        const reason = prompt('BAN理由を入力してください') || '';
        post('ban', { targetId: player.id, reason });
      });
      li.appendChild(banBtn);
    }

    list.appendChild(li);
  });
}

function renderReports(reports) {
  const list = document.getElementById('report-list');
  list.innerHTML = '';

  reports.forEach((report) => {
    const li = document.createElement('li');
    li.textContent = `${report.reporter}: ${report.message}`;
    list.appendChild(li);
  });
}

window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.action !== 'open') return;

  currentLevel = data.level;
  document.getElementById('panel').classList.remove('hidden');
  renderPlayers(data.players);
  renderReports(data.reports);
});

document.querySelectorAll('.tab-btn').forEach((btn) => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.tab-btn').forEach((b) => b.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach((c) => c.classList.add('hidden'));
    btn.classList.add('active');
    document.getElementById(`tab-${btn.dataset.tab}`).classList.remove('hidden');
  });
});

document.getElementById('close-btn').addEventListener('click', () => {
  document.getElementById('panel').classList.add('hidden');
  post('close');
});
