import { Controller } from 'stimulus';
import InnerHtml from '../lib/inner_html.js';

export default class extends Controller {
  connect() {
    this.id = this.data.get("id");
    this.load('details');
  }
  showSection(e) {
    e.preventDefault();
    this.load(e.currentTarget.dataset.section);
  }

  clearActive() {
    $(".metadata-pill").each(function(index) {
      $(this).attr('class', 'metadata-pill');
    });
  }

  load(section) {
    this.clearActive()
    $(`#metadata-${section}`).attr('class', 'metadata-pill active');
    InnerHtml(`/${section}/${this.id}`, document.getElementById("metadata-area"))
  }
}