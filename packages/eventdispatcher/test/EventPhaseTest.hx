package;

import massive.munit.Assert;
import openfl.events.EventPhase;

class EventPhaseTest
{
	@Test public function test()
	{
		switch (EventPhase.CAPTURING_PHASE)
		{
			case EventPhase.CAPTURING_PHASE, EventPhase.AT_TARGET, EventPhase.BUBBLING_PHASE:
		}
	}
}
