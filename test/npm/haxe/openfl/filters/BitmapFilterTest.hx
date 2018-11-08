package openfl.filters;


class BitmapFilterTest { public static function __init__ () { Mocha.describe ("Haxe | BitmapFilter", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFilter = new BlurFilter ();
		Assert.notEqual (bitmapFilter, null);
		
	});
	
	
	Mocha.it ("clone", function () {
		
		// TODO: Confirm functionality
		
		var bitmapFilter = new BlurFilter ();
		var exists = bitmapFilter.clone;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}