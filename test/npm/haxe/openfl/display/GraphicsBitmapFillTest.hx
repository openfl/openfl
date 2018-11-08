package openfl.display;


import openfl.display.BitmapData;
import openfl.display.GraphicsBitmapFill;
import openfl.geom.Matrix;


class GraphicsBitmapFillTest { public static function __init__ () { Mocha.describe ("Haxe | GraphicsBitmapFill", function () {
	
	
	Mocha.it ("bitmapData", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill (new BitmapData (100, 100));
		var exists = bitmapFill.bitmapData;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("matrix", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill (null, new Matrix ());
		var exists = bitmapFill.matrix;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("repeat", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill.repeat;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("smooth", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill.smooth;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}