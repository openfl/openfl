package openfl.events;


import massive.munit.Assert;
import openfl.display.Sprite;


class EventTest {
	
	
	@Test public function bubbles () {
		
		
		
	}
	
	
	@Test public function cancelable () {
		
		
		
	}
	
	
	@Test public function currentTarget () {
		
		
		
	}
	
	
	@Test public function eventPhase () {
		
		
		
	}
	
	
	@Test public function target () {
		
		
		
	}
	
	
	@Test public function type () {
		
		
		
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
		
		
		
	}
	
	
	@Test public function formatToString () {
		
		
		
	}
	
	
	@Test public function isDefaultPrevented () {
		
		
		
	}
	
	
	@Test public function preventDefault () {
		
		
		
	}
	
	
	@Test public function stopImmediatePropagation () {
		
		
		
	}
	
	
	@Test public function stopPropagation () {
		
		
		
	}
	
	
	/*public function toString () {
		
		
		
	}*/
	
	
}