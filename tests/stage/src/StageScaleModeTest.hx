package;

import openfl.display.StageScaleMode;
import utest.Assert;
import utest.Test;

class StageScaleModeTest extends Test
{
	public function test_test()
	{
		switch (StageScaleMode.SHOW_ALL)
		{
			case StageScaleMode.EXACT_FIT, StageScaleMode.NO_BORDER, StageScaleMode.NO_SCALE, StageScaleMode.SHOW_ALL:
				Assert.isTrue(true);
		}
	}
}
