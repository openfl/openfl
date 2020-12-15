package;

import openfl.display.TriangleCulling;
import utest.Assert;
import utest.Test;

class TriangleCullingTest extends Test
{
	public function test_test()
	{
		switch (TriangleCulling.NEGATIVE)
		{
			case TriangleCulling.NEGATIVE, TriangleCulling.NONE, TriangleCulling.POSITIVE:
				Assert.isTrue(true);
		}
	}
}
