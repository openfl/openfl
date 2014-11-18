package openfl.events;


import massive.munit.Assert;
import openfl.display.Sprite;


class MouseEventTest {
	
	
	@Test public function altKey () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.altKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function buttonDown () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.buttonDown;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function ctrlKey () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.ctrlKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function delta () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.delta;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function localX () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function localY () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localY;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function relatedObject () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		mouseEvent.relatedObject = new Sprite ();
		var exists = mouseEvent.relatedObject;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function shiftKey () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.shiftKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stageX () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageX;
		
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
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageY;
		
		#if cpp
		Assert.areEqual (0, exists);
		#elseif neko
		Assert.isNull (exists);
		#else
		Assert.isNaN (exists);
		#end
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		Assert.isNotNull (mouseEvent);
		
	}
	
	
	@Test public function updateAfterEvent () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.updateAfterEvent;
		
		Assert.isNotNull (exists);
		
	}
	
	
}