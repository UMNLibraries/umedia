import Viewer from '../../../../app/javascript/lib/viewer/viewer.js';
import stampit from 'stampit';

import OpenSeadragon from 'openseadragon';

it('calls "load" on each plugin', async () => {
  const fetch = jest.fn((url) => Promise.resolve({text: () => '<i>bar</i>' }))
  const wind = {
    fetch: fetch
  }

  const getElementByIdMock = jest.fn((id) => { return { innerHTML: id } });
  const doc = {
    getElementById: getElementByIdMock
  };

  const load = jest.fn();
  const kalturaPlugin = stampit({
    methods: {
      load: () => load()
    }
  });

  const plugins = [kalturaPlugin]
  const viewer = Viewer({ plugins: plugins,
                          wind: wind,
                          doc: doc});
  await viewer.viewerSideLoad(1,2)
  expect(fetch.mock.calls[0][0]).toBe('/viewers/1/2');
  expect(getElementByIdMock.mock.calls[0][0]).toBe('viewer-display');
  expect(load.mock.calls.length).toBe(1);
});