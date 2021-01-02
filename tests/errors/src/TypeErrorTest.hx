package;

import openfl.errors.TypeError;
import utest.Assert;
import utest.Test;

class TypeErrorTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var typeError = new TypeError();
		Assert.notNull(typeError);
	}
}
