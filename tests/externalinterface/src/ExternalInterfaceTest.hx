package;

import openfl.external.ExternalInterface;
import utest.Assert;
import utest.Test;

class ExternalInterfaceTest extends Test
{
	public function test_available()
	{
		// TODO: Confirm functionality

		var exists = ExternalInterface.available;

		Assert.notNull(exists);
	}

	public function test_marshallExceptions()
	{
		// TODO: Confirm functionality

		var exists = ExternalInterface.marshallExceptions;

		Assert.notNull(exists);
	}

	// public function test_objectID()
	// {
	// 	// TODO: Confirm functionality
	// 	var exists = ExternalInterface.objectID;
	// 	// Might be defined if running IE
	// 	// Assert.isNull (exists);
	// }

	public function test_addCallback()
	{
		// TODO: Confirm functionality

		var exists = ExternalInterface.addCallback;

		Assert.notNull(exists);
	}

	public function test_call()
	{
		// TODO: Confirm functionality

		var exists = ExternalInterface.call;

		Assert.notNull(exists);
	}
}
