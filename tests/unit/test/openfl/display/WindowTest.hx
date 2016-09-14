package openfl.display;


import massive.munit.Assert;
import openfl.display.Window;


class WindowTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var window = new Window ();
		var exists = window;
		
		Assert.isNotNull (exists);
		
	}
	
	
}