package openfl.display;


import openfl.display.GraphicsStroke;


class GraphicsStrokeTest { public static function __init__ () { Mocha.describe ("Haxe | GraphicsStroke", function () {
	
	
	Mocha.it ("caps", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.caps;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("fill", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		stroke.fill = new GraphicsSolidFill ();
		var exists = stroke.fill;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("joints", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.joints;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("miterLimit", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.miterLimit;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("pixelHinting", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.pixelHinting;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("scaleMode", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.scaleMode;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("thickness", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.thickness;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		
		Assert.notEqual (stroke, null);
		
	});
	
	
}); }}