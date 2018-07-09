import queryString from 'query-string';
import stampit from 'stampit';

export default stampit({
  props: {
    q: '',
    history: window.history,
    origin: document.location.origin,
    search: document.location.search,
    path_name: document.location.pathname,
    id: false,
    child_id: false,
  },
  init({ history = this.history,
         origin = this.origin,
         search = this.search,
         q = this.q,
         id = this.id,
         child_id = this.child_id}) {

    this.history = history;
    const default_path = this.path_name;


    const idsPath = function() {
      return [id, child_id].filter(id => id).join('/')
    }

    const pathName = function() {
      return (idsPath() != '') ? `/item/${idsPath()}` : default_path;
    }

    const queryParams = function() {
      return { ...queryString.parse(search), ...{query: q} }
    }

    this.newURL = function() {
      const searchString = queryString.stringify(queryParams());
      return `${origin}${pathName()}?${searchString}`
    }

  },
  methods: {
    update() {
      this.history.pushState(null,"", this.newURL());
    }
  }
});