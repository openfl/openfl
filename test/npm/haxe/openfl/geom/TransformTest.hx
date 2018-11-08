package openfl.geom;


import openfl.display.Sprite;


class TransformTest { public static function __init__ () { Mocha.describe ("Haxe | Transform", function () {
	
	
	Mocha.it ("colorTransform", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.colorTransform;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("concatenatedColorTransform", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.concatenatedColorTransform;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("concatenatedMatrix", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.concatenatedMatrix;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("matrix", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.matrix;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("pixelBounds", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.pixelBounds;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		Assert.notEqual (transform, null);
		
	});
	
	
}); }}