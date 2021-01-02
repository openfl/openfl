package;

import openfl.text.TextFieldType;
import utest.Assert;
import utest.Test;

class TextFieldTypeTest extends Test
{
	public function test_test()
	{
		switch (TextFieldType.DYNAMIC)
		{
			case TextFieldType.DYNAMIC, TextFieldType.INPUT:
				Assert.isTrue(true);
		}
	}
}
