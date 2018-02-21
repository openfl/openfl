package openfl.display;


import openfl.display.GraphicsSolidFill;


class GraphicsSolidFillTest { public static function __init__ () { Mocha.describe ("Haxe | GraphicsSolidFill", function () {
	
	
	Mocha.it ("alpha", function () {
		
		// TODO: Confirm functionality
		
		var solidFill = new GraphicsSolidFill ();
		var exists = solidFill.alpha;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("color", function () {
		
		// TODO: Confirm functionality
		
		var solidFill = new GraphicsSolidFill ();
		var exists = solidFill.color;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var solidFill = new GraphicsSolidFill ();
		
		Assert.notEqual (solidFill, null);
		
	});
	
	
}); }}