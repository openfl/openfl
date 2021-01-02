package;

import openfl.media.SoundTransform;
import utest.Assert;
import utest.Test;

class SoundTransformTest extends Test
{
	public function test_leftToLeft()
	{
		// TODO: Confirm functionality

		var soundTransform = new SoundTransform();
		var exists = soundTransform.leftToLeft;

		Assert.notNull(exists);
	}

	public function test_leftToRight()
	{
		// TODO: Confirm functionality

		var soundTransform = new SoundTransform();
		var exists = soundTransform.leftToRight;

		Assert.notNull(exists);
	}

	public function test_pan()
	{
		// TODO: Confirm functionality

		var soundTransform = new SoundTransform();
		var exists = soundTransform.pan;

		Assert.notNull(exists);
	}

	public function test_rightToLeft()
	{
		// TODO: Confirm functionality

		var soundTransform = new SoundTransform();
		var exists = soundTransform.rightToLeft;

		Assert.notNull(exists);
	}

	public function test_rightToRight()
	{
		// TODO: Confirm functionality

		var soundTransform = new SoundTransform();
		var exists = soundTransform.rightToRight;

		Assert.notNull(exists);
	}

	public function test_volume()
	{
		// TODO: Confirm functionality

		var soundTransform = new SoundTransform();
		var exists = soundTransform.volume;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var soundTransform = new SoundTransform();
		Assert.notNull(soundTransform);
	}
}
