package openfl.display;


class BlendModeTest {
	
	
	@Test public function test () {
		
		switch (BlendMode.SUBTRACT) {
			
			case BlendMode.ADD, BlendMode.ALPHA, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SUBTRACT:
			
			// TODO: Add BlendMode.SHADER?
			#if flash
			case BlendMode.SHADER:
			#end
			
		}
		
	}
	
	
}