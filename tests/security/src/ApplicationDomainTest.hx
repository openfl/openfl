package;

import openfl.system.ApplicationDomain;
import utest.Assert;
import utest.Test;

class ApplicationDomainTest extends Test
{
	public function test_parentDomain()
	{
		// TODO: Confirm functionality

		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.parentDomain;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var applicationDomain = ApplicationDomain.currentDomain;
		Assert.notNull(applicationDomain);
	}

	public function test_getDefinition()
	{
		// TODO: Confirm functionality

		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.getDefinition;

		Assert.notNull(exists);
	}

	public function test_hasDefinition()
	{
		// TODO: Confirm functionality

		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.hasDefinition;

		Assert.notNull(exists);
	}

	public function test_currentDomain()
	{
		// TODO: Confirm functionality

		var exists = ApplicationDomain.currentDomain;

		Assert.notNull(exists);
	}
}
