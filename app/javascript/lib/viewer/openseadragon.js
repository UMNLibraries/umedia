import stampit from 'stampit';
import OpenSeadragon from 'openseadragon';

// TODO: refactor viewer osd code to make use of this object
export default stampit({
  props: {
    OSD: OpenSeadragon,
    seadragon: null,
    currentRotation: 0,
  },
  init({ OSD = this.OSD, osdConfig }) {
    this.osdConfig = osdConfig
    // OpenSeadragon Mounts to the DOM on instantiation. So, we don't
    // instantiate it unless we have a config for it
    if (osdConfig) {
      let seadragon = OSD(osdConfig);
      let currentRotation = this.currentRotation;
      this.rotateImage = function rotateImage() {
        seadragon.viewport.setRotation(currentRotation += 90);
      }
    }
  }
});