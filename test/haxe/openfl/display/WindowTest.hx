package openfl.display;


import openfl.display.Window;


class WindowTest { public static function __init__ () { Mocha.describe ("Haxe | Window", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var window = new Window ();
		var exists = window;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}