package openfl.events;


import massive.munit.Assert;


class AsyncErrorEventTest {
	
	
	@Test public function error () {
		
		// TODO: Confirm functionality
		
		var asyncErrorEvent = new AsyncErrorEvent (AsyncErrorEvent.ASYNC_ERROR);
		var exists = asyncErrorEvent.error;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var asyncErrorEvent = new AsyncErrorEvent (AsyncErrorEvent.ASYNC_ERROR);
		
		Assert.isNotNull (asyncErrorEvent);
		
	}
	
	
}