const webpack = require ("webpack");
const merge = require ("webpack-merge");
const BrotliPlugin = require ('brotli-webpack-plugin');
const CompressionPlugin = require ("compression-webpack-plugin");
const common = require ("./webpack.common.js");
const package = require ("./package.json");

module.exports = merge (common, {
	mode: "production",
	output: {
		filename: "[name].min.js"
	},
	plugins: [
		new webpack.BannerPlugin ({
			banner: "/*! OpenFL v" + package.version + " | MIT (c) Joshua Granick and other OpenFL contributors | openfl.org */",
			raw: true,
			entryOnly: true
		}),
		new CompressionPlugin ({
			include: /[A-Za-z0-9]*\.min\.js$/
		}),
		new BrotliPlugin ({
			asset: '[path].br[query]',
			test: /[A-Za-z0-9]*\.min\.js$/
		})
	],
	performance: { hints: false }
});