var glob = require ("glob");
var path = require ("path");

module.exports = {
	node: {
		fs: 'empty'
	},
	entry: {
		bundle: [ "./entry.js" ]
	},
	output: {
		filename: "bundle.js",
	},
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, '../../lib/openfl/')
		}
	},
	devtool: "source-map"
};