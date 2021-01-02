package;

import openfl.filters.BitmapFilterQuality;
import utest.Assert;
import utest.Test;

class BitmapFilterQualityTest extends Test
{
	public function test_test()
	{
		switch (BitmapFilterQuality.HIGH)
		{
			case BitmapFilterQuality.HIGH, BitmapFilterQuality.MEDIUM, BitmapFilterQuality.LOW:
				Assert.isTrue(true);
		}
	}
}
