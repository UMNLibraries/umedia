import SidebarPagesLoad from '../../../../app/javascript/lib/viewer/sidebar_pages_load.js';

const fetchPromise = new Promise((resolve, reject) => {
  resolve({text: () => '<span id="child-search-record-count">25</span> blah <b>blah</b>'});
});

const fetcher = {
  fetch: () => fetchPromise
}

const sliderHorizontalElem = jest.fn();
const sliderVerticalElem = jest.fn();
const sidebarNumElem = jest.fn();

const elements = {
  sidebarPagesElem: {
    html: jest.fn()
  },
  sliderHorizontalElem: sliderHorizontalElem,
  sliderVerticalElem: sliderVerticalElem,
  sidebarNumElem: sidebarNumElem,
}

const sliderKlass = jest.fn((config) => {
  return { init: () => {} }
})


it('sideloads pages', async () => {

  const sidebar = {
    id: 'coll1:123',
    child_id: 'col4:5234',
    query: '',
    page: 1
  }
  await SidebarPagesLoad({
    fetcher: fetcher,
    sidebar: sidebar,
    elements: elements,
    sliderKlass: sliderKlass,
  }).sideLoad();


  // Response from chile_searches controller - sort of ugly, but I'm pulling
  // the result count from HTML since we only need that one piece of data from
  // the results. If we need more data down the road, we can turn this into
  // a JSON response.
  expect(elements.sidebarPagesElem.html.mock.calls[0][0]).toEqual('<span id=\"child-search-record-count\">25</span> blah <b>blah</b>');

  const verticalSlideConfig = sliderKlass.mock.calls[0][0];
  expect(verticalSlideConfig.currentPage).toEqual(1);
  expect(verticalSlideConfig.orientation).toEqual('vertical');
  expect(verticalSlideConfig.recordCount).toEqual(25);
  expect(verticalSlideConfig.step).toEqual(3);
  expect(verticalSlideConfig.showSlider).toEqual(true);
  expect(verticalSlideConfig.sliderElem).toBe(sliderVerticalElem);
  expect(verticalSlideConfig.sliderNumElem).toBe(sidebarNumElem);

  const horizontalSlideConfig = sliderKlass.mock.calls[1][0];
  expect(horizontalSlideConfig.currentPage).toEqual(1);
  expect(horizontalSlideConfig.orientation).toEqual('horizontal');
  expect(horizontalSlideConfig.recordCount).toEqual(25);
  expect(horizontalSlideConfig.step).toEqual(3);
  expect(horizontalSlideConfig.showSlider).toEqual(true);
  expect(horizontalSlideConfig.sliderElem).toBe(sliderHorizontalElem);
  expect(horizontalSlideConfig.sliderNumElem).toBe(sidebarNumElem);
});

describe('when a query is present',  () => {
  it('configures a different perPage', async () => {
    const sidebar = {
      id: 'coll1:123',
      child_id: 'col4:5234',
      query: 'foo',
      page: 1
    }
    await SidebarPagesLoad({
      fetcher: fetcher,
      sidebar: sidebar,
      elements: elements,
      sliderKlass: sliderKlass,
    }).sideLoad();

    const verticalSlideConfig = sliderKlass.mock.calls[0][0];
    const horizontalSlideConfig = sliderKlass.mock.calls[1][0];
    expect(verticalSlideConfig.step).toEqual(3);
    expect(horizontalSlideConfig.step).toEqual(3);
  });
});


describe('when the record count is not greater than the perPage configuration ',  () => {
  it('tells sliders not to display', async () => {
    const sidebar = {
      id: 'coll1:123',
      child_id: 'col4:5234',
      query: '',
      page: 1
    }
    const fetcher = {
      fetch: () => fetchPromise
    }

    const fetchPromise = new Promise((resolve, reject) => {
      resolve({text: () => '<span id="child-search-record-count">2</span> blah <b>blah</b>'});
    });

    const sliderKlass = jest.fn((config) => {
      return { init: () => {} }
    })

    await SidebarPagesLoad({
      fetcher: fetcher,
      sidebar: sidebar,
      elements: elements,
      sliderKlass: sliderKlass,
    }).sideLoad();

    const verticalSlideConfig = sliderKlass.mock.calls[0][0];
    const horizontalSlideConfig = sliderKlass.mock.calls[1][0];
    expect(verticalSlideConfig.showSlider).toEqual(false);
    expect(horizontalSlideConfig.showSlider).toEqual(false);
  });
});