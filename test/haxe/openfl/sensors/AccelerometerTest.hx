package openfl.sensors;


class AccelerometerTest { public static function __init__ () { Mocha.describe ("Haxe | Accelerometer", function () {
	
	
	Mocha.it ("muted", function () {
		
		// TODO: Confirm functionality
		
		var accelerometer = new Accelerometer ();
		var exists = accelerometer.muted;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var accelerometer = new Accelerometer ();
		Assert.notEqual (accelerometer, null);
		
	});
	
	
	Mocha.it ("setRequestedUpdateInterval", function () {
		
		// TODO: Confirm functionality
		
		var accelerometer = new Accelerometer ();
		var exists = accelerometer.setRequestedUpdateInterval;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("isSupported", function () {
		
		// TODO: Confirm functionality
		
		var exists = Accelerometer.isSupported;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}