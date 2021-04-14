package;

import openfl.display3D.Context3DVertexBufferFormat;
import utest.Assert;
import utest.Test;

class Context3DVertexBufferFormatTest extends Test
{
	public function test_test()
	{
		switch (Context3DVertexBufferFormat.BYTES_4)
		{
			case Context3DVertexBufferFormat.BYTES_4, Context3DVertexBufferFormat.FLOAT_1, Context3DVertexBufferFormat.FLOAT_2,
				Context3DVertexBufferFormat.FLOAT_3, Context3DVertexBufferFormat.FLOAT_4:
				Assert.isTrue(true);
		}
	}
}
