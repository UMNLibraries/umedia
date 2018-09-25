import stampit from 'stampit';

// A container for Sidebar Data
export default stampit({
  props: {
    id: null,
    child_id: null,
    page: null,
    query: null,
  },
  init({id, child_id, page = 1, query = ''}) {
    this.id = id;
    this.child_id = child_id;
    this.page = page;
    this.query = query;
  }
});