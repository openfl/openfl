package;

import openfl.display.SpreadMethod;
import utest.Assert;
import utest.Test;

class SpreadMethodTest extends Test
{
	public function test_test()
	{
		switch (SpreadMethod.REPEAT)
		{
			case SpreadMethod.PAD, SpreadMethod.REFLECT, SpreadMethod.REPEAT:
				Assert.isTrue(true);
		}
	}
}
