package openfl.display;


import openfl.display.Shape;


class ShapeTest { public static function __init__ () { Mocha.describe ("Haxe | Shape", function () {
	
	
	Mocha.it ("graphics", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var exists = shape.graphics;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		
		Assert.notEqual (shape, null);
		
	});
	
	
}); }}