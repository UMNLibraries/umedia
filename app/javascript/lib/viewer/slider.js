import stampit from 'stampit';
import ToggleSlider from './toggle_slider.js';

// TODO: factor shared variables to init and differing vars to methods init()
// since we not init both a vertical and horizontal slider
export default stampit({
  props: {
    recordCount: null,
    step: null,
    currentPage: null,
    orientation: null,
    reverse: null,
    sliderElem: null,
    sliderNumElem: null,
    showSlider: null,
    callback: null,
    toggleSliderKlass: null,
  },
  init({ recordCount,
        step = 3,
        currentPage = 1,
        orientation = 'vertical',
        reverse = true,
        sliderElem,
        sliderNumElem,
        showSlider = true,
        callback,
        toggleSliderKlass = ToggleSlider }) {

    this.reverse = reverse;
    this.lastPage = Math.ceil(Number(recordCount) / step);
    this.start = (reverse) ? -currentPage : currentPage;
    this.orientation = orientation;
    this.callback = callback;
    this.sliderElem = sliderElem;

    // Show/hide slider (useful if we have enough results)
    toggleSliderKlass(sliderElem, showSlider)

    this.setRange =  function(pagerPage) {
      const endRange = pagerPage * step;
      const end = (endRange <= recordCount) ? endRange : recordCount;
      const startRange = endRange - step + 1;
      sliderNumElem.val(`${startRange} - ${end} of ${recordCount}`);
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
      const orientation = this.orientation;
      const direction = (this.reverse) ? -1 : 1;
      const min = (this.reverse) ? lastPage * direction : direction;
      const max = (this.reverse) ? direction : lastPage;

      // JQuery.ui vertical slider orients max value at the top of the slider and
      // minimum value at the bottom. To reverse this, we use negative values and
      // return the absolute - positive - value of the page
      this.sliderElem.slider({
        orientation: orientation,
        min: min,
        max: max,
        value: start,
        slide: function( event, ui ) {
          slide(ui.value * direction, self)
        }
      });
    }
  }
});