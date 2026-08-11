function post(name, body) {
  return fetch(`https://${GetParentResourceName()}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body || {}),
  });
}

window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.action === 'open') {
    document.getElementById('app').classList.remove('hidden');
  }
});

document.getElementById('submit-btn').addEventListener('click', () => {
  const text = document.getElementById('text-input').value;
  post('submitData', { text });
});

document.getElementById('close-btn').addEventListener('click', () => {
  document.getElementById('app').classList.add('hidden');
  post('close');
});
