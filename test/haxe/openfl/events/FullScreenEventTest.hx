package openfl.events;


class FullScreenEventTest { public static function __init__ () { Mocha.describe ("Haxe | FullScreenEvent", function () {
	
	
	Mocha.it ("fullscreen", function () {
		
		// TODO: Confirm functionality
		
		var fullScreenEvent = new FullScreenEvent (FullScreenEvent.FULL_SCREEN);
		var exists = fullScreenEvent.fullScreen;
		
		Assert.assert (!exists);
		
	});
	
	
	Mocha.it ("interactive", function () {
		
		// TODO: Confirm functionality
		
		var fullScreenEvent = new FullScreenEvent (FullScreenEvent.FULL_SCREEN);
		var exists = fullScreenEvent.interactive;
		
		Assert.assert (!exists);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var fullScreenEvent = new FullScreenEvent (FullScreenEvent.FULL_SCREEN);
		
		Assert.notEqual (fullScreenEvent, null);
		
	});
	
	
}); }}