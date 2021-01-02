package;

import openfl.display.PNGEncoderOptions;
import utest.Assert;
import utest.Test;

class PNGEncoderOptionsTest extends Test
{
	public function test_fastCompression()
	{
		var pngEncoderOptions = new PNGEncoderOptions();
		var exists = pngEncoderOptions;

		Assert.notNull(exists);
		Assert.isFalse(pngEncoderOptions.fastCompression);

		var pngEncoderOptions = new PNGEncoderOptions(true);
		Assert.isTrue(pngEncoderOptions.fastCompression);
	}
}
