package openfl.display;


import massive.munit.Assert;
import openfl.display.Application;


class ApplicationTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var application = new Application ();
		var exists = application;
		
		Assert.isNotNull (exists);
		
	}
	
	
}