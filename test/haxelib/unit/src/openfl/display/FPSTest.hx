package openfl.display;

import openfl.events.Event;
import massive.munit.Assert;

class FPSTest
{
	@Test public function new_()
	{
		var fps = new FPS();

		Assert.isTrue(fps.hasEventListener(Event.ENTER_FRAME));
	}
}
