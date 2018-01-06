import InteractiveObject from "openfl/display/InteractiveObject";
import Sprite from "openfl/display/Sprite";
import Rectangle from "openfl/geom/Rectangle";
import * as assert from "assert";


describe ("ES6 | InteractiveObject", function () {
	
	
	it ("doubleClickEnabled", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.doubleClickEnabled;
		
		assert (!exists);
		
	});
	
	
	it ("focusRect", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.focusRect;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("mouseEnabled", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseEnabled;
		
		assert (exists);
		
	});
	
	
	it ("needsSoftKeyboard", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.needsSoftKeyboard;
		
		assert (!exists);
		
	});
	
	
	it ("softKeyboardInputAreaOfInterest", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.softKeyboardInputAreaOfInterest;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("tabEnabled", function () {
		
		var sprite = new Sprite ();
		assert (!sprite.tabEnabled);
		
		sprite.buttonMode = true;
		assert (sprite.tabEnabled);
		
		sprite.tabEnabled = false;
		assert (!sprite.tabEnabled);
		
		sprite.buttonMode = false;
		sprite.buttonMode = true;
		assert (!sprite.tabEnabled);
		
		sprite.tabEnabled = true;
		assert (sprite.tabEnabled);
		
	});
	
	
	it ("tabIndex", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.tabIndex;
		
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		
		assert.notEqual (sprite, null);
		
	});
	
	
	it ("requestSoftKeyboard", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.requestSoftKeyboard;
		
		assert.notEqual (exists, null);
		
	});
	
	
});