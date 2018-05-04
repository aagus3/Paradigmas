const webpack = require('webpack');
const config = require('./webpack.config');
const appSettings = require('./app.settings.js');

config.entry = [
  'webpack-dev-server/client?http://0.0.0.0:3000',
  './assets/index'
];

config.devtool = 'source-map';

config.devServer = {
  headers: { "Access-Control-Allow-Origin": "*" },
  historyApiFallback: true,
  host: "0.0.0.0",
  inline: true,
  port: 3000,
  watchOptions: {
    poll: 1000
  }
};

config.output.publicPath = "http://localhost:3000/static/";

config.plugins = [
  new webpack.DefinePlugin(appSettings),
  new webpack.DefinePlugin({'process.env.NODE_ENV': JSON.stringify('development')})
];

module.exports = config;