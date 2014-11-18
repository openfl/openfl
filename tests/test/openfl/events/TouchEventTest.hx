package openfl.events;


import massive.munit.Assert;
import openfl.display.Sprite;


class TouchEventTest {
	
	
	@Test public function altKey () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.altKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function ctrlKey () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.ctrlKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function isPrimaryTouchPoint () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.isPrimaryTouchPoint;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function localX () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.localX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function localY () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.localY;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function pressure () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.pressure;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function relatedObject () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		touchEvent.relatedObject = new Sprite ();
		var exists = touchEvent.relatedObject;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function shiftKey () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.shiftKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function sizeX () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.sizeX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function sizeY () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.sizeY;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stageX () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.stageX;
		
		#if cpp
		Assert.areEqual (0, exists);
		#elseif neko
		Assert.isNull (exists);
		#else
		Assert.isNaN (exists);
		#end
		
	}
	
	
	@Test public function stageY () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.stageY;
		
		#if cpp
		Assert.areEqual (0, exists);
		#elseif neko
		Assert.isNull (exists);
		#else
		Assert.isNaN (exists);
		#end
		
	}
	
	
	@Test public function touchPointID () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.touchPointID;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		Assert.isNotNull (touchEvent);
		
	}
	
	
	@Test public function updateAfterEvent () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.updateAfterEvent;
		
		Assert.isNotNull (exists);
		
	}
	
	
}