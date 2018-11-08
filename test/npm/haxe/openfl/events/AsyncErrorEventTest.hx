package openfl.events;


class AsyncErrorEventTest { public static function __init__ () { Mocha.describe ("Haxe | AsyncErrorEvent", function () {
	
	
	Mocha.it ("error", function () {
		
		// TODO: Confirm functionality
		
		var asyncErrorEvent = new AsyncErrorEvent (AsyncErrorEvent.ASYNC_ERROR);
		var exists = asyncErrorEvent.error;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var asyncErrorEvent = new AsyncErrorEvent (AsyncErrorEvent.ASYNC_ERROR);
		
		Assert.notEqual (asyncErrorEvent, null);
		
	});
	
	
}); }}