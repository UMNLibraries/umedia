

export default (sliderElem, showSlider) => {
  if (showSlider) {
    sliderElem.setAttribute('style', '');
  } else {
    sliderElem.setAttribute('style', 'display:none;');
  }
}