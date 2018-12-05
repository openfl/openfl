package openfl.display;


class SpriteTest { public static function __init__ () { Mocha.describe ("Haxe | Sprite", function () {
	
	
	Mocha.it ("buttonMode", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.buttonMode;
		
		Assert.assert (!exists);
		
	});
	
	
	Mocha.it ("graphics", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.graphics;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("hitArea", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.hitArea;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("useHandCursor", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.useHandCursor;
		
		Assert.assert (exists);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		
		Assert.notEqual (sprite, null);
		
	});
	
	
	Mocha.it ("startDrag", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.startDrag;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("stopDrag", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.stopDrag;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}