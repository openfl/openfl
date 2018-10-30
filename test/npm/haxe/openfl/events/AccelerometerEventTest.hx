package openfl.events;


class AccelerometerEventTest { public static function __init__ () { Mocha.describe ("Haxe | AccelerometerEvent", function () {
	
	
	Mocha.it ("accelerationX", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationX;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("accelerationY", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationY;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("accelerationZ", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationZ;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("timestamp", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.timestamp;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		
		Assert.notEqual (accelerometerEvent, null);
		
	});
	
	
}); }}