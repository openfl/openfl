package;

import openfl.display3D.Context3DBufferUsage;
import utest.Assert;
import utest.Test;

class Context3DBufferUsageTest extends Test
{
	public function test_test()
	{
		switch (Context3DBufferUsage.DYNAMIC_DRAW)
		{
			case Context3DBufferUsage.DYNAMIC_DRAW, Context3DBufferUsage.STATIC_DRAW:
				Assert.isTrue(true);
		}
	}
}
