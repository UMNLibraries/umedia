import KalturaPlugin from '../../../../../app/javascript/lib/viewer/plugins/kaltura_plugin.js';

const data = jest.fn();
const click = jest.fn();
const $ = jest.fn(() => {
  return {
    length: 0
  }
});

// TODO: make this a real test one day - mock kWidget
it('looks for a Kaltura config and consumes it', function () {
  KalturaPlugin({ $: $ }).load();
  expect($.mock.calls[0][0]).toBe('#kaltura-config');
});