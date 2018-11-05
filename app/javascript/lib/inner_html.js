export default (path, innerAreaElem, fetcher = window) => {
  return fetcher.fetch(path)
    .then(response => response.text())
    .then(html => {
      innerAreaElem.innerHTML = html;
      return innerAreaElem;
    });
}