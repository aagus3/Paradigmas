const webpack = require('webpack');
const appSettings = require('./app.settings.js');

module.exports = {
  context: __dirname,
  entry: './assets/index',
  output: {
      path: __dirname + '/public/static',
      filename: 'bundle.js'
  },
  resolve: {
    modules: ['node_modules'],
    extensions: ['.js', '.jsx']
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      }, {
        test: /\.s?css$/,
        use: [ 'style-loader', 'css-loader', 'sass-loader' ]
      }, {
        test: /\.(?:png|jpg|svg)$/,
        loader: 'url-loader',
        query: {
          // Inline images smaller than 10kb as data URIs
          limit: 10000
        }
      }
    ]
  },
  plugins: [
    new webpack.DefinePlugin(appSettings),
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    }),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        warnings: false
      }
    })
  ]
};