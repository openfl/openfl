package openfl.display;


import massive.munit.Assert;
import openfl.display.BitmapData;
import openfl.display.GraphicsBitmapFill;
import openfl.geom.Matrix;


class GraphicsBitmapFillTest {
	
	
	@Test public function bitmapData () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill (new BitmapData (100, 100));
		var exists = bitmapFill.bitmapData;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function matrix () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill (null, new Matrix ());
		var exists = bitmapFill.matrix;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function repeat () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill.repeat;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function smooth () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill.smooth;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var bitmapFill = new GraphicsBitmapFill ();
		var exists = bitmapFill;
		
		Assert.isNotNull (exists);
		
	}
	
	
}