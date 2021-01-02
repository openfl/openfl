package;

import openfl.text.TextFieldAutoSize;
import utest.Assert;
import utest.Test;

class TextFieldAutoSizeTest extends Test
{
	public function test_test()
	{
		switch (TextFieldAutoSize.CENTER)
		{
			case TextFieldAutoSize.CENTER, TextFieldAutoSize.LEFT, TextFieldAutoSize.NONE, TextFieldAutoSize.RIGHT:
				Assert.isTrue(true);
		}
	}
}
