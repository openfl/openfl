package;

import openfl.events.AccelerometerEvent;
import utest.Assert;
import utest.Test;

class AccelerometerEventTest extends Test
{
	public function test_accelerationX()
	{
		// TODO: Confirm functionality

		var accelerometerEvent = new AccelerometerEvent(AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationX;

		Assert.notNull(exists);
	}

	public function test_accelerationY()
	{
		// TODO: Confirm functionality

		var accelerometerEvent = new AccelerometerEvent(AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationY;

		Assert.notNull(exists);
	}

	public function test_accelerationZ()
	{
		// TODO: Confirm functionality

		var accelerometerEvent = new AccelerometerEvent(AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.accelerationZ;

		Assert.notNull(exists);
	}

	public function test_timestamp()
	{
		// TODO: Confirm functionality

		var accelerometerEvent = new AccelerometerEvent(AccelerometerEvent.UPDATE);
		var exists = accelerometerEvent.timestamp;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var accelerometerEvent = new AccelerometerEvent(AccelerometerEvent.UPDATE);

		Assert.notNull(accelerometerEvent);
	}
}
