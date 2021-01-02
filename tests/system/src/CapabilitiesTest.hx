package;

import openfl.system.Capabilities;
import utest.Assert;
import utest.Test;

class CapabilitiesTest extends Test
{
	public function test_language()
	{
		// TODO: Confirm functionality

		var exists = Capabilities.language;

		Assert.notNull(exists);
	}

	public function test_screenDPI()
	{
		// TODO: Confirm functionality

		var exists = Capabilities.screenDPI;

		Assert.notNull(exists);
	}

	public function test_screenResolutionX()
	{
		// TODO: Confirm functionality

		var exists = Capabilities.screenResolutionX;

		Assert.notNull(exists);
	}

	public function test_screenResolutionY()
	{
		// TODO: Confirm functionality

		var exists = Capabilities.screenResolutionY;

		Assert.notNull(exists);
	}
}
