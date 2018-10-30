import Sprite from "openfl/display/Sprite";
import * as assert from "assert";


describe ("ES6 | Sprite", function () {
	
	
	it ("buttonMode", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.buttonMode;
		
		assert (!exists);
		
	});
	
	
	it ("graphics", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.graphics;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("hitArea", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.hitArea;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("useHandCursor", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.useHandCursor;
		
		assert (exists);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		
		assert.notEqual (sprite, null);
		
	});
	
	
	it ("startDrag", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.startDrag;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("stopDrag", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.stopDrag;
		
		assert.notEqual (exists, null);
		
	});
	
	
});