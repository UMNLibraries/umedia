
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
  expect(pushState.mock.calls[0]).toEqual([{"child_id": false, "child_index": null, "id": "coll:1234", "query": "minnesota", "sidebar_page": 1}, "", "http://localhost//item/coll:1234?child_index&query=minnesota&sidebar_page=1"]);
});