package;

import openfl.events.ErrorEvent;
import utest.Assert;
import utest.Test;

class ErrorEventTest extends Test
{
	public function test_errorID()
	{
		// TODO: Confirm functionality

		var errorEvent = new ErrorEvent(ErrorEvent.ERROR);
		var exists = errorEvent.errorID;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var errorEvent = new ErrorEvent(ErrorEvent.ERROR);
		Assert.notNull(errorEvent);
	}
}
