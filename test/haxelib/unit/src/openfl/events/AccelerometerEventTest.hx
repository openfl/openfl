package openfl.events;


import massive.munit.Assert;


class AccelerometerEventTest {
	
	
	@Test public function accelerationX () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function accelerationY () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationY;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function accelerationZ () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationZ;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function timestamp () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.timestamp;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var accelerometerEvent = new AccelerometerEvent (AccelerometerEvent.UPDATE);
		
		Assert.isNotNull (accelerometerEvent);
		
	}
	
	
}