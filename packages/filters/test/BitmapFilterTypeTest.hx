import openfl.filters.BitmapFilterType;

class BitmapFilterTypeTest
{
	public static function __init__()
	{
		Mocha.describe("BitmapFilterType", function()
		{
			Mocha.it("test", function()
			{
				switch (BitmapFilterType.FULL)
				{
					case BitmapFilterType.FULL, BitmapFilterType.INNER, BitmapFilterType.OUTER:
				}
			});
		});
	}
}
