import stampit from 'stampit';
import Slider from './slider.js'
import ViewerUrl from './viewer_url.js';
import noUiSlider from 'nouislider';

// Load content from a given endpoint and inject it into the page
export default stampit({
  props: {
    fetcher: null,
    sidebar: null,
    elements: null,
    urlKlass: null,
    sliderKlass: null
  },
  init({ fetcher,
         sidebar,
         elements,
         urlKlass = ViewerUrl,
         sliderKlass = Slider }) {
    this.fetcher = fetcher;
    this.sidebar = sidebar;
    this.urlKlass = urlKlass;
    this.elements = elements;
    this.sliderKlass = sliderKlass;

    this.searchUrl = () => {
      const paths = [
        sidebar.id,
        sidebar.child_id,
        this.perPage(),
        sidebar.query
      ].join('/')
      return `/child_search/${paths}?page=${sidebar.page}`
    }
    this.perPage = () => {
      return (sidebar.query !== '') ? 2 : 3;
    }
  },
  methods: {
    sideLoad() {
      const elements = this.elements;
      const sidebar = this.sidebar;
      const perPage = this.perPage();
      const sliderKlass = this.sliderKlass;
      const sliderCallback = (page) => {
        sidebar.page = page;
        this.sideLoad();
        this.urlKlass({ id: sidebar.id, child_id: sidebar.child_id, sidebar_page: page}).update();
      }

      return this.fetcher.fetch(this.searchUrl())
        .then(response => response.text())
        .then(html => {


          elements.sidebarPagesElem.html(html);
          let parser = new DOMParser();
          let doc = parser.parseFromString(html, "text/html");
          // Response from chile_searches controller - sort of ugly, but I'm pulling
          // the result count from HTML since we only need that one piece of data from
          // the results. If we need more data down the road, we can turn this into
          // a JSON response. For now, it's nice to keep the templates etc on the server
          // and innerHTML, which is quite fast as well.
          let recordCount = Number(doc.getElementById("child-search-record-count").innerHTML);
          return recordCount;
        })
        .then((recordCount) => {

          // Add the slider element - allows users to scroll through pages

          const height = (count) => {
            if (count >= 400) {
              return '800px';
            } else if (recordCount >= 50) {
              return '668px';
            } else if (recordCount >= 30 ) {
              return '400px';
            } else if (recordCount >= 15 ) {
              return '300px';
            } else if (recordCount >= 4 ) {
              return '30px';
            } else {
              return '668px';
            }
          }

          // Desktop / Laptop Version (shown/hidden via css media queries)
          sliderKlass({ recordCount: recordCount,
                        step: perPage,
                        start: sidebar.page,
                        reverse: false,
                        orientation: 'vertical',
                        sliderElem: elements.sliderVerticalElem,
                        sliderNumElem: elements.sidebarNumElem,
                        inputElem: elements.inputElem,
                        showSlider: recordCount > perPage,
                        height: height(recordCount),
                        callback: sliderCallback});

          sliderKlass({ recordCount: recordCount,
                        step: perPage,
                        start: sidebar.page,
                        orientation: 'horizontal',
                        sliderElem: elements.sliderHorizontalElem,
                        sliderNumElem: elements.sidebarNumElem,
                        inputElem: elements.inputElem,
                        showSlider: recordCount > perPage,
                        height: '19px',
                        callback: sliderCallback});

       });
    }
  }
});