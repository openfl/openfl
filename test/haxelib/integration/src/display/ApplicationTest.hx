package display;

import openfl.display.Application;

class ApplicationTest
{
	@Test public function new_()
	{
		#if lime
		var application = new Application();
		Assert.isNotNull(application);
		#end
	}
}
