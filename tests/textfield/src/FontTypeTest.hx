package;

import openfl.text.FontType;
import utest.Assert;
import utest.Test;

class FontTypeTest extends Test
{
	public function test_test()
	{
		switch (FontType.DEVICE)
		{
			case FontType.DEVICE, FontType.EMBEDDED, FontType.EMBEDDED_CFF:
				Assert.isTrue(true);
		}
	}
}
