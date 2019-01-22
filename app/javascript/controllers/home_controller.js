import { Controller } from 'stimulus';
import InnerHtml from '../lib/inner_html.js';

export default class extends Controller {
  connect() {

    this.load(this.data.get('collections_page'),
              this.data.get('collections_sort'));
  }

  load(page, sort) {
    InnerHtml(`/collections/${page}/${sort}/nolayout`, document.getElementById("collections-home"))
      .then(response => {
        $(response).find('[data-toggle="tooltip"]').tooltip();
      })
  }
}