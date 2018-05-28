const path = require ("path");

module.exports = {
	entry: {
		openfl: "./lib/openfl/index.js"
	},
	devtool: "source-map",
	output: {
		path: path.resolve (__dirname, "dist"),
		library: 'openfl',
		libraryTarget: 'umd'
	},
	externals: {
		howler: {
			commonjs: 'Howler',
			commonjs2: 'Howler',
			amd: 'Howler',
			root: 'window'
		},
		pako: {
			commonjs: 'pako',
			commonjs2: 'pako',
			amd: 'pako',
			root: 'pako'
		}
	}
};