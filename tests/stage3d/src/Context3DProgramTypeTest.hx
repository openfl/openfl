package;

import openfl.display3D.Context3DProgramType;
import utest.Assert;
import utest.Test;

class Context3DProgramTypeTest extends Test
{
	public function test_test()
	{
		switch (Context3DProgramType.FRAGMENT)
		{
			case Context3DProgramType.FRAGMENT, Context3DProgramType.VERTEX:
				Assert.isTrue(true);
		}
	}
}
