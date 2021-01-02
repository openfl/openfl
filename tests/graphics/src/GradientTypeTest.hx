package;

import openfl.display.GradientType;
import utest.Assert;
import utest.Test;

class GradientTypeTest extends Test
{
	public function test_test()
	{
		// Assert.equals (0, Type.enumIndex (GradientType.LINEAR));
		// Assert.equals (1, Type.enumIndex (GradientType.RADIAL));

		switch (GradientType.RADIAL)
		{
			case GradientType.LINEAR, GradientType.RADIAL:
				Assert.isTrue(true);
		}
	}
}
