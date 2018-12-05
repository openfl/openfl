package openfl.events;


import openfl.display.Sprite;


class EventTest { public static function __init__ () { Mocha.describe ("Haxe | Event", function () {
	
	
	Mocha.it ("bubbles", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.bubbles;
		
		Assert.assert (!exists);
		
	});
	
	
	Mocha.it ("cancelable", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.cancelable;
		
		Assert.assert (!exists);
		
	});
	
	
	Mocha.it ("currentTarget", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.currentTarget;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("eventPhase", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.eventPhase;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("target", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.target;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("type", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.type;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// ADDED
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		var called = false;
		var called2 = false;
		
		var listener = function (e:Event) {
			
			called = true;
			
			Assert.equal (e.target, sprite);
			Assert.equal (e.currentTarget, sprite);
			
		}
		
		var listener2 = function (e:Event) {
			
			called2 = true;
			
			Assert.equal (e.target, sprite);
			Assert.equal (e.currentTarget, sprite2);
			
		}
		
		sprite.addEventListener (Event.ADDED, listener);
		sprite2.addEventListener (Event.ADDED, listener2);
		sprite2.addChild (sprite);
		
		Assert.assert (called);
		Assert.assert (called2);
		
		sprite.removeEventListener (Event.ADDED, listener);
		sprite2.removeEventListener (Event.ADDED, listener2);
		
		// ADDED_TO_STAGE
		
		called = false;
		called2 = false;
		
		var listener = function (e:Event) {
			
			called = true;
			
			Assert.equal (e.target, sprite);
			Assert.equal (e.currentTarget, sprite);
			
		}
		
		var listener2 = function (e:Event) {
			
			called2 = true;
			
			Assert.equal (e.target, sprite2);
			Assert.equal (e.currentTarget, sprite2);
			
		}
		
		sprite.addEventListener (Event.ADDED_TO_STAGE, listener);
		sprite2.addEventListener (Event.ADDED_TO_STAGE, listener2);
		Lib.current.stage.addChild (sprite2);
		
		Assert.assert (called);
		Assert.assert (called2);
		
	});
	
	
	Mocha.it ("clone", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.clone;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("isDefaultPrevented", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.isDefaultPrevented;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("stopImmediatePropagation", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.stopImmediatePropagation;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("stopPropagation", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.stopPropagation;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
}); }}