package;

import openfl.errors.SecurityError;
import utest.Assert;
import utest.Test;

class SecurityErrorTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var securityError = new SecurityError();
		Assert.notNull(securityError);
	}
}
