import openfl.text.GridFitType;

class GridFitTypeTest
{
	public static function __init__()
	{
		Mocha.describe("GridFitType", function()
		{
			Mocha.it("test", function()
			{
				switch (GridFitType.NONE)
				{
					case GridFitType.NONE, GridFitType.PIXEL, GridFitType.SUBPIXEL:
				}
			});
		});
	}
}
