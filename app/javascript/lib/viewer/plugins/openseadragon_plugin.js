import stampit from 'stampit';
import OpenSeadragon from 'openseadragon';

export default stampit({
  props: {
    $: null,
    OSD: OpenSeadragon,
    seadragon: null,
    osd_configId: '#osd-config',
    osd_config: {},
    currentRotation: 0,
  },
  init({ $, OSD = this.OSD, osd_configId = this.osd_configId }) {
    this.$ = $;
    this.osd_configId = osd_configId;
    this.osd_config = $(this.osd_configId)
    // OpenSeadragon Mounts to the DOM on instantiation. So, we don't
    // instantiate it unless we have a config for it
    if (this.osd_config.length > 0 ) {
      let seadragon = OSD(this.osd_config.data('config'));
      let currentRotation = this.currentRotation;
      this.rotateImage = function rotateImage() {
        seadragon.viewport.setRotation(currentRotation += 90);
      }

      // Work-around - keep the focus on the currently viewed item
      seadragon.addHandler("full-screen", function(config) {
        if (config.fullScreen === false) {
          location.reload();
        }
    });
    }
  },
  methods: {
    load() {
      if (this.osd_config.length > 0) {
        const rotateImage = this.rotateImage;
        this.$("#rotate-right").click(() => rotateImage());
      }
    }
  }
});