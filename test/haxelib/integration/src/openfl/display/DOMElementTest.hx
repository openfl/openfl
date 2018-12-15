package openfl.display;


import massive.munit.Assert;
import openfl.display.DOMElement;


class DOMElementTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var domElement = new DOMElement (null);
		var exists = domElement;
		
		Assert.isNotNull (exists);
		
	}
	
	
}