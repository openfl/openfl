package openfl.events;


import massive.munit.Assert;


class JoystickEventTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var joystickEvent = new JoystickEvent (JoystickEvent.AXIS_MOVE);
		Assert.isNotNull (joystickEvent);
		
	}
	
	
	@Test public function axis () {
		
		// TODO: Confirm functionality
		
		var joystickEvent = new JoystickEvent (JoystickEvent.AXIS_MOVE);
		var exists = joystickEvent.axis;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function device () {
		
		// TODO: Confirm functionality
		
		var joystickEvent = new JoystickEvent (JoystickEvent.AXIS_MOVE);
		var exists = joystickEvent.device;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function id () {
		
		// TODO: Confirm functionality
		
		var joystickEvent = new JoystickEvent (JoystickEvent.AXIS_MOVE);
		var exists = joystickEvent.id;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function x () {
		
		// TODO: Confirm functionality
		
		var joystickEvent = new JoystickEvent (JoystickEvent.AXIS_MOVE);
		var exists = joystickEvent.x;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function y () {
		
		// TODO: Confirm functionality
		
		var joystickEvent = new JoystickEvent (JoystickEvent.AXIS_MOVE);
		var exists = joystickEvent.y;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function z () {
		
		// TODO: Confirm functionality
		
		var joystickEvent = new JoystickEvent (JoystickEvent.AXIS_MOVE);
		var exists = joystickEvent.z;
		
		Assert.isNotNull (exists);
		
	}
	
	
}