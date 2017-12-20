package openfl.display;


import openfl.display.DOMSprite;


class DOMSpriteTest { public static function __init__ () { Mocha.describe ("Haxe | DOMSprite", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var domSprite = new DOMSprite (null);
		var exists = domSprite;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}