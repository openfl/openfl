import Sprite from "openfl/display/Sprite";
import Event from "openfl/events/Event";
import Lib from "openfl/Lib";
import * as assert from "assert";


describe ("TypeScript | Event", function () {
	
	
	it ("bubbles", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.bubbles;
		
		assert (!exists);
		
	});
	
	
	it ("cancelable", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.cancelable;
		
		assert (!exists);
		
	});
	
	
	it ("currentTarget", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.currentTarget;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("eventPhase", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.eventPhase;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("target", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.target;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("type", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.type;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// ADDED
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		var called = false;
		var called2 = false;
		
		var listener = function (e:Event) {
			
			called = true;
			
			assert.equal (e.target, sprite);
			assert.equal (e.currentTarget, sprite);
			
		}
		
		var listener2 = function (e:Event) {
			
			called2 = true;
			
			assert.equal (e.target, sprite);
			assert.equal (e.currentTarget, sprite2);
			
		}
		
		sprite.addEventListener (Event.ADDED, listener);
		sprite2.addEventListener (Event.ADDED, listener2);
		sprite2.addChild (sprite);
		
		assert (called);
		assert (called2);
		
		sprite.removeEventListener (Event.ADDED, listener);
		sprite2.removeEventListener (Event.ADDED, listener2);
		
		// ADDED_TO_STAGE
		
		called = false;
		called2 = false;
		
		var listener = function (e:Event) {
			
			called = true;
			
			assert.equal (e.target, sprite);
			assert.equal (e.currentTarget, sprite);
			
		}
		
		var listener2 = function (e:Event) {
			
			called2 = true;
			
			assert.equal (e.target, sprite2);
			assert.equal (e.currentTarget, sprite2);
			
		}
		
		sprite.addEventListener (Event.ADDED_TO_STAGE, listener);
		sprite2.addEventListener (Event.ADDED_TO_STAGE, listener2);
		Lib.current.stage.addChild (sprite2);
		
		assert (called);
		assert (called2);
		
	});
	
	
	it ("clone", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.clone;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("isDefaultPrevented", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.isDefaultPrevented;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("stopImmediatePropagation", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.stopImmediatePropagation;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("stopPropagation", function () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.stopPropagation;
		
		assert.notEqual (exists, null);
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
});