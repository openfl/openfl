package;

import openfl.ui.MultitouchInputMode;
import utest.Assert;
import utest.Test;

class MultitouchInputModeTest extends Test
{
	public function test_test()
	{
		switch (MultitouchInputMode.GESTURE)
		{
			case MultitouchInputMode.GESTURE, MultitouchInputMode.NONE, MultitouchInputMode.TOUCH_POINT:
				Assert.isTrue(true);
		}
	}
}
