package;

import massive.munit.Assert;
import openfl.events.TextEvent;

class TextEventTest
{
	@Test public function text()
	{
		// TODO: Confirm functionality

		var textEvent = new TextEvent(TextEvent.LINK);
		var exists = textEvent.text;

		Assert.isNotNull(exists);
	}

	@Test public function new_()
	{
		// TODO: Confirm functionality

		var textEvent = new TextEvent(TextEvent.LINK);
		Assert.isNotNull(textEvent);
	}
}
