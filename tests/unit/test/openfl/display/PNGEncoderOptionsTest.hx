package openfl.display;


import massive.munit.Assert;
import openfl.display.PNGEncoderOptions;


class PNGEncoderOptionsTest {
	
	
	@Test public function fastCompression () {
		
		var pngEncoderOptions = new PNGEncoderOptions ();
		var exists = pngEncoderOptions;
		
		Assert.isNotNull (exists);
		Assert.isFalse (pngEncoderOptions.fastCompression);
		
		var pngEncoderOptions = new PNGEncoderOptions (true);
		Assert.isTrue (pngEncoderOptions.fastCompression);
		
	}
	
	
}