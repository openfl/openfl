package;

import openfl.display3D.Context3DCompareMode;
import utest.Assert;
import utest.Test;

class Context3DCompareModeTest extends Test
{
	public function test_test()
	{
		switch (Context3DCompareMode.ALWAYS)
		{
			case Context3DCompareMode.ALWAYS, Context3DCompareMode.EQUAL, Context3DCompareMode.GREATER, Context3DCompareMode.GREATER_EQUAL,
				Context3DCompareMode.LESS, Context3DCompareMode.LESS_EQUAL, Context3DCompareMode.NEVER, Context3DCompareMode.NOT_EQUAL:
				Assert.isTrue(true);
		}
	}
}
