package;

import openfl.display.GraphicsPathWinding;
import utest.Assert;
import utest.Test;

class GraphicsPathWindingTest extends Test
{
	public function test_test()
	{
		switch (GraphicsPathWinding.NON_ZERO)
		{
			case GraphicsPathWinding.EVEN_ODD, GraphicsPathWinding.NON_ZERO:
				Assert.isTrue(true);
		}
	}
}
