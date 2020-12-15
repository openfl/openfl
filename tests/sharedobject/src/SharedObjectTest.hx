package;

import openfl.net.SharedObject;
import utest.Assert;
import utest.Test;

class SharedObjectTest extends Test
{
	public function test_data()
	{
		// TODO: Confirm functionality

		var sharedObject = SharedObject.getLocal("test");
		var exists = sharedObject.data;

		Assert.notNull(exists);
	}

	public function test_size()
	{
		// TODO: Confirm functionality

		var sharedObject = SharedObject.getLocal("test");
		var exists = sharedObject.size;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var sharedObject = SharedObject.getLocal("test");
		Assert.notNull(sharedObject);
	}

	public function test_clear()
	{
		// TODO: Confirm functionality

		var sharedObject = SharedObject.getLocal("test");
		var exists = sharedObject.clear;

		Assert.notNull(exists);
	}

	public function test_flush()
	{
		// TODO: Confirm functionality

		var sharedObject = SharedObject.getLocal("test");
		var exists = sharedObject.flush;

		Assert.notNull(exists);
	}

	public function test_setProperty()
	{
		// TODO: Confirm functionality

		var sharedObject = SharedObject.getLocal("test");
		var exists = sharedObject.setProperty;

		Assert.notNull(exists);
	}

	public function test_getLocal()
	{
		// TODO: Confirm functionality

		var exists = SharedObject.getLocal;

		Assert.notNull(exists);
	}
}
