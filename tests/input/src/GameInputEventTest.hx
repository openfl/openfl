package;

import openfl.events.GameInputEvent;
import utest.Assert;
import utest.Test;

class GameInputEventTest extends Test
{
	public function test_device()
	{
		// TODO: Confirm functionality

		var gameInputEvent = new GameInputEvent(GameInputEvent.DEVICE_ADDED);
		var exists = gameInputEvent.device;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var gameInputEvent = new GameInputEvent(GameInputEvent.DEVICE_ADDED);

		Assert.notNull(gameInputEvent);
	}
}
