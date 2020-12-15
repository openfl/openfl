package;

import openfl.display3D.Context3DWrapMode;
import utest.Assert;
import utest.Test;

class Context3DWrapModeTest extends Test
{
	public function test_test()
	{
		switch (Context3DWrapMode.CLAMP)
		{
			case Context3DWrapMode.CLAMP, Context3DWrapMode.CLAMP_U_REPEAT_V, Context3DWrapMode.REPEAT, Context3DWrapMode.REPEAT_U_CLAMP_V:
				Assert.isTrue(true);
		}
	}
}
