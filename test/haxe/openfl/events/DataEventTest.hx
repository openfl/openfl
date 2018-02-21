package openfl.events;


class DataEventTest { public static function __init__ () { Mocha.describe ("Haxe | DataEvent", function () {
	
	
	Mocha.it ("data", function () {
		
		// TODO: Confirm functionality
		
		var dataEvent = new DataEvent (DataEvent.DATA);
		var exists = dataEvent.data;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var dataEvent = new DataEvent (DataEvent.DATA);
		
		Assert.notEqual (dataEvent, null);
		
	});
	
	
}); }}