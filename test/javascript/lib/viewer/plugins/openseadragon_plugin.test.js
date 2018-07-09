import OpenseadragonPlugin from '../../../../../app/javascript/lib/viewer/plugins/openseadragon_plugin.js';

const data = jest.fn();
const click = jest.fn();
const $ = jest.fn(() => {
  return {
    length: 1,
    data: data,
    click: click
  }
});

const setRotation = jest.fn();
const viewport = jest.fn({ setRotation: setRotation })
const OSD = jest.fn(() => {
  return { viewport: viewport }
})

it('looks for an OSD config and consumes it', async () => {
  OpenseadragonPlugin({ $: $, OSD: OSD }).load();
  expect($.mock.calls[0][0]).toBe('#osd-config');
  expect($.mock.calls[1][0]).toBe('#rotate-right');
  expect(data.mock.calls[0][0]).toBe('config');
});