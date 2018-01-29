package openfl.display;


import massive.munit.Assert;


class OpenGLViewTest {
	
	
	@Test public function isSupported () {
		
		#if (flash || console || (js && html5 && canvas))
		Assert.isFalse (OpenGLView.isSupported);
		#else
		Assert.isTrue (OpenGLView.isSupported);
		#end
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var openGLView = new OpenGLView ();
		
		Assert.isNotNull (openGLView);
		
	}
	
	
}