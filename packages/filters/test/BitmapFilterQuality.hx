import openfl.filters.BitmapFilterQuality;

class BitmapFilterQualityTest
{
	public static function __init__()
	{
		Mocha.describe("BitmapFilterQuality", function()
		{
			Mocha.it("test", function()
			{
				switch (BitmapFilterQuality.HIGH)
				{
					case BitmapFilterQuality.HIGH, BitmapFilterQuality.MEDIUM, BitmapFilterQuality.LOW:
				}
			});
		});
	}
}
