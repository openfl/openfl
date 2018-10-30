package openfl.display;


import openfl.display.DOMElement;


class DOMElementTest { public static function __init__ () { Mocha.describe ("Haxe | DOMElement", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var domElement = new DOMElement (null);
		var exists = domElement;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}