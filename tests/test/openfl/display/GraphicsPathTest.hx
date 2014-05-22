package openfl.display;


import openfl.display.GraphicsPath;
import massive.munit.Assert;


class GraphicsPathTest {
	
	
	@Test public function commands () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ([]);
		var exists = graphicsPath.commands;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function data () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath (null, []);
		var exists = graphicsPath.data;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function winding () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.winding;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		
		Assert.isNotNull (graphicsPath);
		
	}
	
	
	@Test public function curveTo () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.curveTo;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function lineTo () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.lineTo;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function moveTo () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.moveTo;
		
		Assert.isNotNull (exists);
		
	}
	
	
}