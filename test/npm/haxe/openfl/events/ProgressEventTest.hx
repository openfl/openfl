package openfl.events;


class ProgressEventTest { public static function __init__ () { Mocha.describe ("Haxe | ProgressEvent", function () {
	
	
	Mocha.it ("bytesLoaded", function () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		var exists = progressEvent.bytesLoaded;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("bytesTotal", function () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		var exists = progressEvent.bytesTotal;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		Assert.notEqual (progressEvent, null);
		
	});
	
	
}); }}