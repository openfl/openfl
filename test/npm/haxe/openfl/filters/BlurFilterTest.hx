package openfl.filters;


class BlurFilterTest { public static function __init__ () { Mocha.describe ("Haxe | BlurFilter", function () {
	
	
	Mocha.it ("blurX", function () {
		
		// TODO: Confirm functionality
		
		var blurFilter = new BlurFilter ();
		var exists = blurFilter.blurX;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("blurY", function () {
		
		// TODO: Confirm functionality
		
		var blurFilter = new BlurFilter ();
		var exists = blurFilter.blurY;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("quality", function () {
		
		// TODO: Confirm functionality
		
		var blurFilter = new BlurFilter ();
		var exists = blurFilter.quality;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var blurFilter = new BlurFilter ();
		Assert.notEqual (blurFilter, null);
		
	});
	
	
}); }}