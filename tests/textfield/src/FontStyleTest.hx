package;

import openfl.text.FontStyle;
import utest.Assert;
import utest.Test;

class FontStyleTest extends Test
{
	public function test_test()
	{
		switch (FontStyle.BOLD)
		{
			case FontStyle.BOLD, FontStyle.BOLD_ITALIC, FontStyle.ITALIC, FontStyle.REGULAR:
				Assert.isTrue(true);
		}
	}
}
