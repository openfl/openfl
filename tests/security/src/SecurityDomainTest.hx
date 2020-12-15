package;

import openfl.system.SecurityDomain;
import utest.Assert;
import utest.Test;

class SecurityDomainTest extends Test
{
	public function test_currentDomain()
	{
		// TODO: Confirm functionality

		var exists = SecurityDomain.currentDomain;

		Assert.notNull(exists);
	}
}
