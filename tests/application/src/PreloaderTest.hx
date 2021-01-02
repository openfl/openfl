package;

import openfl.display.Preloader;
import utest.Assert;
import utest.Test;

class PreloaderTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var preloader = new Preloader();
		var exists = preloader;

		Assert.notNull(exists);
	}
}
