package;

import openfl.events.AsyncErrorEvent;
import utest.Assert;
import utest.Test;

class AsyncErrorEventTest extends Test
{
	public function test_error()
	{
		// TODO: Confirm functionality

		var asyncErrorEvent = new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR);
		var exists = asyncErrorEvent.error;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var asyncErrorEvent = new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR);

		Assert.notNull(asyncErrorEvent);
	}
}
