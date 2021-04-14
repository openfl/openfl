package;

import openfl.display3D.Context3DTextureFilter;
import utest.Assert;
import utest.Test;

class Context3DTextureFilterTest extends Test
{
	public function test_test()
	{
		switch (Context3DTextureFilter.ANISOTROPIC16X)
		{
			case Context3DTextureFilter.ANISOTROPIC16X, Context3DTextureFilter.ANISOTROPIC2X, Context3DTextureFilter.ANISOTROPIC4X,
				Context3DTextureFilter.ANISOTROPIC8X, Context3DTextureFilter.LINEAR, Context3DTextureFilter.NEAREST:
				Assert.isTrue(true);
		}
	}
}
