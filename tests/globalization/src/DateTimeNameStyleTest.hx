package;

import openfl.globalization.DateTimeNameStyle;
import utest.Assert;
import utest.Test;

class DateTimeNameStyleTest extends Test
{
	public function test_test()
	{
		switch (DateTimeNameStyle.FULL)
		{
			case DateTimeNameStyle.FULL, DateTimeNameStyle.LONG_ABBREVIATION, DateTimeNameStyle.SHORT_ABBREVIATION:
				Assert.isTrue(true);
		}
	}
}
