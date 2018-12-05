import ColorMatrixFilter from "openfl/filters/ColorMatrixFilter";
import * as assert from "assert";


describe ("TypeScript | ColorMatrixFilter", function () {
	
	
	it ("matrix", function () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ([1, 2, 3]);
		var exists = colorMatrixFilter.matrix;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ();
		assert.notEqual (colorMatrixFilter, null);
		
	});
	
	
	it ("clone", function () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ();
		var exists = colorMatrixFilter.clone;
		
		assert.notEqual (exists, null);
		
	});
	
	
});