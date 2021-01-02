package;

import openfl.events.IOErrorEvent;
import utest.Assert;
import utest.Test;

class IOErrorEventTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var ioErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
		Assert.notNull(ioErrorEvent);
	}
}
