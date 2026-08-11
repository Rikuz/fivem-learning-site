window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.action === 'updateSpeed') {
    const speedo = document.getElementById('speedometer');
    speedo.style.display = data.visible ? 'block' : 'none';
    if (data.visible) {
      speedo.textContent = `${data.speed} km/h`;
    }
  }

  if (data.action === 'updateStatusBars') {
    document.getElementById('health-bar').style.width = `${Math.max(0, data.health)}%`;
    document.getElementById('hunger-bar').style.width = `${data.hunger}%`;
    document.getElementById('thirst-bar').style.width = `${data.thirst}%`;
  }
});
