package;

import openfl.events.FullScreenEvent;
import utest.Assert;
import utest.Test;

class FullScreenEventTest extends Test
{
	public function test_fullscreen()
	{
		// TODO: Confirm functionality

		var fullScreenEvent = new FullScreenEvent(FullScreenEvent.FULL_SCREEN);
		var exists = fullScreenEvent.fullScreen;

		Assert.isFalse(exists);
	}

	public function test_interactive()
	{
		// TODO: Confirm functionality

		var fullScreenEvent = new FullScreenEvent(FullScreenEvent.FULL_SCREEN);
		var exists = fullScreenEvent.interactive;

		Assert.isFalse(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var fullScreenEvent = new FullScreenEvent(FullScreenEvent.FULL_SCREEN);

		Assert.notNull(fullScreenEvent);
	}
}
