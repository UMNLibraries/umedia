import stampit from 'stampit';

export default stampit({
  props: {
    recordCount: null,
    step: null,
    currentPage: null,
    sliderElem: null,
    sliderNumElem: null,
    callback: null
  },
  init({ recordCount,
        step = 3,
        currentPage = 1,
        sliderElem,
        sliderNumElem,
        callback }) {

    this.lastPage = Math.ceil(Number(recordCount) / step);
    this.start = -currentPage;
    this.callback = callback;
    this.sliderElem = sliderElem;

    this.setRange =  function(pagerPage) {
      const endRange = pagerPage * step;
      const startRange = endRange - step + 1;
      sliderNumElem.val(`${startRange} - ${endRange}`);
    }

    // Initialize the range display
    this.setRange(currentPage);
  },
  methods: {
    slide(pagerPage, self) {
      self.setRange(pagerPage);
      self.callback(pagerPage);
    },
    init() {
      const { slide, lastPage, start } = this
      const self = this;
      // JQuery.ui vertical slider orients max value at the top of the slider and
      // minimum value at the bottom. To reverse this, we use negative values and
      // return the absolute - positive - value of the page
      this.sliderElem.slider({
        orientation: "vertical",
        min: -lastPage,
        max: -1,
        value: start,
        slide: function( event, ui ) {
          slide(ui.value * -1, self)
        }
      });
    }
  }
});