import openfl.display.PNGEncoderOptions;

class PNGEncoderOptionsTest
{
	public static function __init__()
	{
		Mocha.describe("PNGEncoderOptions", function()
		{
			Mocha.it("fastCompression", function()
			{
				var pngEncoderOptions = new PNGEncoderOptions();
				var exists = pngEncoderOptions;

				Assert.notEqual(exists, null);
				Assert.assert(!pngEncoderOptions.fastCompression);

				var pngEncoderOptions = new PNGEncoderOptions(true);
				Assert.assert(pngEncoderOptions.fastCompression);
			});
		});
	}
}
