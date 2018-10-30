import stampit from 'stampit';

// A container for Sidebar Data
export default stampit({
  props: {
    id: null,
    child_id: null,
    // Original indexing order; useful to get a user back to the image selected
    // in the context of a search after clear search has been clicked
    child_index: null,
    page: null,
    query: null,
    // TODO: refactor perPage...everywhere
    // Shotgun Surgery: this var is sprinkled throughout the codebase
    perPage: 3,
  },
  init({id, child_id, child_index = 0, page = 1, query = ''}) {
    this.id = id;
    this.child_id = child_id;
    this.child_index = Number(child_index);
    const absolutePage = () => {
      // Child Index allows us to navigate back to a record when a search
      // has been run and then cleared. Least surprise for the end-user:
      // they just stay on the record they are on during the search.
      if (child_index > 0 && query == '') {
        return Math.ceil( (this.child_index + 1) / this.perPage)
      } else {
        return page;
      }
    }

    this.page = absolutePage();
    this.query = query;
  }
});