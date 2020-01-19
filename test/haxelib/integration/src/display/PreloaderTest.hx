package display;

import massive.munit.Assert;
import openfl.display.Preloader;

class PreloaderTest
{
	@Test public function new_()
	{
		// TODO: Confirm functionality

		#if lime
		var preloader = new Preloader();
		var exists = preloader;

		Assert.isNotNull(exists);
		#end
	}
}
