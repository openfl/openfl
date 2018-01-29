package openfl.filters;


class ColorMatrixFilterTest { public static function __init__ () { Mocha.describe ("Haxe | ColorMatrixFilter", function () {
	
	
	Mocha.it ("matrix", function () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ([1, 2, 3]);
		var exists = colorMatrixFilter.matrix;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ();
		Assert.notEqual (colorMatrixFilter, null);
		
	});
	
	
	Mocha.it ("clone", function () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ();
		var exists = colorMatrixFilter.clone;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}