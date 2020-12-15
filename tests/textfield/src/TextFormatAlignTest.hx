package;

import openfl.text.TextFormatAlign;
import utest.Assert;
import utest.Test;

class TextFormatAlignTest extends Test
{
	public function test_test()
	{
		switch (TextFormatAlign.CENTER)
		{
			case TextFormatAlign.CENTER, TextFormatAlign.JUSTIFY, TextFormatAlign.LEFT, TextFormatAlign.RIGHT, TextFormatAlign.START, TextFormatAlign.END:
				Assert.isTrue(true);
		}
	}
}
