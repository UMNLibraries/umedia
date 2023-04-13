import { Controller } from 'stimulus';
import InnerHtml from '../lib/inner_html.js';
import Seadragon from '../lib/viewer/openseadragon.js';

export default class extends Controller {
  connect() {
    this.id = this.data.get('id');
    this.osdConfig = this.data.get('osd-config')
    this.attachmentFormat = this.data.get('attachment-format');
    this.viewerConfig = JSON.parse(this.data.get('viewer-config'));
    this.locale = document.getElementById('main').getAttribute('data-locale');
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
    let config = this.viewerConfig;
    InnerHtml(`/${section}/${this.id}?language=${this.locale}`, document.getElementById("metadata-area"))
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
