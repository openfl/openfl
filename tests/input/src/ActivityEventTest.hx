package;

import openfl.events.ActivityEvent;
import utest.Assert;
import utest.Test;

class ActivityEventTest extends Test
{
	public function test_activating()
	{
		// TODO: Confirm functionality

		var activityEvent = new ActivityEvent(ActivityEvent.ACTIVITY);
		var exists = activityEvent.activating;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var activityEvent = new ActivityEvent(ActivityEvent.ACTIVITY);

		Assert.notNull(activityEvent);
	}
}
