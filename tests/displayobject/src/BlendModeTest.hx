package;

import openfl.display.BlendMode;
import utest.Assert;
import utest.Test;

class BlendModeTest extends Test
{
	public function test_test()
	{
		switch (BlendMode.SUBTRACT)
		{
			case BlendMode.ADD, BlendMode.ALPHA, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT,
				BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SUBTRACT,
				BlendMode.SHADER:
				Assert.isTrue(true);
		}
	}
}
