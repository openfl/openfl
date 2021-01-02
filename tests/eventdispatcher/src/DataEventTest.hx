package;

import openfl.events.DataEvent;
import utest.Assert;
import utest.Test;

class DataEventTest extends Test
{
	public function test_data()
	{
		// TODO: Confirm functionality

		var dataEvent = new DataEvent(DataEvent.DATA);
		var exists = dataEvent.data;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var dataEvent = new DataEvent(DataEvent.DATA);

		Assert.notNull(dataEvent);
	}
}
