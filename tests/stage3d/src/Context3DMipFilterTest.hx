package;

import openfl.display3D.Context3DMipFilter;
import utest.Assert;
import utest.Test;

class Context3DMipFilterTest extends Test
{
	public function test_test()
	{
		switch (Context3DMipFilter.MIPLINEAR)
		{
			case Context3DMipFilter.MIPLINEAR, Context3DMipFilter.MIPNEAREST, Context3DMipFilter.MIPNONE:
				Assert.isTrue(true);
		}
	}
}
