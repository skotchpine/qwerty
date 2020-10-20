const { environment } = require('@rails/webpacker')


//adding bootstrap

const webpack = require('webpack')
environments.plugins.append('Provide',new webpack.ProvidePlugin({$: 'jquery',jQuery: 'jquery',Popper: ['popper.js','default']}))
module.exports = environment