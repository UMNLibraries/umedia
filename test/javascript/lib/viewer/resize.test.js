import Resize from '../../../../app/javascript/lib/viewer/resize.js';

describe ('when a query is present', () => {
  it('adjusts expands the sidebar', () => {
    const contentElem = {
      attr: jest.fn()
    }
    const sidebarElem = {
      attr: jest.fn()
    }

    Resize(contentElem, sidebarElem, 'foo')

    expect(sidebarElem.attr.mock.calls[0]).toEqual(["class", "col-md-5"]);
    expect(contentElem.attr.mock.calls[0]).toEqual(["class", "col-md-7"]);
  });
});

describe ('when no query is present', () => {
  it('adjusts expands the sidebar', () => {
    const contentElem = {
      attr: jest.fn()
    }
    const sidebarElem = {
      attr: jest.fn()
    }

    Resize(contentElem, sidebarElem)

    expect(sidebarElem.attr.mock.calls[0]).toEqual(["class", "col-md-4"]);
    expect(contentElem.attr.mock.calls[0]).toEqual(["class", "col-md-8"]);
  });
});