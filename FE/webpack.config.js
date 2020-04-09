const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');


module.exports = {
  mode: "development",
  entry: {
    main: "./src/app.js"
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "dist")
  },
  module: {
    rules: [
      {
       test: /\.scss$/,
       use: [
          'style-loader',
          'css-loader',
          'sass-loader'
       ]
      },
      {
        test: /\.(png|jpg|gif)$/,
        loader: 'url-loader',
          options: {
            name: '[name].[ext]?[hash]',
            limit: 5000
          }
       },
       {
         test: /\.js$/,
         loader: 'babel-loader',
         exclude: /node_modules/
       }
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './index.html'
    }),
    new MiniCssExtractPlugin({filename: `[name].css`})
  ]
}