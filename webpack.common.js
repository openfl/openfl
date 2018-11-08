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
			commonjs: 'howler',
			commonjs2: 'howler',
			amd: 'howler',
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