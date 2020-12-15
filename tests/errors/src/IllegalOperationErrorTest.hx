package;

import openfl.errors.IllegalOperationError;
import utest.Assert;
import utest.Test;

class IllegalOperationErrorTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var illegalOperationError = new IllegalOperationError();
		Assert.notNull(illegalOperationError);
	}
}
