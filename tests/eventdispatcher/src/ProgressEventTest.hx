package;

import openfl.events.ProgressEvent;
import utest.Assert;
import utest.Test;

class ProgressEventTest extends Test
{
	public function test_bytesLoaded()
	{
		// TODO: Confirm functionality

		var progressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
		var exists = progressEvent.bytesLoaded;

		Assert.notNull(exists);
	}

	public function test_bytesTotal()
	{
		// TODO: Confirm functionality

		var progressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
		var exists = progressEvent.bytesTotal;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var progressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
		Assert.notNull(progressEvent);
	}
}
