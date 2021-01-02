package;

import openfl.errors.IOError;
import utest.Assert;
import utest.Test;

class IOErrorTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var ioError = new IOError();
		Assert.notNull(ioError);
	}
}
