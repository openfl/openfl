package;

import openfl.filters.BitmapFilterType;
import utest.Assert;
import utest.Test;

class BitmapFilterTypeTest extends Test
{
	public function test_test()
	{
		switch (BitmapFilterType.FULL)
		{
			case BitmapFilterType.FULL, BitmapFilterType.INNER, BitmapFilterType.OUTER:
				Assert.isTrue(true);
		}
	}
}
