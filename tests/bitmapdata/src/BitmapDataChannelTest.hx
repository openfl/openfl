package;

import openfl.display.BitmapDataChannel;
import utest.Assert;
import utest.Test;

class BitmapDataChannelTest extends Test
{
	public function test_test()
	{
		switch (BitmapDataChannel.ALPHA)
		{
			case BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE, BitmapDataChannel.GREEN, BitmapDataChannel.RED:
				Assert.isTrue(true);
		}
	}
}
