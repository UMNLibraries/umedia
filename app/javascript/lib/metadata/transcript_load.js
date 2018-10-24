


export default (id, metadataAreaElem, fetcher = window) => {
  downloadLinkElem.setAttribute('data-is_open', 'true');
  fetcher.fetch(`/downloads/${id}`)
  .then(response => response.text())
    .then(html => {
      downloadAreaElem.innerHTML = html;
    });
}