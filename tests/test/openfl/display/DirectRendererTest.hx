package openfl.display;


import massive.munit.Assert;


class DirectRendererTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var directRenderer = new DirectRenderer ();
		var exists = directRenderer;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function render () {
		
		// TODO: Confirm functionality
		
		var directRenderer = new DirectRenderer ();
		var func = function (_) {};
		directRenderer.render = func;
		var exists = directRenderer.render;
		
		Assert.isNotNull (exists);
		#if (!neko || !lime_legacy)
		Assert.areEqual (func, directRenderer.render);
		#end
		
	}
	
	
}