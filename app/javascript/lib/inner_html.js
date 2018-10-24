export default (path, innerAreaElem, fetcher = window) => {
  fetcher.fetch(path)
    .then(response => response.text())
    .then(html => {
      innerAreaElem.innerHTML = html;
    });
}