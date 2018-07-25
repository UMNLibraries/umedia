const { environment } = require('@rails/webpacker')
const webpack = require('webpack')


// See: https://github.com/rails/webpacker/blob/master/docs/webpack.md#plugins
// And: https://webpack.js.org/plugins/provide-plugin/
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    bootstrap: 'bootstrap',
    noThumbnail: 'noThumbnail',
  })
)

module.exports = environment