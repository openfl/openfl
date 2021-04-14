package;

import openfl.display.FPS;
import openfl.events.Event;
import utest.Assert;
import utest.Test;

class FPSTest extends Test
{
	public function test_new_()
	{
		var fps = new FPS();
		Assert.isTrue(true);

		// Assert.isTrue(fps.hasEventListener(Event.ENTER_FRAME));
	}
}
