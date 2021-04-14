package;

import openfl.events.UncaughtErrorEvents;
import utest.Assert;
import utest.Test;

class UncaughtErrorEventsTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var uncaughtErrorEvents = new UncaughtErrorEvents();

		Assert.notNull(uncaughtErrorEvents);
	}
}
