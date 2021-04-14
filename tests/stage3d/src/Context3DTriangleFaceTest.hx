package;

import openfl.display3D.Context3DTriangleFace;
import utest.Assert;
import utest.Test;

class Context3DTriangleFaceTest extends Test
{
	public function test_test()
	{
		switch (Context3DTriangleFace.BACK)
		{
			case Context3DTriangleFace.BACK, Context3DTriangleFace.FRONT, Context3DTriangleFace.FRONT_AND_BACK, Context3DTriangleFace.NONE:
				Assert.isTrue(true);
		}
	}
}
