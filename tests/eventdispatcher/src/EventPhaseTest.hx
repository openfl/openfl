package;

import openfl.events.EventPhase;
import utest.Assert;
import utest.Test;

class EventPhaseTest extends Test
{
	public function test()
	{
		switch (EventPhase.CAPTURING_PHASE)
		{
			case EventPhase.CAPTURING_PHASE, EventPhase.AT_TARGET, EventPhase.BUBBLING_PHASE:
				Assert.isTrue(true);
		}
	}
}
