package;

import openfl.errors.ArgumentError;
import utest.Assert;
import utest.Test;

class ArgumentErrorTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var argumentError = new ArgumentError();
		Assert.notNull(argumentError);
	}
}
