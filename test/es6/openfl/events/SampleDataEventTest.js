import SampleDataEvent from "openfl/events/SampleDataEvent";
import * as assert from "assert";


describe ("ES6 | SampleDataEvent", function () {
	
	
	it ("data", function () {
		
		// TODO:  Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		var exists = sampleDataEvent.data;
		
		// revisit this, perhaps the event should have a null ByteArray, should be populated when dispatched?
		
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("position", function () {
		
		// TODO: Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		var exists = sampleDataEvent.position;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		assert.notEqual (sampleDataEvent, null);
		
	});
	
	
});