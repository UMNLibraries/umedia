import { Controller } from "stimulus"

export default class extends Controller {
  facetModal(e) {
    e.preventDefault();
    const facetQuery = e.target.getAttribute('data-query');
    return window.fetch(`/facets/?${facetQuery}&modal=on`)
    .then(response => response.text())
    .then(html => {
      document.getElementById("facetModalBody").innerHTML = html;
      $('#facetModal').modal('show');
    });
  }
}