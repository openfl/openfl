const webpack = require ("webpack");
const merge = require ("webpack-merge");
const common = require ("./webpack.common.js");
const package = require ("./package.json");

var banner = "/*!\n"
 + " * OpenFL v" + package.version + "\n"
 + " * http://www.openfl.org\n"
 + " * \n"
 + " * Copyright Joshua Granick and other OpenFL contributors\n"
 + " * Released under the MIT license\n"
 + " */";

module.exports = merge (common, {
	output: {
		filename: "openfl.js"
	},
	plugins: [
		new webpack.BannerPlugin ({
			banner: banner,
			raw: true,
			entryOnly: true
		})
	]
});