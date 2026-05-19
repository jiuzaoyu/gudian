(function () {
  const input = document.getElementById('search-input');
  const resultsEl = document.getElementById('search-results');
  if (!input || !resultsEl) return;

  let index = [];
  const indexUrl = new URL('index.json', window.location.href).href;

  fetch(indexUrl)
    .then((r) => (r.ok ? r.json() : []))
    .catch(() => [])
    .then((data) => {
      index = Array.isArray(data) ? data : [];
    });

  function normalize(s) {
    return (s || '').toLowerCase().replace(/\s+/g, '');
  }

  function search(q) {
    const nq = normalize(q);
    if (!nq || nq.length < 1) return [];
    return index
      .filter((item) => {
        const hay = normalize(
          [item.title, item.summary, item.section, ...(item.tags || []), item.content].join(' ')
        );
        return hay.includes(nq);
      })
      .slice(0, 12);
  }

  function render(items) {
    if (!items.length) {
      resultsEl.innerHTML = '<p class="no-results">未找到相关概念，试试其他关键词</p>';
      resultsEl.hidden = false;
      return;
    }
    resultsEl.innerHTML = items
      .map(
        (item) =>
          `<a href="${item.url}"><span class="result-title">${item.title}</span><span class="result-meta">${item.section} · ${item.summary || ''}</span></a>`
      )
      .join('');
    resultsEl.hidden = false;
  }

  let timer;
  input.addEventListener('input', () => {
    clearTimeout(timer);
    timer = setTimeout(() => {
      const q = input.value.trim();
      if (!q) {
        resultsEl.hidden = true;
        return;
      }
      render(search(q));
    }, 150);
  });

  input.addEventListener('focus', () => {
    if (input.value.trim()) render(search(input.value.trim()));
  });

  document.addEventListener('click', (e) => {
    if (!input.contains(e.target) && !resultsEl.contains(e.target)) {
      resultsEl.hidden = true;
    }
  });
})();
