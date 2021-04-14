package;

import openfl.errors.Error;
import utest.Assert;
import utest.Test;

class ErrorTest extends Test
{
	public function test_errorID()
	{
		// TODO: Confirm functionality

		var error = new Error();
		var exists = error.errorID;

		Assert.notNull(exists);
	}

	public function test_message()
	{
		// TODO: Confirm functionality

		var error = new Error();
		var exists = error.message;

		Assert.notNull(exists);
	}

	public function test_name()
	{
		// TODO: Confirm functionality

		var error = new Error();
		var exists = error.name;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var error = new Error();

		Assert.notNull(error);
	}

	public function test_getStackTrace()
	{
		// TODO: Confirm functionality

		var error = new Error();
		var exists = error.getStackTrace;

		Assert.notNull(exists);
	}
}
