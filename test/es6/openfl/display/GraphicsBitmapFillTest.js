import BitmapData from "openfl/display/BitmapData";
import GraphicsBitmapFill from "openfl/display/GraphicsBitmapFill";
import Matrix from "openfl/geom/Matrix";
import * as assert from "assert";


describe ("ES6 | GraphicsBitmapFill", function () {
	
	
	it ("bitmapData", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill (new BitmapData (100, 100));
		var exists = bitmapFill.bitmapData;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("matrix", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill (null, new Matrix ());
		var exists = bitmapFill.matrix;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("repeat", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill.repeat;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("smooth", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill.smooth;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill;
		
		assert.notEqual (exists, null);
		
	});
	
	
});