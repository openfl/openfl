package;

import openfl.globalization.DateTimeStyle;
import utest.Assert;
import utest.Test;

class DateTimeStyleTest extends Test
{
	public function test_test()
	{
		switch (DateTimeStyle.CUSTOM)
		{
			case DateTimeStyle.CUSTOM, DateTimeStyle.LONG, DateTimeStyle.MEDIUM, DateTimeStyle.NONE, DateTimeStyle.SHORT:
				Assert.isTrue(true);
		}
	}
}
