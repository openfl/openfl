package openfl.display;


import openfl.display.InteractiveObject;
import openfl.geom.Rectangle;


class InteractiveObjectTest { public static function __init__ () { Mocha.describe ("Haxe | InteractiveObject", function () {
	
	
	Mocha.it ("doubleClickEnabled", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.doubleClickEnabled;
		
		Assert.assert (!exists);
		
	});
	
	
	Mocha.it ("focusRect", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.focusRect;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("mouseEnabled", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseEnabled;
		
		Assert.assert (exists);
		
	});
	
	
	Mocha.it ("needsSoftKeyboard", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.needsSoftKeyboard;
		
		Assert.assert (!exists);
		
	});
	
	
	Mocha.it ("softKeyboardInputAreaOfInterest", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.softKeyboardInputAreaOfInterest;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("tabEnabled", function () {
		
		var sprite = new Sprite ();
		Assert.assert (!sprite.tabEnabled);
		
		sprite.buttonMode = true;
		Assert.assert (sprite.tabEnabled);
		
		sprite.tabEnabled = false;
		Assert.assert (!sprite.tabEnabled);
		
		sprite.buttonMode = false;
		sprite.buttonMode = true;
		Assert.assert (!sprite.tabEnabled);
		
		sprite.tabEnabled = true;
		Assert.assert (sprite.tabEnabled);
		
	});
	
	
	Mocha.it ("tabIndex", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.tabIndex;
		
		//Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		
		Assert.notEqual (sprite, null);
		
	});
	
	
	Mocha.it ("requestSoftKeyboard", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.requestSoftKeyboard;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}