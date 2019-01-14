import { Controller } from 'stimulus';
import InnerHtml from '../lib/inner_html.js';

export default class extends Controller {
  connect() {

    this.load(this.data.get('collections_page'),
              this.data.get('collections_sort'),
              this.data.get('collection_rows'))
  }
  select_page(e) {
    e.preventDefault();
    console.log(e)
  }

  load(page, sort, rows) {
    InnerHtml(`/collections/${page}/${sort}/nolayout/${rows}`, document.getElementById("collections-home"));
  }
}