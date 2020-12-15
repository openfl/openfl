package;

import openfl.display.CapsStyle;
import utest.Assert;
import utest.Test;

class CapsStyleTest extends Test
{
	public function test_test()
	{
		switch (CapsStyle.SQUARE)
		{
			case CapsStyle.ROUND, CapsStyle.NONE, CapsStyle.SQUARE:
				Assert.isTrue(true);
		}
	}
}
