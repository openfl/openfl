var glob = require ("glob");
var path = require ("path");

module.exports = {
	mode: "development",
	node: {
		fs: 'empty'
	},
	entry: {
		bundle: [ "./entry.js" ]
	},
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, '../../lib/openfl/')
		}
	}
};