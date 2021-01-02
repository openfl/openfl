package;

import openfl.events.UncaughtErrorEvent;
import utest.Assert;
import utest.Test;

class UncaughtErrorEventTest extends Test
{
	public function test_info()
	{
		// TODO: Confirm functionality

		var uncaughtErrorEvent = new UncaughtErrorEvent(UncaughtErrorEvent.UNCAUGHT_ERROR);
		var exists = uncaughtErrorEvent.error;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var uncaughtErrorEvent = new UncaughtErrorEvent(UncaughtErrorEvent.UNCAUGHT_ERROR);

		Assert.notNull(uncaughtErrorEvent);
	}
}
