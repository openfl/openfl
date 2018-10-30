package openfl.events;


class HTTPStatusEventTest { public static function __init__ () { Mocha.describe ("Haxe | HTTPStatusEvent", function () {
	
	
	Mocha.it ("responseHeaders", function () {
		
		#if !flash // throws error when not dispatched
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.responseHeaders;
		
		//Assert.notEqual (exists, null);
		
		#end
		
	});
	
	
	Mocha.it ("responseURL", function () {
		
		#if !flash // throws error when not dispatched
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.responseURL;
		
		//Assert.notEqual (exists, null);
		
		#end
		
	});
	
	
	Mocha.it ("status", function () {
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.status;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		Assert.notEqual (httpStatusEvent, null);
		
	});
	
	
}); }}