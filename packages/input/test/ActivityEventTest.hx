import openfl.events.ActivityEvent;

class ActivityEventTest
{
	public static function __init__()
	{
		Mocha.describe("ActivityEvent", function()
		{
			Mocha.it("activating", function()
			{
				// TODO: Confirm functionality

				var activityEvent = new ActivityEvent(ActivityEvent.ACTIVITY);
				var exists = activityEvent.activating;

				Assert.notEqual(exists, null);
			});

			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var activityEvent = new ActivityEvent(ActivityEvent.ACTIVITY);

				Assert.notEqual(activityEvent, null);
			});
		});
	}
}
