import stampit from 'stampit';
import ToggleSlider from './toggle_slider.js';
import noUiSlider from 'nouislider';

export default stampit({
  props: {
    recordCount: null,
    step: null,
    start: null,
    orientation: null,
    sliderElem: null,
    sliderNumElem: null,
    showSlider: null,
    height: null,
    margin: '0 auto 30px',
    callback: null,
    toggleSliderKlass: null,
    sliderKlass: null,
  },
  init({ recordCount,
         step = 3,
         start = 1,
         orientation = 'vertical',
         sliderElem,
         sliderNumElem,
         showSlider = true,
         height = '660px',
         callback,
         toggleSliderKlass = ToggleSlider,
         sliderKlass = noUiSlider }) {

    start = Number(start);
    step = Number(step);

    // Show/hide slider (useful if we have enough results)
    toggleSliderKlass(sliderElem, showSlider);

    if (sliderElem.hasChildNodes()) {
      sliderElem.noUiSlider.destroy();
    }

    sliderKlass.create(sliderElem, {
      range: {
          min: 1,
          max: Math.ceil(recordCount / step)
      },
      step: 1, // noUiSlider's step - We want to increment pages by one
      orientation: orientation,
      start: [start],
    });

    sliderElem.noUiSlider.on('update', function (pages, handle) {
      const page = Number(pages[handle]);
      if (page !== start) callback(page)
      const endRange = page * step;
      const end = (endRange <= recordCount) ? endRange : recordCount;
      const startRange = endRange - step + 1;
      sliderNumElem.val(`${startRange} - ${end} of ${recordCount}`);
    });

    sliderElem.style.height = height;
    sliderElem.style.margin = this.margin;

    function setSliderHandle(value) {
      sliderElem.noUiSlider.set([value, null]);
    }

    document.onkeydown = arrowNav;

    function arrowNav(e) {
        e = e || window.event;
        // Arrow Left
        if (e.keyCode == '37') {
          setSliderHandle(start - 1)
        }
        // Arrow Right
        else if (e.keyCode == '39') {
          setSliderHandle(start + 1)
        }
    }

  }
});