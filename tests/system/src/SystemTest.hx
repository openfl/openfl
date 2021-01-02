package;

import openfl.system.System;
import utest.Assert;
import utest.Test;

class SystemTest extends Test
{
	public function test_totalMemory()
	{
		// TODO: Confirm functionality

		var exists = System.totalMemory;

		Assert.notNull(exists);
	}

	public function test_exit()
	{
		// TODO: Confirm functionality

		var exists = System.exit;

		Assert.notNull(exists);
	}

	public function test_gc()
	{
		// TODO: Confirm functionality

		var exists = System.gc;

		Assert.notNull(exists);
	}
}
