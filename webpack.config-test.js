var webpack = require("webpack");
var path = require("path");
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var BrowserSyncPlugin = require('browser-sync-webpack-plugin');

module.exports = {
  entry: {
    "main": "./src/main.js",
  },
  output: {
    path: path.join(__dirname, "./build"),
    filename: '[name].js',
    publicPath: '/'
  },
  //devtool: 'source-map',
  module: {
    loaders: [
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract('style-loader', 'css-loader!sass-loader?includePaths[]=' + path.resolve(__dirname, './build/sass')),
      }
    ]
  },
  resolve: {
    extensions: ["", ".js", ".coffee", ".scss"],
    modulesDirectories: ["src", "node_modules"],
  },
  plugins: [
    // extract inline css into separate 'styles.css'
    new ExtractTextPlugin('crumbnav.css'),
    new BrowserSyncPlugin(
      {
        host: 'localhost',
        port: 3000,
        server: { baseDir: ['demo'] }
      },
      {
        callback: function () {
          console.log('browserSync started at http://localhost:3000');
        }
      }
    )
  ]
}
