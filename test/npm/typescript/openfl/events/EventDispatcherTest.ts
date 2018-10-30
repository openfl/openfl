import Sprite from "openfl/display/Sprite";
import Event from "openfl/events/Event";
import EventDispatcher from "openfl/events/EventDispatcher";
import EventPhase from "openfl/events/EventPhase";
import * as assert from "assert";


describe ("TypeScript | EventDispatcher", function () {
	
	
	it ("new", function () {
		
		var dispatcher = new EventDispatcher ();
		
		assert.notEqual (dispatcher, null);
		
		var dispatcher2 = new EventDispatcher (dispatcher);
		
		assert.notEqual (dispatcher2, null);
		
	});
	
	
	it ("addEventListener", function () {
		
		var dispatcher = new EventDispatcher ();
		dispatcher.addEventListener ("event", function (_) {});
		
		assert (dispatcher.hasEventListener ("event"));
		
	});
	
	
	it ("dispatchEvent", function () {
		
		// Standard
		
		var caughtEvent = false;
		var dispatcher = new EventDispatcher ();
		
		var listener = function (event:Event) { 
			
			caughtEvent = true;
			
		};
		
		dispatcher.addEventListener ("event", listener);
		dispatcher.dispatchEvent (new Event ("event"));
		
		assert (caughtEvent);
		
		// Capture is true
		
		var correctPhase = false; // fail unless we see correct event
		var dispatcher = new EventDispatcher ();
		
		var listener = function (event:Event) {
			
			correctPhase = (event.eventPhase == EventPhase.CAPTURING_PHASE);
			
		}
		
		dispatcher.addEventListener ("event", listener, true);
		dispatcher.dispatchEvent (new Event ("event"));
		
		// TODO: this dispatchEvent will never go through CAPTURING_PHASE.
		// It needs to come from Stage
		// (or possibly through e.g. DisplayObject.__dispatchStack)
		// See FocusEventTest for an example.
		//DISABLED//assert (correctPhase);
		
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
		
		assert (correctPhase);
		
		// First in, first out standard order
		
		var correctOrder = true;
		var dispatcher = new EventDispatcher ();
		
		var listener = function (event:Event) {
			
			correctOrder = false;
			
		}
		
		var listener2 = function (event:Event) {
			
			correctOrder = true;
			
		}
		
		dispatcher.addEventListener ("event", listener);
		dispatcher.addEventListener ("event", listener2);
		
		assert (correctOrder);
		
		// Order by priority
		
		var correctOrder = true;
		var dispatcher = new EventDispatcher ();
		
		var listener = function (event:Event) {
			
			correctOrder = false;
			
		}
		
		var listener2 = function (event:Event) {
			
			correctOrder = true;
			
		}
		
		dispatcher.addEventListener ("event", listener2, false, 10);
		dispatcher.addEventListener ("event", listener, false, 20);
		dispatcher.dispatchEvent (new Event ("event"));
		
		assert (correctOrder);
		
		// Bubbling
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		var spriteEvent = false;
		var sprite2Event = false;
		
		var listener = function (event:Event) {
			
			spriteEvent = true;
			correctOrder = true;
			
		}
		
		var listener2 = function (event:Event) {
			
			sprite2Event = true;
			correctOrder = false;
			
		}
		
		sprite.addEventListener ("event", listener);
		sprite2.addEventListener ("event", listener2);
		sprite.addChild (sprite2);
		sprite2.dispatchEvent (new Event ("event"));
		
		assert (!spriteEvent);
		assert (sprite2Event);
		
		sprite2Event = false;
		
		sprite2.dispatchEvent (new Event ("event", true));
		
		assert (spriteEvent);
		assert (sprite2Event);
		assert (correctOrder);
		
		// Capture event bubbling
		
		// #if flash // todo
		// var sprite = new Sprite ();
		// var sprite2 = new Sprite ();
		
		// var spriteEvent = false;
		// var sprite2Event = false;
		
		// var listener = function (_) {
			
		// 	spriteEvent = true;
		// 	correctOrder = true;
			
		// }
		
		// var listener2 = function (_) {
			
		// 	sprite2Event = true;
		// 	correctOrder = false;
			
		// }
		
		// sprite.addEventListener ("event", listener, true);
		// sprite2.addEventListener ("event", listener2, true);
		// sprite.addChild (sprite2);
		// sprite2.dispatchEvent (new Event ("event"));
		
		// assert (spriteEvent);
		// assert (!sprite2Event);
		
		// sprite2Event = false;
		
		// sprite2.dispatchEvent (new Event ("event", true));
		
		// assert (spriteEvent);
		// assert (!sprite2Event);
		// assert (correctOrder);
		// #end
		
	});
	
	
	it ("hasEventListener", function () {
		
		
		
	});
	
	
	it ("removeEventListener", function () {
		
		var dispatcher = new EventDispatcher ();
		var listener = function (_) {};
		dispatcher.addEventListener ("event", listener);
		dispatcher.removeEventListener ("event", listener);
		
		assert (!dispatcher.hasEventListener ("event"));
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
	it ("willTrigger", function () {
		
		
		
	});
	
	
	it ("testSimpleNestedDispatch", function () {
		
		var test01aCallCount = 0;
		var o = new EventDispatcher();
		
		var test01a = function (e:Event):void {
			++test01aCallCount;
			if ( test01aCallCount == 1 ) { // avoid infinite recursion, but we still should get a second call
				o.dispatchEvent( new Event("Test01Event") );
			}
		}
		
		o.addEventListener( "Test01Event", test01a );
		o.dispatchEvent( new Event( "Test01Event" ) );
		
		assert.equal (test01aCallCount, 2);
	});
	
	
	it ("testDispatchingRemainsTrue", function () {
		
		var test02aCallCount = 0;
		var test02Sequence:string = "";
		var o = new EventDispatcher();
		
		var test02b = function (e:Event):void {
			test02Sequence += "b";
		}
		
		var test02c = function (e:Event):void {
			test02Sequence += "c";
		}
		
		var test02a = function (e:Event):void {
			test02Sequence += "a";
			++test02aCallCount;
			if ( test02aCallCount == 1 ) {
				test02Sequence += "(";
				o.dispatchEvent( new Event( "Test02Event" ) );
				test02Sequence += ")";
				
				// dispatching should still be true here, so this shouldn't modify the list we're traversing over
				// ...but it does...
				o.removeEventListener( "Test02Event", test02b );
				o.addEventListener( "Test02Event", test02c, false, 4 );
				o.addEventListener( "Test02Event", test02b, false, 5 );
			}
		}

		
		// Test 02: Dispatching goes false too soon.
		// The reset of dispatching at the tail of __dispatchEvent,
		// namely the __dispatching.set (event.type, false); line,
		// is unconditional. Clearly we want to keep dispatching true
		// if we're nested, so we should only unset that if we're the
		// "outermost" dispatcher.
		o.addEventListener( "Test02Event", test02a, false, 3 );
		o.addEventListener( "Test02Event", test02b, false, 2 );
		o.addEventListener( "Test02Event", test02c, false, 1 );
		o.dispatchEvent( new Event( "Test02Event" ) );
		
		//assert.equal("a(abc)bc", test02Sequence);
		assert.equal (test02Sequence, "a(abc)c");
	});
	
	
});