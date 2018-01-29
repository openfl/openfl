package openfl.events;


class SampleDataEventTest { public static function __init__ () { Mocha.describe ("Haxe | SampleDataEvent", function () {
	
	
	Mocha.it ("data", function () {
		
		// TODO:  Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		var exists = sampleDataEvent.data;
		
		// revisit this, perhaps the event should have a null ByteArray, should be populated when dispatched?
		
		//Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("position", function () {
		
		// TODO: Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		var exists = sampleDataEvent.position;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		Assert.notEqual (sampleDataEvent, null);
		
	});
	
	
}); }}