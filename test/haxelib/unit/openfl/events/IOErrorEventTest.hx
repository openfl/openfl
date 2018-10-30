package openfl.events;


import massive.munit.Assert;


class IOErrorEventTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var ioErrorEvent = new IOErrorEvent (IOErrorEvent.IO_ERROR);
		Assert.isNotNull (ioErrorEvent);
		
	}
	
	
}