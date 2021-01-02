package;

import openfl.display.JPEGEncoderOptions;
import utest.Assert;
import utest.Test;

class JPEGEncoderOptionsTest extends Test
{
	public function test_quality()
	{
		var jpegEncoderOptions = new JPEGEncoderOptions();
		var exists = jpegEncoderOptions;

		Assert.notNull(exists);
		Assert.equals(80, jpegEncoderOptions.quality);

		var jpegEncoderOptions = new JPEGEncoderOptions(100);
		Assert.equals(100, jpegEncoderOptions.quality);
	}
}
