import stampit from 'stampit';
import seadragonPlugin from './plugins/openseadragon_plugin.js';
import kalturaPlugin from './plugins/kaltura_plugin.js';

export default stampit({
  props: {
    plugins: [seadragonPlugin, kalturaPlugin]
  },
  init({ plugins = this.plugins }) {
    this.plugins = plugins;
  },
  methods: {
    // The caller injects it's this context here, so that plugins may gain
    // access to the arguments of the caller's constructor.
    // plugins simply need to provide a load function to participate in the
    // plugin role
    loadPlugins(self) {
      stampit.apply(self, self.plugins)(self).load();
    }
  }
});