package openfl.events;


import massive.munit.Assert;
import openfl.display.Sprite;


class EventTest {
	
	
	@Test public function bubbles () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.bubbles;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function cancelable () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.cancelable;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function currentTarget () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.currentTarget;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function eventPhase () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.eventPhase;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function target () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.target;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function type () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.type;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// ADDED
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		var called = false;
		var called2 = false;
		
		var listener = function (e:Event) {
			
			called = true;
			
			Assert.areSame (e.target, sprite);
			Assert.areSame (e.currentTarget, sprite);
			
		}
		
		var listener2 = function (e:Event) {
			
			called2 = true;
			
			Assert.areSame (e.target, sprite);
			Assert.areSame (e.currentTarget, sprite2);
			
		}
		
		sprite.addEventListener (Event.ADDED, listener);
		sprite2.addEventListener (Event.ADDED, listener2);
		sprite2.addChild (sprite);
		
		Assert.isTrue (called);
		Assert.isTrue (called2);
		
		sprite.removeEventListener (Event.ADDED, listener);
		sprite2.removeEventListener (Event.ADDED, listener2);
		
		// ADDED_TO_STAGE
		
		called = false;
		called2 = false;
		
		var listener = function (e:Event) {
			
			called = true;
			
			Assert.areSame (e.target, sprite);
			Assert.areSame (e.currentTarget, sprite);
			
		}
		
		var listener2 = function (e:Event) {
			
			called2 = true;
			
			Assert.areSame (e.target, sprite2);
			Assert.areSame (e.currentTarget, sprite2);
			
		}
		
		sprite.addEventListener (Event.ADDED_TO_STAGE, listener);
		sprite2.addEventListener (Event.ADDED_TO_STAGE, listener2);
		Lib.current.stage.addChild (sprite2);
		
		Assert.isTrue (called);
		Assert.isTrue (called2);
		
	}
	
	
	@Test public function clone () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.clone;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function isDefaultPrevented () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.isDefaultPrevented;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stopImmediatePropagation () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.stopImmediatePropagation;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stopPropagation () {
		
		// TODO: Confirm functionality
		
		var event = new Event (Event.ACTIVATE);
		var exists = event.stopPropagation;
		
		Assert.isNotNull (exists);
		
	}
	
	
	/*public function toString () {
		
		
		
	}*/
	
	
}