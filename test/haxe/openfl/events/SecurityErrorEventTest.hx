package openfl.events;


class SecurityErrorEventTest { public static function __init__ () { Mocha.describe ("Haxe | SecurityErrorEvent", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var securityErrorEvent = new SecurityErrorEvent (SecurityErrorEvent.SECURITY_ERROR);
		Assert.notEqual (securityErrorEvent, null);
		
	});
	
	
}); }}