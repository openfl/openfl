package;

import openfl.events.KeyboardEvent;
import utest.Assert;
import utest.Test;

class KeyboardEventTest extends Test
{
	public function test_altKey()
	{
		// TODO: Confirm functionality

		var keyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.altKey;

		Assert.notNull(exists);
	}

	public function test_charCode()
	{
		// TODO: Confirm functionality

		var keyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.charCode;

		Assert.notNull(exists);
	}

	public function test_ctrlKey()
	{
		// TODO: Confirm functionality

		var keyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.ctrlKey;

		Assert.notNull(exists);
	}

	public function test_keyCode()
	{
		// TODO: Confirm functionality

		var keyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.keyCode;

		Assert.notNull(exists);
	}

	public function test_shiftKey()
	{
		// TODO: Confirm functionality

		var keyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.shiftKey;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var keyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
		Assert.notNull(keyboardEvent);
	}
}
