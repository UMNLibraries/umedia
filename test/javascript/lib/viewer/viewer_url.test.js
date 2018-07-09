import ViewerUrl from '../../../../app/javascript/lib/viewer/viewer_url.js';

it('updates a search parameter', async () => {
  const pushState = jest.fn()
  const history = {
    pushState: pushState,
  }


  const viewer = ViewerUrl({
    origin: 'http://localhost/',
    search: {"foo": "bar"},
    q: 'minnesota',
    id: 'coll:1234',
    child_id: 'coll:4321',
    history: history,
  });
  viewer.update();
  expect(pushState.mock.calls[0]).toEqual( [ null,'', 'http://localhost//item/coll:1234/coll:4321?query=minnesota' ]);
});