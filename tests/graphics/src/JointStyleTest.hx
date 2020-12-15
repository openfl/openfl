package;

import openfl.display.JointStyle;
import utest.Assert;
import utest.Test;

class JointStyleTest extends Test
{
	public function test_test()
	{
		switch (JointStyle.ROUND)
		{
			case JointStyle.BEVEL, JointStyle.MITER, JointStyle.ROUND:
				Assert.isTrue(true);
		}
	}
}
