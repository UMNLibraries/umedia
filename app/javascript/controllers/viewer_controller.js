import { Controller } from 'stimulus';
import Viewer from '../lib/viewer/viewer.js'
import ViewerUrl from '../lib/viewer/viewer_url.js';
import Resize from '../lib/viewer/resize.js';
import SidebarPagesLoad from '../lib/viewer/sidebar_pages_load.js';
import Sidebar from '../lib/viewer/sidebar.js';


// TODO: finish the job of extracting code out of this controller
export default class extends Controller {
  static targets = [ "searchText" ]

  constructor(scope, jquery = $) {
    super(scope);
    this.viewer = Viewer({doc: document, wind: window, $: $});
  }

  load(id, child_id, page, query) {
    const sidebar = Sidebar({
      id: id,
      child_id: child_id,
      page: page,
      query: query
    })

    const sidebarPages = SidebarPagesLoad({
      fetcher: window,
      sidebar: sidebar,
      elements: {
        sidebarPagesElem: $('#sidebar-pages'),
        sidebarNumElem: $('#sidebar-page-num'),
        sliderHorizontalElem: $('#sidebar-slider-horizontal'),
        sliderVerticalElem: $('#sidebar-slider-vertical')
      }
    })
    return [ sidebar, sidebarPages ]
  }

  connect() {
    [ this.sidebar, this.sidebarPages ] = this.load(this.data.get("id"),
                                                    this.data.get("child_id"),
                                                    this.data.get("sidebar_page"),
                                                    this.data.get("query"))

    this.viewer.viewerSideLoad(this.data.get("id"),
                               this.data.get("child_id"));
    this.sidebarPages.sideLoad();
  }

  toggleDownload(e) {
    e.preventDefault();
    const id = e.currentTarget.dataset.child_id;
    window.fetch(`/downloads/${id}`)
    .then(response => response.text())
    .then(html => {
      document.getElementById(`downloads-toggle-${id}`).innerHTML = html;
    });
  }

  search(e) {
    e.preventDefault();
    if (this.searchTextTarget.value.trim() == '') return;
    $('.clear-search').attr('class', 'clear-search');


    this.sidebar = Sidebar({ ...this.sidebar,
                             ...{page: 1 },
                             ...{ query: this.searchTextTarget.value }
                           })
    const sidebar = this.sidebar;
    SidebarPagesLoad({...this.sidebarPages, sidebar}).sideLoad();

    ViewerUrl({ q: sidebar.query }).update();
    Resize($('#item-content'), $('#viewer-sidebar'), sidebar.query !== '')
  }

  select(event) {
    event.preventDefault();

    const sidebar = Sidebar({ ...this.sidebar,
                              ...{ page: event.currentTarget.dataset.sidebar_page },
                              ...{ child_id: event.currentTarget.dataset.child_id }
                            });

    SidebarPagesLoad({...this.sidebarPages, sidebar}).sideLoad();

    this.viewer.viewerSideLoad(sidebar.id, sidebar.child_id);

    ViewerUrl({ q: sidebar.query,
                id: sidebar.id,
                child_id: sidebar.child_id,
                sidebar_page: sidebar.page }).update();

    // Include child page navigation in back button nav
    const load = this.load;
    window.addEventListener("popstate", function(event) {
      if (event.state.child_id) {
        load(event.state.id,
             event.state.child_id,
             event.state.sidebar_page,
             event.state.query);
      }
    }, false);
  }

  resetSidebarActivePages() {
    $('.sidebar-page').each(function( index ) {
      $( this ).attr('class', 'sidebar-page list-group-item');
    });
  }
}