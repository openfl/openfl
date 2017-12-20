package openfl.events;


class ErrorEventTest { public static function __init__ () { Mocha.describe ("Haxe | ErrorEvent", function () {
	
	
	Mocha.it ("errorID", function () {
		
		// TODO: Confirm functionality
		
		var errorEvent = new ErrorEvent (ErrorEvent.ERROR);
		var exists = errorEvent.errorID;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var errorEvent = new ErrorEvent (ErrorEvent.ERROR);
		Assert.notEqual (errorEvent, null);
		
	});
	
	
}); }}