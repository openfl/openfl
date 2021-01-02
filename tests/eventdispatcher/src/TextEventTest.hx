package;

import openfl.events.TextEvent;
import utest.Assert;
import utest.Test;

class TextEventTest extends Test
{
	public function test_text()
	{
		// TODO: Confirm functionality

		var textEvent = new TextEvent(TextEvent.LINK);
		var exists = textEvent.text;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var textEvent = new TextEvent(TextEvent.LINK);
		Assert.notNull(textEvent);
	}
}
