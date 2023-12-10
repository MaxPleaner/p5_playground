const path = require('path');

module.exports = {
  mode: 'development',
  entry: './src/index.coffee',
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [
          'coffee-loader'
        ],
      },
    ],
    
  },
  resolve: {
    extensions: ['.coffee', '.js'],
  },
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist'),
    publicPath: '/', // Add this line
  },
  devServer: {
    static: {
      directory: path.join(__dirname, 'dist'),
    },
    compress: true,
    port: 9000,
    hot: true, // Enable Hot Module Replacement
  }
};
