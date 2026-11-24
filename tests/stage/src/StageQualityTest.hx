package;

import openfl.display.StageQuality;
import utest.Assert;
import utest.Test;

class StageQualityTest extends Test
{
	public function test_test()
	{
		switch (StageQuality.MEDIUM)
		{
			case StageQuality.BEST, StageQuality.HIGH, StageQuality.LOW, StageQuality.MEDIUM, StageQuality.HIGH_8X8, StageQuality.HIGH_8X8_LINEAR,
				StageQuality.HIGH_16X16, StageQuality.HIGH_16X16_LINEAR:
				Assert.isTrue(true);
		}
	}
}
