package;

import openfl.sensors.Accelerometer;
import utest.Assert;
import utest.Test;

class AccelerometerTest extends Test
{
	public function test_muted()
	{
		// TODO: Confirm functionality

		var accelerometer = new Accelerometer();
		var exists = accelerometer.muted;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var accelerometer = new Accelerometer();
		Assert.notNull(accelerometer);
	}

	public function test_setRequestedUpdateInterval()
	{
		// TODO: Confirm functionality

		var accelerometer = new Accelerometer();
		var exists = accelerometer.setRequestedUpdateInterval;

		Assert.notNull(exists);
	}

	public function test_isSupported()
	{
		// TODO: Confirm functionality

		var exists = Accelerometer.isSupported;

		Assert.notNull(exists);
	}
}
