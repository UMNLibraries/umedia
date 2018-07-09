import stampit from 'stampit';
// Load content from a given endpoint and inject it into the page
export default stampit({
  props: {
    doc: null,
    wind: null,
    $: null,
  },
  init({ doc, wind, $ }) {
    this.doc = doc;
    this.wind = wind;
    this.$ = $;
  },
  methods: {
    viewerSideLoad(id, child_id = false) {
      let doc = this.doc;
      const ids = (child_id) ? `${id}/${child_id}` : id
      const loadPlugins = this.loadPlugins;
      const that = this;
      return this.wind.fetch(`/viewers/${ids}`)
        .then(response => response.text())
        .then(html => {
          doc.getElementById("viewer-display").innerHTML = html;
          loadPlugins(that);
        });
    },
    pagesSideLoad(id, searchText = '') {
      let doc = this.doc;
      return this.wind.fetch(`/child_search/${id}/${searchText}`)
        .then(response => response.text())
        .then(html => {
          doc.getElementById("sidebar-pages").innerHTML = html;
        });
    }
  }
});