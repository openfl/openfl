package;

import openfl.errors.RangeError;
import utest.Assert;
import utest.Test;

class RangeErrorTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var rangeError = new RangeError();
		Assert.notNull(rangeError);
	}
}
