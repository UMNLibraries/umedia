

export default function(id, transcriptsElem, fetcher) {
  return fetcher.fetch(`/transcripts/${id}`)
    .then(response => response.text())
    .then(html => {
      transcriptsElem.innerHTML = html;
    });
}
