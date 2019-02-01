import { Controller } from 'stimulus';
import InnerHtml from '../lib/inner_html.js';
import HomeUrl from '../lib/home/url.js';

export default class extends Controller {
  connect() {
    this.filter_q = this.data.get('filter_q');
    this.page = this.data.get('collections_page');
    this.sort = this.data.get('collections_sort');
    this.load();
  }

  pager(e) {
    e.preventDefault();
    this.page = $(e.target).text();
    this.navigate();
  }

  next_page(e) {
    e.preventDefault();
    this.page = $('#next-page-val').text();
    this.navigate();
  }

  prev_page(e) {
    e.preventDefault();
    this.page = $('#prev-page-val').text();
    this.navigate();
  }

  search(e) {
    e.preventDefault();
    this.filter_q = $('#filter_q').val();
    this.page = 1;
    this.navigate();
  }

  clear_search(e) {
    e.preventDefault();
    this.resetData();
    this.updateUrl();
    this.load(1, 'set_spec desc', '');
  }

  navigate() {
    this.updateUrl();
    this.load();
  }

  updateUrl() {
    HomeUrl({ page: this.page, filter_q: this.filter_q, sort: this.sort }).update();
  }

  resetData() {
    this.filter_q = '';
    this.page = 1;
    this.sort = 'set_spec desc'
  }

  load() {
    InnerHtml(`/collections/${this.page}/${this.sort}/nolayout?filter_q=${this.filter_q}`, document.getElementById("collections-home"))
      .then(response => {
        $(response).find('[data-toggle="tooltip"]').tooltip();
      });
  }
}