package;

import openfl.display.ShaderPrecision;
import utest.Assert;
import utest.Test;

class ShaderPrecisionTest extends Test
{
	public function test_test()
	{
		switch (ShaderPrecision.FAST)
		{
			case ShaderPrecision.FAST, ShaderPrecision.FULL:
				Assert.isTrue(true);
		}
	}
}
