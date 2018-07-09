import { Controller } from 'stimulus';
import Viewer from '../lib/viewer/viewer.js'
import ViewerUrl from '../lib/viewer/viewer_url.js';

export default class extends Controller {
  static targets = [ "searchText" ]

  constructor(scope, jquery = $) {
    super(scope);
    this.jquery = $;
    this.viewer = Viewer({doc: document, wind: window, $: $});
  }

  connect() {
    this.load(this.data.get("id"),this.data.get("child_id"));
  }

  clearSearch(e) {
    this.searchTextTarget.value = ''
    ViewerUrl({ q: ''}).update();
    this.load();
  }

  search(e) {
    e.preventDefault();
    if (this.searchTextTarget.value.trim() == '') return;
    $('.clear-search').attr('class', 'clear-search');
    ViewerUrl({ q: this.searchTextTarget.value}).update();
    this.viewer.pagesSideLoad(this.data.get("id"),
                              this.searchTextTarget.value);
  }

  select(event) {
    event.preventDefault();
    const target = event.currentTarget;
    const id = target.dataset.id;
    const child_id = target.dataset.child_id;

    this.resetSidebarActivePages();
    this.setActivePage(target.id);
    ViewerUrl({ q: target.dataset.query, id: id, child_id: child_id}).update();
    this.load(id, child_id);

    // Include child page navigation in back button nav
    const load = this.load;
    window.addEventListener("popstate", function(event) {
      if (event.state.child_id) {
        load(event.state.id, event.state.child_id);
      }
    }, false);
  }

  setActivePage(id) {
    $(`#${id}`).attr('class', 'sidebar-page active list-group-item')
  }

  resetSidebarActivePages() {
    $('.sidebar-page').each(function( index ) {
      $( this ).attr('class', 'sidebar-page list-group-item');
    });
  }

  load(id, child_id) {
    this.viewer.viewerSideLoad(id, child_id);
  }
}