package openfl.display;


import openfl.display.Application;


class ApplicationTest { public static function __init__ () { Mocha.describe ("Haxe | Application", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var application = new Application ();
		var exists = application;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}