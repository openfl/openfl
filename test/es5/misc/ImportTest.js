var openfl = require ("openfl");
var geom = require ("openfl/geom");
var Rectangle = require ("openfl/geom/Rectangle").default;
var assert = require ("assert");


describe ("ES5 | Imports", function () {
	
	
	it ("test", function () {
		
		// console.log (openfl);
		// console.log (geom);
		// console.log (Rectangle);
		
		assert (Rectangle);
		assert.equal (openfl.geom.Rectangle, Rectangle);
		assert.equal (geom.Rectangle, Rectangle);
		
	});
	
	
});