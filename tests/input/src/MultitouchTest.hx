package;

import openfl.ui.Multitouch;
import utest.Assert;
import utest.Test;

class MultitouchTest extends Test
{
	public function test_inputMode()
	{
		// TODO: Confirm functionality

		var exists = Multitouch.inputMode;

		Assert.notNull(exists);
	}

	public function test_maxTouchPoints()
	{
		// TODO: Confirm functionality

		var exists = Multitouch.inputMode;

		Assert.notNull(exists);
	}

	@Ignored
	public function test_supportedGestures()
	{
		// TODO: Confirm functionality

		var exists = Multitouch.supportedGestures;

		// Is null if not supported
		// Assert.notNull (exists);
	}

	public function test_supportsGestureEvents()
	{
		// TODO: Confirm functionality

		var exists = Multitouch.supportsGestureEvents;

		Assert.notNull(exists);
	}

	public function test_supportsTouchEvents()
	{
		// TODO: Confirm functionality

		var exists = Multitouch.supportsTouchEvents;

		Assert.notNull(exists);
	}
}
