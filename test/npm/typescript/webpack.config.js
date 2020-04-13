var glob = require ("glob");
var path = require ("path");

var allTests = glob.sync ('./**/*.js', { "ignore": [ './webpack.config.js', './bundle.js' ]});

module.exports = {
	mode: "development",
	devtool: "source-map",
	node: {
		fs: 'empty'
	},
	entry: {
		bundle: allTests
	},
	output: {
		path: __dirname
	},
	externals: [{
		mocha: true
	}],
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, '../../../lib/openfl/')
		}
	}
};