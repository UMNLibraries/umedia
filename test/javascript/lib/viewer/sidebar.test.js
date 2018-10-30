import Sidebar from '../../../../app/javascript/lib/viewer/sidebar.js';

it('holds sidebar data', () => {
  const sidebar = Sidebar({id: 'col2:234', child_id: 'foo:124', page: 2, query: 'f'})
  expect(sidebar).toEqual({"child_id": "foo:124", "child_index": 0, "id": "col2:234", "page": 2, "perPage": 3, "query": "f"});
});