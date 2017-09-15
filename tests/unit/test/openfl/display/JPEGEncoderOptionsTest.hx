package openfl.display;


import massive.munit.Assert;
import openfl.display.JPEGEncoderOptions;


class JPEGEncoderOptionsTest {
	
	
	@Test public function quality () {
		
		var jpegEncoderOptions = new JPEGEncoderOptions ();
		var exists = jpegEncoderOptions;
		
		Assert.isNotNull (exists);
		Assert.areEqual (80, jpegEncoderOptions.quality);
		
		var jpegEncoderOptions = new JPEGEncoderOptions (100);
		Assert.areEqual (100, jpegEncoderOptions.quality);
		
	}
	
	
}