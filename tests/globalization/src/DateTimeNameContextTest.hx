package;

import openfl.globalization.DateTimeNameContext;
import utest.Assert;
import utest.Test;

class DateTimeNameContextTest extends Test
{
	public function test_test()
	{
		switch (DateTimeNameContext.FORMAT)
		{
			case DateTimeNameContext.FORMAT, DateTimeNameContext.STANDALONE:
				Assert.isTrue(true);
		}
	}
}
