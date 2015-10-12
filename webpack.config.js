var webpack = require("webpack");
var path = require("path");
var ExtractTextPlugin = require('extract-text-webpack-plugin');

var BrowserSyncPlugin = require('browser-sync-webpack-plugin');


module.exports = {
  entry: {
    "jquery.crumbnav": "./src/jquery.crumbnav.coffee",
    "jquery.crumbnav-demo": "./src/jquery.crumbnav-demo.coffee"
  },
  output: {
    path: path.join(__dirname, "./build"),
    filename: '[name].js',
    publicPath: '/'
  },
  //devtool: 'source-map',
  module: {
    loaders: [
      { test: /\.coffee/, loader: 'coffee-loader' },
      { test: /\.scss/,
        loader: ExtractTextPlugin.extract('style-loader', 'css-loader!sass-loader?includePaths[]=' + path.resolve(__dirname, '/build/sass')),
      },
      { test: /\.(png|woff|woff2|eot|ttf|svg)$/, loader: 'url-loader?limit=100000' }
    ]
  },
  resolve: {
    extensions: ["", ".js", ".coffee", ".scss"],
    modulesDirectories: ["src", "node_modules"],
  },
  plugins: [
    new ExtractTextPlugin("crumbnav.css"),
    new BrowserSyncPlugin(
      {
        files: ['build/*', 'demo/index.html'],
        host: 'localhost',
        port: 3000,
        server: { baseDir: ['./'], index: 'demo/index.html' }
      },
      {
        callback: function () {
          console.log('browserSync started at http://localhost:3000');
        }
      }
    )
  ],
  watchOptions: {
    poll: true
  }
}
