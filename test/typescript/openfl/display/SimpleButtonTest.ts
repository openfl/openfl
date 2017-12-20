import SimpleButton from "openfl/display/SimpleButton";
import Sprite from "openfl/display/Sprite";
import * as assert from "assert";


describe ("TypeScript | SimpleButton", function () {
	
	
	it ("downState", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.downState = new Sprite ();
		var exists = simpleButton.downState;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("enabled", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.enabled;
		
		assert (exists);
		
	});
	
	
	it ("hitTestState", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.hitTestState = new Sprite ();
		var exists = simpleButton.hitTestState;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("overState", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.overState = new Sprite ();
		var exists = simpleButton.overState;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("soundTransform", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.soundTransform;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("tabEnabled", function () {
		
		var simpleButton = new SimpleButton ();
		assert (simpleButton.tabEnabled);
		
		simpleButton.tabEnabled = false;
		assert (!simpleButton.tabEnabled);
		
		simpleButton.tabEnabled = true;
		assert (simpleButton.tabEnabled);
		
	});
	
	
	it ("trackAsMenu", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.trackAsMenu;
		
		assert (!exists);
		
	});
	
	
	it ("upState", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.upState = new Sprite ();
		var exists = simpleButton.upState;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("useHandCursor", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.useHandCursor;
		
		assert (exists);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		
		assert.notEqual (simpleButton, null);
		
	});
	
	
});