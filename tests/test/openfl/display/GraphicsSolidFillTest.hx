package openfl.display;


import massive.munit.Assert;
import openfl.display.GraphicsSolidFill;


class GraphicsSolidFillTest {
	
	
	@Test public function alpha () {
		
		// TODO: Confirm functionality
		
		var solidFill = new GraphicsSolidFill ();
		var exists = solidFill.alpha;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function color () {
		
		// TODO: Confirm functionality
		
		var solidFill = new GraphicsSolidFill ();
		var exists = solidFill.color;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var solidFill = new GraphicsSolidFill ();
		
		Assert.isNotNull (solidFill);
		
	}
	
	
}