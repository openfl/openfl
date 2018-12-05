import AccelerometerEvent from "openfl/events/AccelerometerEvent";
import * as assert from "assert";


describe ("TypeScript | AccelerometerEvent", function () {
	
	
	it ("accelerationX", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationX;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("accelerationY", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationY;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("accelerationZ", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationZ;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("timestamp", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.timestamp;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		
		assert.notEqual (accelerometerEvent, null);
		
	});
	
	
});