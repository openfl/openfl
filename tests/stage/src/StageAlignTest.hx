package;

import openfl.display.StageAlign;
import utest.Assert;
import utest.Test;

class StageAlignTest extends Test
{
	public function test_test()
	{
		switch (StageAlign.TOP_RIGHT)
		{
			case StageAlign.BOTTOM, StageAlign.BOTTOM_LEFT, StageAlign.BOTTOM_RIGHT, StageAlign.LEFT, StageAlign.RIGHT, StageAlign.TOP, StageAlign.TOP_LEFT,
				StageAlign.TOP_RIGHT:
				Assert.isTrue(true);
		}
	}
}
