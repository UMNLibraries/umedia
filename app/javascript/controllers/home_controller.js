import { Controller } from 'stimulus';
import InnerHtml from '../lib/inner_html.js';

export default class extends Controller {
  connect() {
    this.load(this.data.get('collection_page'),
              this.data.get('collection_sort'));
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

  load(page, sort) {
    InnerHtml(`/collections/${page}/${sort}`, document.getElementById("collections-home"))
      .then(elem => {
        config = elem.getElementsByClassName("osd-config")[0]
        let configElem = elem.getElementsByClassName("osd-config")[0]
        if (config) {
          let config = JSON.parse(configElem.getAttribute("data-config"));
          config.element = elem.getElementsByClassName("openseadragon")[0];
          Seadragon({osdConfig: config})
        }
     });
  }
}