var glob = require ("glob");
var path = require ("path");

var allTests = glob.sync ('./**/*.js', { "ignore": [ './webpack.config.js', './bundle.js' ]});

module.exports = {
	mode: "development",
	node: {
		fs: 'empty'
	},
	entry: {
		bundle: allTests
	},
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, '../../lib/openfl/')
		}
	}
};