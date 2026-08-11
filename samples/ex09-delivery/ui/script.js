function post(name, body) {
  return fetch(`https://${GetParentResourceName()}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body || {}),
  });
}

const requests = {};

function renderRequests() {
  const list = document.getElementById('request-list');
  list.innerHTML = '';

  Object.values(requests).forEach((req) => {
    const li = document.createElement('li');
    li.textContent = `${req.requesterName}からの依頼`;

    const acceptBtn = document.createElement('button');
    acceptBtn.textContent = '受注';
    acceptBtn.addEventListener('click', () => {
      post('acceptDelivery', { requestId: req.requestId });
    });

    li.appendChild(acceptBtn);
    list.appendChild(li);
  });
}

// lb-phoneアプリはSendCustomAppMessageで送られたデータをwindow.messageで受け取る(Tier4-05参照)
window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.action === 'newRequest') {
    requests[data.requestId] = data;
    renderRequests();
  }

  if (data.action === 'statusUpdate') {
    document.getElementById('status').textContent = data.message;

    // 依頼が受注されたら一覧から消す(他ドライバーへの二重受注防止の見た目上の反映)
    if (data.status === 'accepted' || data.status === 'completed') {
      delete requests[data.requestId];
      renderRequests();
    }
  }
});

document.getElementById('request-btn').addEventListener('click', () => {
  post('requestDelivery');
});
