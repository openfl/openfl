package;

import openfl.display.PixelSnapping;
import utest.Assert;
import utest.Test;

class PixelSnappingTest extends Test
{
	public function test_test()
	{
		switch (PixelSnapping.NEVER)
		{
			case PixelSnapping.ALWAYS, PixelSnapping.AUTO, PixelSnapping.NEVER:
				Assert.isTrue(true);
		}
	}
}
