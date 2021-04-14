package;

import openfl.display.StageDisplayState;
import utest.Assert;
import utest.Test;

class StageDisplayStateTest extends Test
{
	public function test_test()
	{
		switch (StageDisplayState.NORMAL)
		{
			case StageDisplayState.FULL_SCREEN, StageDisplayState.FULL_SCREEN_INTERACTIVE, StageDisplayState.NORMAL:
				Assert.isTrue(true);
		}
	}
}
