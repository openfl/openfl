package;

import openfl.display3D.Context3DClearMask;
import utest.Assert;
import utest.Test;

class Context3DClearMaskTest extends Test
{
	public function test_test()
	{
		switch (Context3DClearMask.ALL)
		{
			case Context3DClearMask.ALL, Context3DClearMask.COLOR, Context3DClearMask.DEPTH, Context3DClearMask.STENCIL:
				Assert.isTrue(true);
		}
	}
}
