package openfl.display;


import openfl.display.SimpleButton;


class SimpleButtonTest { public static function __init__ () { Mocha.describe ("Haxe | SimpleButton", function () {
	
	
	Mocha.it ("downState", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.downState = new Sprite ();
		var exists = simpleButton.downState;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("enabled", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.enabled;
		
		Assert.assert (exists);
		
	});
	
	
	Mocha.it ("hitTestState", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.hitTestState = new Sprite ();
		var exists = simpleButton.hitTestState;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("overState", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.overState = new Sprite ();
		var exists = simpleButton.overState;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("soundTransform", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.soundTransform;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("tabEnabled", function () {
		
		var simpleButton = new SimpleButton ();
		Assert.assert (simpleButton.tabEnabled);
		
		simpleButton.tabEnabled = false;
		Assert.assert (!simpleButton.tabEnabled);
		
		simpleButton.tabEnabled = true;
		Assert.assert (simpleButton.tabEnabled);
		
	});
	
	
	Mocha.it ("trackAsMenu", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.trackAsMenu;
		
		Assert.assert (!exists);
		
	});
	
	
	Mocha.it ("upState", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.upState = new Sprite ();
		var exists = simpleButton.upState;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("useHandCursor", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.useHandCursor;
		
		Assert.assert (exists);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		
		Assert.notEqual (simpleButton, null);
		
	});
	
	
}); }}