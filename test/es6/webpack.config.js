var glob = require ("glob");
var path = require ("path");

var allTests = glob.sync ('./**/*.js', { "ignore": [ './webpack.config.js', './bundle.js' ]});

module.exports = {
	node: {
		fs: 'empty'
	},
	entry: {
		bundle: allTests
	},
	output: {
		filename: "bundle.js",
	},
	externals: [{
		mocha: true
	}],
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, '../../lib/openfl/')
		}
	},
	module: {
		rules: [
			{ test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" }
		]
	},
	devtool: "source-map"
};