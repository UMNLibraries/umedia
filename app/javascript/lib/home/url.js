import queryString from 'query-string';
import stampit from 'stampit';

export default stampit({
  props: {
    filter_q: '',
    history: window.history,
    origin: document.location.origin,
    search: document.location.search,
    pathName: document.location.pathname,
    page: 1,
    sort: null,
  },
  init({ history = this.history,
         origin = this.origin,
         search = this.search,
         filter_q = this.filter_q,
         page = this.page,
         sort = this.sort }) {

    this.history = history;

    this.page = page;
    this.sort = sort;

    this.queryParams = function() {
      return { ...queryString.parse(search),
               ...{filter_q: filter_q},
               ...{page: page},
               ...{sort: sort} }
    }
    this.newURL = () => {
      const searchString = queryString.stringify(this.queryParams());
      return `${origin}/home/?${searchString}`
    }

  },
  methods: {
    update() {
      const state = {
          ...this.queryParams(),
          page: this.page,
          sort: this.sort
        };
      this.history.pushState(state, "", this.newURL());
    }
  }
});