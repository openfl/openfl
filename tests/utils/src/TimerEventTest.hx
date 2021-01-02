package;

import openfl.events.TimerEvent;
import utest.Assert;
import utest.Test;

class TimerEventTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var timerEvent = new TimerEvent(TimerEvent.TIMER);
		Assert.notNull(timerEvent);
	}

	public function test_updateAfterEvent()
	{
		// TODO: Confirm functionality

		var timerEvent = new TimerEvent(TimerEvent.TIMER);
		var exists = timerEvent.updateAfterEvent;

		Assert.notNull(exists);
	}
}
