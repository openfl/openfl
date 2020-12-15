package;

import openfl.utils.Endian;
import utest.Assert;
import utest.Test;

class EndianTest extends Test
{
	public function test_test()
	{
		switch (Endian.BIG_ENDIAN)
		{
			case Endian.BIG_ENDIAN, Endian.LITTLE_ENDIAN:
				Assert.isTrue(true);
		}
	}
}
