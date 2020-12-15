package;

import openfl.display3D.Context3DTextureFormat;
import utest.Assert;
import utest.Test;

class Context3DTextureFormatTest extends Test
{
	public function test_test()
	{
		switch (Context3DTextureFormat.BGRA)
		{
			case Context3DTextureFormat.BGRA, Context3DTextureFormat.BGRA_PACKED, Context3DTextureFormat.BGR_PACKED, Context3DTextureFormat.COMPRESSED,
				Context3DTextureFormat.COMPRESSED_ALPHA, Context3DTextureFormat.RGBA_HALF_FLOAT:
				Assert.isTrue(true);
		}
	}
}
