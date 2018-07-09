import stampit from 'stampit';

export default stampit({
  props: {
    $: $,
    k_configId: 'kaltura-config',
    k_config: null,
  },
  init({ $ = this.$ }) {
    this.$ = $;
    this.k_config = $(`#${this.k_configId}`);
  },
  methods: {
    load() {
      if (this.k_config.length > 0) {
        kWidget.embed(this.k_config.data('config'));
      }
    }
  }
});