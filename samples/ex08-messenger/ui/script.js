let messages = [];

function post(name, body) {
  return fetch(`https://${GetParentResourceName()}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body || {}),
  });
}

function showScreen(id) {
  document.querySelectorAll('.screen').forEach((el) => el.classList.add('hidden'));
  document.getElementById(id).classList.remove('hidden');
}

function renderList() {
  const list = document.getElementById('message-list');
  list.innerHTML = '';

  messages.forEach((msg) => {
    const li = document.createElement('li');
    li.textContent = `${msg.sender_name}: ${msg.body.slice(0, 20)}`;
    li.addEventListener('click', () => {
      document.getElementById('detail-sender').textContent = `送信者: ${msg.sender_name}`;
      document.getElementById('detail-body').textContent = msg.body;
      showScreen('screen-detail');
    });
    list.appendChild(li);
  });
}

// lb-phoneアプリはSendCustomAppMessageで送られたデータをwindow.messageで受け取る(Tier4-05参照)
window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.action === 'showList') {
    messages = data.messages;
    showScreen('screen-list');
    renderList();
  }

  if (data.action === 'sendResult') {
    document.getElementById('feedback').textContent = data.message;
  }
});

document.getElementById('back-btn').addEventListener('click', () => {
  showScreen('screen-list');
});

document.getElementById('send-btn').addEventListener('click', () => {
  const receiverId = document.getElementById('receiver-input').value;
  const body = document.getElementById('body-input').value;
  post('sendMessage', { receiverId, body });
});
