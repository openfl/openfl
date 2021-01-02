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
			case StageQuality.BEST, StageQuality.HIGH, StageQuality.LOW, StageQuality.MEDIUM:
				Assert.isTrue(true);
		}
	}
}
