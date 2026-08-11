function post(name, body) {
  return fetch(`https://${GetParentResourceName()}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body || {}),
  });
}

function renderItems(items) {
  const list = document.getElementById('item-list');
  list.innerHTML = '';

  items.forEach((item) => {
    const li = document.createElement('li');
    li.innerHTML = `<span>${item.label}($${item.price})</span>`;

    const buyButton = document.createElement('button');
    buyButton.textContent = '購入';
    buyButton.addEventListener('click', () => {
      post('purchase', { itemName: item.name });
    });

    li.appendChild(buyButton);
    list.appendChild(li);
  });
}

window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.action === 'openShop') {
    document.getElementById('shop').classList.remove('hidden');
    document.getElementById('money').textContent = `所持金: $${data.money}`;
    document.getElementById('feedback').textContent = '';
    renderItems(data.items);
  }

  if (data.action === 'purchaseResult') {
    document.getElementById('money').textContent = `所持金: $${data.money}`;
    const feedback = document.getElementById('feedback');
    feedback.textContent = data.message;
    feedback.style.color = data.success ? '#7CFC98' : '#FF6B6B';
  }
});

document.getElementById('close-btn').addEventListener('click', () => {
  document.getElementById('shop').classList.add('hidden');
  post('closeShop');
});
