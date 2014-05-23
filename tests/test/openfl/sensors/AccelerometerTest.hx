package openfl.sensors;


import massive.munit.Assert;


class AccelerometerTest {
	
	
	@Test public function muted () {
		
		// TODO: Confirm functionality
		
		var accelerometer = new Accelerometer ();
		var exists = accelerometer.muted;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var accelerometer = new Accelerometer ();
		Assert.isNotNull (accelerometer);
		
	}
	
	
	@Test public function setRequestedUpdateInterval () {
		
		// TODO: Confirm functionality
		
		var accelerometer = new Accelerometer ();
		var exists = accelerometer.setRequestedUpdateInterval;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function isSupported () {
		
		// TODO: Confirm functionality
		
		var exists = Accelerometer.isSupported;
		
		Assert.isNotNull (exists);
		
	}
	
	
}