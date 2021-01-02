package;

import openfl.display3D.Context3DRenderMode;
import utest.Assert;
import utest.Test;

class Context3DRenderModeTest extends Test
{
	public function test_test()
	{
		switch (Context3DRenderMode.AUTO)
		{
			case Context3DRenderMode.AUTO, Context3DRenderMode.SOFTWARE:
				Assert.isTrue(true);
		}
	}
}
