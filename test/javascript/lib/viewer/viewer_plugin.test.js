import stampit from 'stampit';
import ViewerPlugins from '../../../../app/javascript/lib/viewer/viewer_plugins.js';

it('iterates through a set of plugins and calls each', async () => {
  const load = jest.fn();
  const plugin = stampit({
    methods: {
      load: () => load()
    }
  });

  const viewer = ViewerPlugins({plugins: [plugin]});
  viewer.loadPlugins(viewer);
  expect(load.mock.calls.length).toBe(1);
});