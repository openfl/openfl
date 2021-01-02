package;

import openfl.display.LineScaleMode;
import utest.Assert;
import utest.Test;

class LineScaleModeTest extends Test
{
	public function test_test()
	{
		switch (LineScaleMode.VERTICAL)
		{
			case LineScaleMode.HORIZONTAL, LineScaleMode.NONE, LineScaleMode.NORMAL, LineScaleMode.VERTICAL:
				Assert.isTrue(true);
		}
	}
}
