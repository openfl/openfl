package;

import openfl.display.InterpolationMethod;
import utest.Assert;
import utest.Test;

class InterpolationMethodTest extends Test
{
	public function test_test()
	{
		switch (InterpolationMethod.RGB)
		{
			case InterpolationMethod.LINEAR_RGB, InterpolationMethod.RGB:
				Assert.isTrue(true);
		}
	}
}
