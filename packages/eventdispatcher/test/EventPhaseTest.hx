import openfl.events.EventPhase;

class EventPhaseTest
{
	public static function __init__()
	{
		Mocha.describe("EventPhase", function()
		{
			Mocha.it("test", function()
			{
				switch (EventPhase.CAPTURING_PHASE)
				{
					case EventPhase.CAPTURING_PHASE, EventPhase.AT_TARGET, EventPhase.BUBBLING_PHASE:
				}
			});
		});
	}
}
