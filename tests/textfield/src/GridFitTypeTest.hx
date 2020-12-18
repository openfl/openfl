package;

import openfl.text.GridFitType;
import utest.Assert;
import utest.Test;

class GridFitTypeTest extends Test
{
	public function test_test()
	{
		switch (GridFitType.NONE)
		{
			case GridFitType.NONE, GridFitType.PIXEL, GridFitType.SUBPIXEL:
				Assert.isTrue(true);
		}
	}
}
