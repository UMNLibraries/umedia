import Slider from '../../../../app/javascript/lib/viewer/slider.js';

it('slides', () => {
  const sliderNumElem = {
    val: jest.fn()
  }
  const sliderElem = {
    slider: jest.fn()
  }
  const callback = jest.fn();

  const slider = Slider({ recordCount: 54,
                          sliderElem: sliderElem,
                          sliderNumElem: sliderNumElem,
                          callback: callback })

  slider.init();
  const sliderConfig = sliderElem.slider.mock.calls[0][0];
  expect(sliderConfig.max).toEqual(-1);
  expect(sliderConfig.min).toEqual(-18);
  expect(sliderConfig.orientation).toEqual('vertical');
  expect(sliderConfig.value).toEqual(-1);
  expect(sliderNumElem.val.mock.calls[0][0]).toEqual('1 - 3 of 54');

  slider.slide(3, slider);
  expect(sliderNumElem.val.mock.calls[1][0]).toEqual('7 - 9 of 54');
  expect(callback.mock.calls[0][0]).toEqual(3);

});