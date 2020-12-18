package;

import openfl.events.SampleDataEvent;
import utest.Assert;
import utest.Test;

class SampleDataEventTest extends Test
{
	@Ignored
	public function test_data()
	{
		// TODO:  Confirm functionality

		var sampleDataEvent = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
		var exists = sampleDataEvent.data;

		// revisit this, perhaps the event should have a null ByteArray, should be populated when dispatched?

		// Assert.notNull (exists);
	}

	public function test_position()
	{
		// TODO: Confirm functionality

		var sampleDataEvent = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
		var exists = sampleDataEvent.position;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var sampleDataEvent = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
		Assert.notNull(sampleDataEvent);
	}
}
