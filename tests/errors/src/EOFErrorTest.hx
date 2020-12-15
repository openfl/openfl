package;

import openfl.errors.EOFError;
import utest.Assert;
import utest.Test;

class EOFErrorTest extends Test
{
	public function test_test()
	{
		// TODO: Confirm functionality

		var eofError = new EOFError();
		Assert.notNull(eofError);
	}
}
