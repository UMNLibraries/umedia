import TranscriptsLoad from '../../../../app/javascript/lib/viewer/transcripts_load.js';


it('adjusts expands the sidebar', async () => {
  const fetchPromise = new Promise((resolve, reject) => {
    resolve({text: () => '<div>Foo</div>'});
  });

  const fetcher = {
    fetch: () => fetchPromise
  }

  const transcriptsElem = {
    _innerHTML: false,
    set innerHTML(val) {
      this._innerHTML = val;
    },
    get innerHTML() {
      return this._innerHTML;
    },
  }

  const spy = jest.spyOn(transcriptsElem, 'innerHTML', 'set');

  await TranscriptsLoad(10, transcriptsElem, fetcher)
  expect(spy).toHaveBeenCalled();
  expect(transcriptsElem.innerHTML).toBe('<div>Foo</div>');
});
