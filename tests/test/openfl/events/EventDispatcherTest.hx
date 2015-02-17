package openfl.events;


import massive.munit.Assert;
import openfl.display.Sprite;


class EventDispatcherTest {
	
	
	@Test public function new_ () {
		
		var dispatcher = new EventDispatcher ();
		
		Assert.isNotNull (dispatcher);
		
		var dispatcher2 = new EventDispatcher (dispatcher);
		
		Assert.isNotNull (dispatcher2);
		
	}
	
	
	@Test public function addEventListener () {
		
		var dispatcher = new EventDispatcher ();
		dispatcher.addEventListener ("event", function (_) {});
		
		Assert.isTrue (dispatcher.hasEventListener ("event"));
		
	}
	
	
	@Test public function dispatchEvent () {
		
		// Standard
		
		var caughtEvent = false;
		var dispatcher = new EventDispatcher ();
		
		var listener = function (_) { 
			
			caughtEvent = true;
			
		};
		
		dispatcher.addEventListener ("event", listener);
		dispatcher.dispatchEvent (new Event ("event"));
		
		Assert.isTrue (caughtEvent);
		
		// Capture is true
		
		var correctPhase = true;
		var dispatcher = new EventDispatcher ();
		
		var listener = function (event:Event) {
			
			correctPhase = (event.eventPhase == EventPhase.CAPTURING_PHASE);
			
		}
		
		dispatcher.addEventListener ("event", listener, true);
		dispatcher.dispatchEvent (new Event ("event"));
		
		Assert.isTrue (correctPhase);
		
		// Capture is false
		
		var correctPhase = true;
		var dispatcher = new EventDispatcher ();
		
		var listener = function (event:Event) { 
			
			if (event.eventPhase == EventPhase.CAPTURING_PHASE) {
				
				correctPhase = false;
				
			}
			
		}
		
		dispatcher.addEventListener ("event", listener, false);
		dispatcher.dispatchEvent (new Event ("event"));
		
		Assert.isTrue (correctPhase);
		
		// First in, first out standard order
		
		var correctOrder = true;
		var dispatcher = new EventDispatcher ();
		
		var listener = function (_) {
			
			correctOrder = false;
			
		}
		
		var listener2 = function (_) {
			
			correctOrder = true;
			
		}
		
		dispatcher.addEventListener ("event", listener);
		dispatcher.addEventListener ("event", listener2);
		
		Assert.isTrue (correctOrder);
		
		// Order by priority
		
		var correctOrder = true;
		var dispatcher = new EventDispatcher ();
		
		var listener = function (_) {
			
			correctOrder = false;
			
		}
		
		var listener2 = function (_) {
			
			correctOrder = true;
			
		}
		
		dispatcher.addEventListener ("event", listener2, false, 10);
		dispatcher.addEventListener ("event", listener, false, 20);
		dispatcher.dispatchEvent (new Event ("event"));
		
		Assert.isTrue (correctOrder);
		
		// Bubbling
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		var spriteEvent = false;
		var sprite2Event = false;
		
		var listener = function (_) {
			
			spriteEvent = true;
			correctOrder = true;
			
		}
		
		var listener2 = function (_) {
			
			sprite2Event = true;
			correctOrder = false;
			
		}
		
		sprite.addEventListener ("event", listener);
		sprite2.addEventListener ("event", listener2);
		sprite.addChild (sprite2);
		sprite2.dispatchEvent (new Event ("event"));
		
		Assert.isFalse (spriteEvent);
		Assert.isTrue (sprite2Event);
		
		sprite2Event = false;
		
		sprite2.dispatchEvent (new Event ("event", true));
		
		Assert.isTrue (spriteEvent);
		Assert.isTrue (sprite2Event);
		Assert.isTrue (correctOrder);
		
		// Capture event bubbling
		
		#if flash // todo
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		var spriteEvent = false;
		var sprite2Event = false;
		
		var listener = function (_) {
			
			spriteEvent = true;
			correctOrder = true;
			
		}
		
		var listener2 = function (_) {
			
			sprite2Event = true;
			correctOrder = false;
			
		}
		
		sprite.addEventListener ("event", listener, true);
		sprite2.addEventListener ("event", listener2, true);
		sprite.addChild (sprite2);
		sprite2.dispatchEvent (new Event ("event"));
		
		Assert.isTrue (spriteEvent);
		Assert.isFalse (sprite2Event);
		
		sprite2Event = false;
		
		sprite2.dispatchEvent (new Event ("event", true));
		
		Assert.isTrue (spriteEvent);
		Assert.isFalse (sprite2Event);
		Assert.isTrue (correctOrder);
		#end
		
	}
	
	
	@Test public function hasEventListener () {
		
		
		
	}
	
	
	@Test public function removeEventListener () {
		
		var dispatcher = new EventDispatcher ();
		var listener = function (_) {};
		dispatcher.addEventListener ("event", listener);
		dispatcher.removeEventListener ("event", listener);
		
		Assert.isFalse (dispatcher.hasEventListener ("event"));
		
	}
	
	
	/*public function toString () {
		
		
		
	}*/
	
	
	@Test public function willTrigger () {
		
		
		
	}
	
	
}