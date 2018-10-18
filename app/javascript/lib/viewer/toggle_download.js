

// TODO: write test
export default (downloadAreaElem, downloadLinkElem, fetcher) => {
  const id = downloadLinkElem.dataset.child_id;
  const isOpen = downloadLinkElem.dataset.is_open == 'true';
  if (isOpen) {
    downloadAreaElem.innerHTML = '';
    downloadLinkElem.setAttribute('data-is_open', 'false');
  } else {
    downloadLinkElem.setAttribute('data-is_open', 'true');
    fetcher.fetch(`/downloads/${id}`)
    .then(response => response.text())
      .then(html => {
        downloadAreaElem.innerHTML = html;
      });
  }
}