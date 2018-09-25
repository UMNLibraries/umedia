
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
    childId: 'coll:4321',
    history: history,
  });
  viewer.update();
  expect(pushState.mock.calls[0]).toEqual( [ null,'', 'http://localhost//item/coll:1234?query=minnesota&sidebar_page=1' ]);
});