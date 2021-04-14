package;

import openfl.text.AntiAliasType;
import utest.Assert;
import utest.Test;

class AntiAliasTypeTest extends Test
{
	public function test_test()
	{
		switch (AntiAliasType.ADVANCED)
		{
			case AntiAliasType.ADVANCED, AntiAliasType.NORMAL:
				Assert.isTrue(true);
		}
	}
}
