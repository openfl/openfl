package openfl.events;


import massive.munit.Assert;


class HTTPStatusEventTest {
	
	
	@Test public function responseHeaders () {
		
		#if !flash // throws error when not dispatched
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.responseHeaders;
		
		//Assert.isNotNull (exists);
		
		#end
		
	}
	
	
	@Test public function responseURL () {
		
		#if !flash // throws error when not dispatched
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.responseURL;
		
		//Assert.isNotNull (exists);
		
		#end
		
	}
	
	
	@Test public function status () {
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.status;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		Assert.isNotNull (httpStatusEvent);
		
	}
	
	
}