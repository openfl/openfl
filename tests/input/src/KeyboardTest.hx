package;

import openfl.ui.Keyboard;
import utest.Assert;
import utest.Test;

class KeyboardTest extends Test
{
	public function test_test()
	{
		var exists = Keyboard.A;

		Assert.notNull(exists);
	}
}
