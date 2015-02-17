package openfl.display;


import massive.munit.Assert;
import openfl.display.GraphicsStroke;


class GraphicsStrokeTest {
	
	
	@Test public function caps () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.caps;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function fill () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		stroke.fill = new GraphicsSolidFill ();
		var exists = stroke.fill;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function joints () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.joints;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function miterLimit () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.miterLimit;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function pixelHinting () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.pixelHinting;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function scaleMode () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.scaleMode;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function thickness () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.thickness;
		
		#if (neko && lime_legacy)
		Assert.isNull (exists);
		#else
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		
		Assert.isNotNull (stroke);
		
	}
	
	
}